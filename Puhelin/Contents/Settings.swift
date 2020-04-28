//
//  Settings.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/10.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class Settings: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let titleArray = ["　　各種設定","　　削除・ブロック"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorData.floralwhite
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = ColorData.floralwhite
    }
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension Settings:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = titleArray[section]
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.frame.size.height = 60
        label.backgroundColor = ColorData.floralwhite
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! settingCell
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            cell.setup(indexPath.row)
        }else {
            cell.setup(indexPath.row + 4)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let UserInformation = self.storyboard?.instantiateViewController(identifier: "UserInformation") as! UserInformation
            self.navigationController?.pushViewController(UserInformation, animated:true)
        case 1:
            let PublishSetting = self.storyboard?.instantiateViewController(identifier: "PublishSetting") as! PublishSetting
            self.navigationController?.pushViewController(PublishSetting, animated: true)
        default:
            return
        }
        /*do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }

        self.dismiss(animated: true, completion: nil)*/
    }
    
    
}
