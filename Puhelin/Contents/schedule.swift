//
//  schedule.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/07.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class schedule: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dateArray:[String] = []
    var delegate: ModalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = 45
        titleLabel.backgroundColor = ColorData.whitesmoke
        
        //Modalの設定
        let nav = self.presentingViewController as? UINavigationController
        delegate = nav?.topViewController as? ChatRoom
        
        //UIbuttonの設定
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(Button(_:)), for: UIControl.Event.touchUpInside)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("決定", for: .normal)
        button.frame = CGRect(x: (self.view.frame.width - 200) / 2, y: self.view.frame.height - 50, width: 200, height: 40)
        self.view.addSubview(button)
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func Button(_ sender:Any) {
        tableView.reloadData()
        for _ in 1...5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! scheduleCell
            if cell.textField.text != nil {
                dateArray.append(cell.textField.text!)
                dateArray.remove(value: "")
            }
        }
        self.delegate?.modalDidFinished(modalText: self.dateArray)
        self.dismiss(animated:false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
        let location = touch.location(in: self.view) //in: には対象となるビューを入れます
        let ynum = self.view.frame.size.height - 250
        if location.y < ynum {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! scheduleCell
        cell.setUp(indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}

protocol ModalViewControllerDelegate{
    func modalDidFinished(modalText: [String])
}


