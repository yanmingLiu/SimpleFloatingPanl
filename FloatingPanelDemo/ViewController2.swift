//
//  ViewController2.swift
//  FloatingPanelDemo
//
//  Created by lym on 2021/3/29.
//

import UIKit

class ViewController2: UIViewController {
    let manager: ModalFloatingPanlManager = ModalFloatingPanlManager()
    let vc2 = SecondViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        vc2.canPush = false
        manager.setup(semiModalViewController: vc2, scrollView: vc2.tableView)
    }

    @IBAction func showFPC(_ sender: Any) {
        present(manager.fpc, animated: true, completion: nil)
    }
}
