//  Copyright © 2018 Inloop. All rights reserved.

import UIKit
import UIViewController_DisplayInDrawer

class MainViewController: UIViewController {
    @IBOutlet weak var changeContentButton: UIButton!
    @IBOutlet weak var useMiddlePositionSwitch: UISwitch!
    @IBOutlet weak var presentInDrawerButton: UIButton!
    @IBOutlet weak var pushButton: UIButton!

    weak var drawerContentController: ContentViewController? {
        didSet {
            refreshButtons()
        }
    }

    @IBAction func push(_ sender: Any) {
        let controller = makeContentViewController()
        controller.setup(for: .fullScreen)
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func presentInDrawer(_ sender: Any) {
        let controller = makeContentViewController()
        controller.setup(for: .drawer(useMiddlePosition: useMiddlePositionSwitch.isOn))
        navigationController?.displayInDrawer(controller, drawerPositionDelegate: self)
        drawerContentController = controller
    }

    private func makeContentViewController() -> ContentViewController {
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        let result = storyboard.instantiateInitialViewController() as! ContentViewController
        return result
    }

    @IBAction func useMiddlePositionSwitchDidChangeValue(_ sender: Any) {
        drawerContentController?.dismiss()
    }
    
    @IBAction func changeContentButtonPressed(_ sender: Any) {
        drawerContentController?.changeContent()
    }

    private func refreshButtons() {
        if drawerContentController != nil {
            changeContentButton.isEnabled = true
            presentInDrawerButton.isEnabled = false
            pushButton.isEnabled = false
        } else {
            changeContentButton.isEnabled = false
            presentInDrawerButton.isEnabled = true
            pushButton.isEnabled = true
        }
    }
}

extension MainViewController: DrawerPositionDelegate {
    func didMoveDrawerToTopPosition() {
        NSLog("did move drawer to top position")
    }

    func didMoveDrawerToMiddlePosition() {
        NSLog("did move drawer to middle position")
    }

    func didMoveDrawerToBasePosition() {
        NSLog("did move drawer to base position")
    }
    
    func willDismissDrawer() {
        NSLog("will dismiss drawer")
    }

    func didDismissDrawer() {
        // didSet is not called when ARC releases weak property, we must force it manually. Moreover we have to wait for ARC to kick in.
        DispatchQueue.main.async {
            self.refreshButtons()
        }
        NSLog("did dismiss drawer")
    }
}
