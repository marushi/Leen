//
//  schedule.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/07.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class schedule: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var dateArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = 50
        
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
    
    @objc func Button(_ sender:Any) {
        tableView.reloadData()
        for _ in 1...5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! scheduleCell
            if cell.textField.text != nil {
                dateArray.append(cell.textField.text!)
                dateArray.remove(value: "")
            }
        }
        let app:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        app.globalDateText = dateArray
        self.dismiss(animated: true, completion: nil)
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
extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}
