//  Copyright © 2018 Inloop. All rights reserved.

import UIKit
import UIViewController_DisplayInDrawer

enum ContentMode {
    case fullScreen
    case drawer

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
    @IBOutlet private var panGestureRecognizer: UIPanGestureRecognizer!
    private var panGestureTarget: Any? //You are required to keep a strong reference of it.
    private var mode: ContentMode!

    /*
     Do not change these, only use them if needed. They are supplied by the drawer embed mechanism
     (see DrawerConfiguration) and you should call them if user presses dismiss button, or when layout changed
     */
    var drawerDismissClosure: (() -> Void)?
    var didChangeLayoutClosure: (() -> Void)?

    deinit {
        NSLog("$$$$$$ ContentViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction private func dismiss() {
        drawerDismissClosure?()
    }

    private func setupMode() {
        view.backgroundColor = mode.config.backgroundColor
        closeButton.isHidden = mode.config.isCloseButtonHidden
    }
}

extension ContentViewController: DrawerConfiguration {
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
        guard isViewLoaded else { return nil }
        return parentHeight - separatorView.frame.minY
    }

    func bottomPositionY(for parentHeight: CGFloat) -> CGFloat {
        guard isViewLoaded else { return 0 }
        return parentHeight - 18
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
}

extension UITextView {
    func heightThatReallyFits() -> CGFloat {
        let contentHeight = sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)).height
        return textContainerInset.top + contentHeight + textContainerInset.bottom
    }
}
