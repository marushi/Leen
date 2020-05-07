//
//  UserInformation.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/26.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class UserInformation: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorData.floralwhite
        contentView.backgroundColor = ColorData.floralwhite
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.backgroundColor = ColorData.floralwhite
        logoutButton.layer.cornerRadius = logoutButton.frame.size.height / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        //アラート
        let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("ログアウトする") {
                //探す画面に戻る
                let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }
                self.removeUserDefaults()
                self.dismiss(animated: true, completion: nil)
            }
            alertView.addButton("戻る",backgroundColor: .lightGray,textColor: .black) {
                return
            }
            alertView.showSuccess("ログアウトします。よろしいですか？", subTitle: "ログアウトすると通知などが届かなくなります。")
    }
    
    func removeUserDefaults() {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
}

extension UserInformation:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInformationCell") as! UserInformationCell
        cell.setData(indexPath.row)
        return cell
    }
}
