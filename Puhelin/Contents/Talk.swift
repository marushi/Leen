//
//  Talk.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class Talk: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    
    var UserArray: [UserData] = []
    var listener: ListenerRegistration!
    var DB = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource  = self

        //セルの登録
        let nib = UINib(nibName: "TalkCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TalkCell")
        
         
        self.view.backgroundColor = .brown
        tableView.rowHeight = 90
        
        if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        } else if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //上のバーを消す、下のバーを表示
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.ChatPath).whereField("\(UserDefaults.standard.integer(forKey: "gender"))", isEqualTo: UserDefaults.standard.string(forKey: "uid")!)
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
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TalkCell = tableView.dequeueReusableCell(withIdentifier: "TalkCell", for: indexPath) as! TalkCell
        //TalkCell.setData(UserArray[indexPath.row])
        return TalkCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toChat", sender: nil)
    }
    
   
   
}
