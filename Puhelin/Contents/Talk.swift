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
    

    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topLabel: UILabel!
    
    var SetUserDataArray: [ChatRoomData] = []
    var UserArray: [ChatRoomData] = []
    var UserArray2 : [ChatRoomData] = []
    var listener: ListenerRegistration!
    var listener2: ListenerRegistration!
    var DB = ""
    var viewMode = 0
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = 60
        viewMode = 0
        
        //チェンジボタンの設定
        changeButton.setTitleColor(.white, for: .normal)
        changeButton.backgroundColor = .init(red: 0, green: 206/255, blue: 209/255, alpha: 1)
        changeButton.layer.cornerRadius = 10
        changeButton.setTitle("通話前", for: .normal)
        

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
        
        //下のバーを表示する
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        //トーク前のデータ取得
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
                self.tableviewSetUp()
            }
        }
        
        //通話後のデータ取得
        if listener2 == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.MatchingPath).whereField("\(userDefaults.integer(forKey: "gender"))", isEqualTo: userDefaults.string(forKey: "uid")!)
            listener2 = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.UserArray2 = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = ChatRoomData(document: document)
                return userData
                }
            
                // TableViewの表示を更新する
                self.tableviewSetUp()
            }
        }
    }
    
    //チェンジ処理
    @IBAction func change(_ sender: Any) {
        
        if viewMode == 0 {
            //モード変更
            viewMode = 1
            
            //ボタンの変更
            changeButton.setTitle("通話後", for: .normal)
            changeButton.backgroundColor = .init(red: 1, green: 127/255, blue: 80/255, alpha: 1)
            changeButton.setTitleColor(.white, for: .normal)
            
            //tabbarのマーク
            let tabBar = self.tabBarController?.tabBar.items![2]
            tabBar?.image = UIImage(systemName: "bubble.left.and.bubble.right")
            tabBar?.selectedImage = UIImage(systemName: "bubble.left.and.bubble.right")
            
            //ラベルの文字の変更
            topLabel.text = "自由にチャットをして仲を深めよう！"
            
            //tableviewのリロード
            tableviewSetUp()
        }else{
            //モード変更
            viewMode = 0
            
            //ボタンの変更
            changeButton.setTitle("通話前", for: .normal)
            changeButton.backgroundColor = .init(red: 0, green: 206/255, blue: 209/255, alpha: 1)
            changeButton.setTitleColor(.white, for: .normal)
            
            //tabbarのマーク
            let tabBar = self.tabBarController?.tabBar.items![2]
            tabBar?.image = UIImage(systemName: "phone")
            tabBar?.selectedImage = UIImage(systemName: "phone")
            
            //ラベルの文字の変更
            topLabel.text = "チャットで通話する時間を決めよう！"
            
            //tableviewのリロード
            tableviewSetUp()
        }
        
    }
    
    func tableviewSetUp() {
        if viewMode == 0 {
            self.SetUserDataArray = self.UserArray
            self.tableView.reloadData()
        }else{
            self.SetUserDataArray = self.UserArray2
            self.tableView.reloadData()
        }
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetUserDataArray.count
        
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TalkCell = tableView.dequeueReusableCell(withIdentifier: "TalkCell", for: indexPath) as! TalkCell
        TalkCell.setData(SetUserDataArray[indexPath.row])
        return TalkCell
    }
    
    //セルを選択した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ChatRoom = self.storyboard?.instantiateViewController(identifier: "ChatRoom") as! ChatRoom
        ChatRoom.setData(SetUserDataArray[indexPath.row])
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
                let Ref = ref.collection(Const.ChatPath).document(self.SetUserDataArray[indexPath.row].roomId!)
                let messeageRef = ref.collection(Const.ChatPath).document(self.SetUserDataArray[indexPath.row].roomId!).collection(Const.MessagePath)
                Ref.delete(completion: nil)
                messeageRef.document().delete()
            }
            self.SetUserDataArray.remove(at: indexPath.row)
            if self.viewMode == 0 {
                self.UserArray.remove(at: indexPath.row)
            }else{
                self.UserArray2.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        alertView.addButton("キャンセル",backgroundColor: .lightGray,textColor: .black) {
            return
        }
        alertView.showWarning("本当に削除しますか？", subTitle: "この操作は取り消せません。")
    }
    
    
}

