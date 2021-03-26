//
//  ViewController.swift
//  FloatingPanelDemo
//
//  Created by lym on 2021/3/25.
//

import UIKit

class ViewController: UIViewController {
    
    // 必须作为一个变量来持有
    var manager: SimpleFloatingPanlManager = SimpleFloatingPanlManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(frame: CGRect(x: 20, y: 100, width: 140, height: 40))
        btn.backgroundColor = .systemTeal;
        btn.setTitle("抖音评论弹窗", for: .normal)
        btn.addTarget(self, action: #selector(clickShow), for: .touchUpInside)
        view.addSubview(btn)
        btn.center = view.center
    }
    
    @objc func clickShow() {
        let vc2 = SecondViewController()
        manager.setup(semiModalViewController: vc2, scrollView: vc2.tableView)
        present(manager.fpc, animated: true, completion: nil)
    }

}

