//  Copyright © 2018 Inloop. All rights reserved.

import UIKit

class MainViewController: UIViewController {
    @IBAction func push(_ sender: Any) {
        let controller = makeContentViewController()
        controller.setup(for: .fullScreen)
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func presentInDrawer(_ sender: Any) {
        let controller = makeContentViewController()
        controller.setup(for: .drawer)
        navigationController?.displayInDrawer(controller, drawerPositionDelegate: nil)
    }

    private func makeContentViewController() -> ContentViewController {
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        let result = storyboard.instantiateInitialViewController() as! ContentViewController
        return result
    }
}
