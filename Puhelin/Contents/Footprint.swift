//
//  Footprint.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/08.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase


class Footprint: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var footUsers:[FootUsers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 220
        tableView.tableFooterView = UIView(frame: .zero)
        //セルの登録
        let nib = UINib(nibName: "GoodCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GoodCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(UserDefaults.standard.string(forKey: "uid")!).collection(Const.FoorPrints).order(by: "date" , descending: true).limit(to: 7)
        ref.getDocuments() {(document , error) in
            if let error = error {
                print(error)
                return
            }
            self.footUsers = document!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = FootUsers(document: document)
                return userData
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //戻るボタン
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}

//tableViewの設定
extension Footprint:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return footUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodCell") as! GoodCell
        cell.footUsers = self.footUsers
        cell.setFootData(indexPath.row)
        cell.selectionStyle = .none
        cell.footBool = true
        return cell
    }
    //セルをタップした時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.setData(footUsers[indexPath.row].uid!)
        Profile.ButtonMode = 2
        present(Profile,animated: true,completion: nil)
    }
    
}


//dataクラス
class FootUsers:NSObject{
    var date:Timestamp?
    var uid:String?
    
    init(document: DocumentSnapshot) {
        self.uid = document.documentID
        self.date = document.get("date") as? Timestamp
    }
}
