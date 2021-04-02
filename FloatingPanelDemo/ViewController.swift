//
//  ViewController.swift
//  FloatingPanelDemo
//
//  Created by lym on 2021/3/25.
//

import UIKit

class ViewController: UIViewController {
    
    let manager = ChildFloatingPanlManager()
    let vc2 = SecondViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        
        vc2.canPush = true
        manager.setup(childViewController: vc2, scrollView: vc2.tableView)
        
        manager.onWillRemove = {[weak self] in
            self?.tabBarController?.tabBar.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }

    @IBAction func show(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = true

        manager.fpc.addPanel(toParent: self, animated: true)
        
    }
}
