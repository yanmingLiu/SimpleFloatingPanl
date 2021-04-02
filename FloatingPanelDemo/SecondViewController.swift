//
//  SecondViewController.swift
//  FloatingPanelDemo
//
//  Created by lym on 2021/3/25.
//

import UIKit

class SecondViewController: UIViewController {
    let cellId = "cell"
    
    var canPush = false

    var tableView = UITableView(frame: .zero, style: .plain)

    var topView: UIView!
    
    deinit {
        print("deinit SecondViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        topView = UIView()
        view.addSubview(topView)

        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = "99条评论"
        titleLabel.font = .boldSystemFont(ofSize: 12)
        topView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true

        let closeBtn = UIButton()
        closeBtn.setTitle("X", for: .normal)
        closeBtn.setTitleColor(.white, for: .normal)
        closeBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        closeBtn.addTarget(self, action: #selector(clickClose), for: .touchUpInside)
        topView.addSubview(closeBtn)

        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -12).isActive = true
        closeBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc private func clickClose() {
        dismiss(animated: true, completion: nil)
    }
}

extension SecondViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if canPush {
            let vc = UIViewController()
            vc.view.backgroundColor = .red
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
