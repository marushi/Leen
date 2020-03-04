//
//  Talk.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class Talk: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    
    var UserArray: [ChatRoomData] = []
    var listener: ListenerRegistration!
    var DB = ""
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.rowHeight = 90

        //セルの登録
        let nib = UINib(nibName: "TalkCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TalkCell")
        
        //データベースの設定
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
            let Ref = Firestore.firestore().collection(Const.ChatPath).whereField("\(userDefaults.integer(forKey: "gender"))", isEqualTo: userDefaults.string(forKey: "uid")!)
        listener = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.UserArray = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = ChatRoomData(document: document)
                return userData
            }
            // TableViewの表示を更新する
            self.tableView.reloadData()
            }
        }
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserArray.count
        
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TalkCell = tableView.dequeueReusableCell(withIdentifier: "TalkCell", for: indexPath) as! TalkCell
        TalkCell.setData(UserArray[indexPath.row])
        return TalkCell
    }
    
    //セルを選択した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ChatRoom = self.storyboard?.instantiateViewController(identifier: "ChatRoom") as! ChatRoom
        ChatRoom.setData(UserArray[indexPath.row])
        navigationController?.pushViewController(ChatRoom, animated: true)
    }
    
    //スワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("削除する") {
            if editingStyle == .delete {
            //データベースから削除
            let ref = Firestore.firestore()
                let Ref = ref.collection(Const.ChatPath).document(self.UserArray[indexPath.row].roomId!)
            Ref.delete(completion: nil)
            }
            self.UserArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        alertView.addButton("キャンセル",backgroundColor: .lightGray,textColor: .black) {
            return
        }
        alertView.showWarning("本当に削除しますか？", subTitle: "この操作は取り消せません。")
        
    }
}

