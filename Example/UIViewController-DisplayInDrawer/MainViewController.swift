//  Copyright © 2018 Inloop. All rights reserved.

import UIKit
import UIViewController_DisplayInDrawer

class MainViewController: UIViewController {
    @IBOutlet weak var useMiddlePositionSwitch: UISwitch!
    weak var drawerContentController: ContentViewController?
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
        NSLog("did dismiss drawer")
    }
}
