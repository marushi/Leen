//
//  Good.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class Good: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var UserArray: [UserData] = []
    var listener: ListenerRegistration!
    var DB = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource  = self

        //セルの登録
        let nib = UINib(nibName: "GoodCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GoodCell")
        
        
        self.view.backgroundColor = .brown
        
        if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        } else if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(DB).document(Auth.auth().currentUser!.uid).collection(Const.GoodPath)
        listener = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.UserArray = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = UserData(document: document)
                return userData
            }
            // TableViewの表示を更新する
            self.tableView.reloadData()
            
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let GoodCell = tableView.dequeueReusableCell(withIdentifier: "GoodCell", for: indexPath) as! GoodCell
        let TopCell = tableView.dequeueReusableCell(withIdentifier: "TopCell")
        if indexPath.row == 0 {
            tableView.rowHeight = 50
            TopCell?.selectionStyle = .none
            return TopCell!
        }else{
            tableView.rowHeight = 240
            GoodCell.setData(UserArray[indexPath.row - 1])
            return GoodCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.userInfo = UserArray[indexPath.row - 1]
        Profile.ButtonAppear = false
        present(Profile,animated: true,completion: nil)
    }

    

}
