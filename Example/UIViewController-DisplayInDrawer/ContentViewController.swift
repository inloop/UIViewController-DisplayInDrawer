//  Copyright © 2018 Inloop. All rights reserved.

import UIKit
import UIViewController_DisplayInDrawer

enum ContentMode {
    case fullScreen
    case drawer(useMiddlePosition: Bool)

    var config: ContentConfig {
        switch self {
        case .fullScreen:
            return ContentConfig(backgroundColor: .white, isCloseButtonHidden: true)
        case .drawer:
            return ContentConfig(backgroundColor: .clear, isCloseButtonHidden: false)
        }
    }
}

struct ContentConfig {
    let backgroundColor: UIColor
    let isCloseButtonHidden: Bool
}

class ContentViewController: UIViewController {
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var panGestureRecognizer: UIPanGestureRecognizer!
    private var panGestureTarget: Any? //You are required to keep a strong reference of it.
    private var mode: ContentMode!

    /*
     Do not change these, only use them if needed. They are supplied by the drawer embed mechanism
     (see DrawerConfiguration) and you should call them if user presses dismiss button, or when layout changed
     */
    var drawerDismissClosure: (() -> Void)?
    var didChangeLayoutClosure: (() -> Void)?
    var drawerPullDownClosure: (() -> Void)?
    
    deinit {
        NSLog("$$$$$$ ContentViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = defaultText
        setupMode()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        didChangeLayoutClosure?()
    }

    func setup(for mode: ContentMode) {
        self.mode = mode
        guard isViewLoaded else { return }
        setupMode()
    }

    func changeContent() {
        toggleText()
        toggleImage()
    }

    @IBAction func dismiss() {
        drawerDismissClosure?()
    }

    private func setupMode() {
        view.backgroundColor = mode.config.backgroundColor
        closeButton.isHidden = mode.config.isCloseButtonHidden
    }

    private let defaultText = "DEFAULT TEXT: Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    private let defaultImageViewWidthConstant: CGFloat = 0
    private let shorterText = "SHORTER TEXT: Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"
    private let smallerImageviewWidthConstant: CGFloat = -50

    private func toggleImage() {
        if imageViewWidthConstraint.constant == defaultImageViewWidthConstant {
            imageViewWidthConstraint.constant = smallerImageviewWidthConstant
        } else {
            imageViewWidthConstraint.constant = defaultImageViewWidthConstant
        }
    }

    private func toggleText() {
        if textView.text == defaultText {
            textView.text = shorterText
        } else {
            textView.text = defaultText
        }
    }
}

extension ContentViewController: DrawerConfiguration {
    var drawerBackgroundColor: UIColor {
        return .clear //this is the default, could be omitted
    }

    var drawerCornerRadius: CGFloat {
        return 10 //this is the default, could be omitted
    }

    func topPositionY(for parentHeight: CGFloat) -> CGFloat {
        guard isViewLoaded else { return 0 }
        /*
         You can return constant, but this is a more dynamic example:
         How to avoid making the drawer unneccessarily larger than its content
         */
        let minimalTopPosition: CGFloat = 50
        let idealTopPosition = parentHeight - contentDerivedHeight()
        let result = fmax(minimalTopPosition, idealTopPosition)
        return result
    }

    func middlePositionY(for parentHeight: CGFloat) -> CGFloat? {
        guard isViewLoaded, useMiddlePosition else { return nil }
        return halfOpenPositionY(for: parentHeight)
    }

    func bottomPositionY(for parentHeight: CGFloat) -> CGFloat {
        guard isViewLoaded else { return 0 }
        if useMiddlePosition {
            return parentHeight - 18 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        } else {
            return halfOpenPositionY(for: parentHeight)
        }
    }

    func setPanGestureTarget(_ target: Any, action: Selector) {
        panGestureRecognizer.addTarget(target, action: action)
        panGestureTarget = target
    }

    private func contentDerivedHeight() -> CGFloat {
        let fixedContentHeight = textView.frame.minY
        let scrollableContentHeight = textView.heightThatReallyFits()
        let bottomPadding: CGFloat = 16
        return fixedContentHeight + scrollableContentHeight + bottomPadding
    }

    private var useMiddlePosition: Bool {
        guard let mode = mode,
            case let ContentMode.drawer(useMiddlePosition) = mode else {
                return false
        }
        return useMiddlePosition
    }

    private func halfOpenPositionY(for parentHeight: CGFloat) -> CGFloat {
        return parentHeight - separatorView.frame.minY
    }
}

extension UITextView {
    func heightThatReallyFits() -> CGFloat {
        let contentHeight = sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)).height
        return textContainerInset.top + contentHeight + textContainerInset.bottom
    }
}
