//Copyright © 2018 Inloop, s.r.o. All rights reserved.

import UIKit

final class PanGestureTarget {
    /**
     Speed of user movement which triggers spring damping animation
     when view lands at the target drawer position
     */
    private let bounceVelocityThreshold: CGFloat = 100
    private let animationDuration: TimeInterval = 0.25
    private let dampedAnimationDuration: TimeInterval = 0.4
    private let springAnimationDamping: CGFloat = 0.75
    private let targetDimmingViewAlpha: CGFloat = 0.4 // system alert dimming alpha
    /**
     Determines rubber bound behaviour when you drag out of bounds.
     0 means no resistance, 1 means infinite resistance (no movement)
     */
    private let rubberConstant: CGFloat = 0.75
    /// The view of the presenting controller
    private weak var canvasView: UIView!
    private weak var drawerContainerView: UIView!
    private weak var dimmingView: UIView!
    private weak var drawerConfiguration: DrawerConfiguration?
    private weak var drawerPositionDelegate: DrawerPositionDelegate?
    private var initialDrawerCenterLocation: CGPoint = .zero
    private var bottomPositionHeight: CGFloat!
    var basePositionY: CGFloat { return canvasView.frame.height - bottomPositionHeight }
    var topPositionY: CGFloat!

    init(canvasView: UIView,
         drawerContainerView: UIView,
         dimmingView: UIView,
         drawerConfiguration: DrawerConfiguration,
         drawerPositionDelegate: DrawerPositionDelegate?) {
        self.canvasView = canvasView
        self.drawerContainerView = drawerContainerView
        self.dimmingView = dimmingView
        self.drawerConfiguration = drawerConfiguration
        self.drawerPositionDelegate = drawerPositionDelegate
        refreshDrawerPositions()
    }

    internal func refreshDrawerPositions() {
        bottomPositionHeight = drawerConfiguration?.bottomPositionHeight ?? 0
        topPositionY = drawerConfiguration?.topPositionY(in: canvasView.bounds) ?? 0
    }

    deinit {
        dLog("$$$$$$ PanGestureTarget")
    }

    @objc func userDidPan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            initialDrawerCenterLocation = drawerContainerView.center
        } else if recognizer.state == .changed {
            performDrag(recognizer: recognizer)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            let velocity = recognizer.velocity(in: canvasView)
            if shouldFinishUp(recognizer: recognizer) {
                animate(to: topPositionY, velocity: velocity)
            } else {
                animate(to: basePositionY, velocity: velocity)
            }
        }
    }

    private var isDraggedViewWithinAllowedArea: Bool {
        return drawerContainerView.frame.minY > topPositionY && drawerContainerView.frame.minY < basePositionY
    }

    private func performDrag(recognizer: UIPanGestureRecognizer) {
        let changeSincePanBegun = recognizer.translation(in: canvasView).y
        var newCenter = initialDrawerCenterLocation
        newCenter.y += changeSincePanBegun
        let overdraggedDistance = overDragAmount(newCenter)
        if overdraggedDistance != 0 {
            //subtract overdragged rubber bound (kind of)
            let dragDistanceToSubtract = overdraggedDistance * rubberConstant
            newCenter.y -= dragDistanceToSubtract
        }
        drawerContainerView.center = newCenter
        updateDimming()
    }

    private func updateDimming() {
        guard overDragAmount(drawerContainerView.center) == 0 else { return }
        let currentDistanceToBasePosition = basePositionY - drawerContainerView.frame.minY
        let totalDraggableDistance = basePositionY - topPositionY
        let movementPercentage = currentDistanceToBasePosition / totalDraggableDistance
        dimmingView.alpha = movementPercentage * targetDimmingViewAlpha
    }

    private func overDragAmount(_ newCenter: CGPoint) -> CGFloat {
        let newMinY = newCenter.y - drawerContainerView.frame.height/2
        let aboveTop = newMinY - topPositionY
        let underBottom = newMinY - basePositionY
        if aboveTop < 0 {
            return aboveTop
        } else if underBottom > 0 {
            return underBottom
        } else {
            return 0
        }
    }

    private func shouldFinishUp(recognizer: UIPanGestureRecognizer) -> Bool {
        let velocity = recognizer.velocity(in: canvasView)
        let isDraggingSlowly = abs(velocity.y) < bounceVelocityThreshold
        if isDraggingSlowly {
            return isInUpperHalfOfMovement()
        } else {
            let isDraggingUp = velocity.y < 0
            return isDraggingUp
        }
    }

    private func isInUpperHalfOfMovement() -> Bool {
        let allowedMovementMinY = topPositionY!
        let allowedMovementMaxY = basePositionY
        let halfMovement = (allowedMovementMaxY - allowedMovementMinY) / 2
        let movementMidY = allowedMovementMinY + halfMovement
        return drawerContainerView.frame.minY < movementMidY
    }

    private func animate(to minY: CGFloat, velocity: CGPoint) {
        var newFrame = drawerContainerView.frame
        newFrame.origin.y = minY
        let shouldBounce = abs(velocity.y) > bounceVelocityThreshold
        let targetDimmingAlpha = minY == topPositionY ? targetDimmingViewAlpha : CGFloat(0)
        let animationClosure = {
            self.drawerContainerView.frame = newFrame
            self.dimmingView.alpha = targetDimmingAlpha
        }
        let completionClosure: (Bool) -> Void = { finished in
            guard finished else { return }
            if self.isOnTopPosition {
                self.drawerPositionDelegate?.didMoveDrawerToTopPosition()
            } else if self.isOnBasePosition {
                self.drawerPositionDelegate?.didMoveDrawerToBasePosition()
            }
        }
        if shouldBounce {
            UIView.animate(
                withDuration: dampedAnimationDuration,
                delay: 0,
                usingSpringWithDamping: springAnimationDamping,
                initialSpringVelocity: 0,
                options: [.curveEaseOut],
                animations: animationClosure,
                completion: completionClosure
            )
        } else {
            UIView.animate(
                withDuration: animationDuration,
                animations: animationClosure,
                completion: completionClosure
            )
        }
    }

    private var isOnTopPosition: Bool { return Int(drawerContainerView.frame.minY) == Int(topPositionY) }
    private var isOnBasePosition: Bool { return Int(drawerContainerView.frame.minY) == Int(basePositionY) }
}
