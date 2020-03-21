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
    @IBOutlet weak var topLabel: UILabel!
    
    var SetUserDataArray: [ChatRoomData] = []
    var UserArray: [ChatRoomData] = []
    var UserArray2 : [ChatRoomData] = []
    var listener: ListenerRegistration!
    var listener2: ListenerRegistration!
    var DB = ""
    var viewMode = 0
    let userDefaults = UserDefaults.standard
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //部品の設定
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = 70
         
        //その他の設定
        self.navigationController?.navigationBar.barTintColor = ColorData.darkturquoise
        viewMode = 0

        // タイトルを表示するラベルを作成
        titleLabel.text = "通話前"
        titleLabel.textColor = .white
        titleLabel.frame.size.width = self.view.frame.size.width
        titleLabel.frame.size.height = (self.navigationController?.navigationBar.frame.size.height)!
        titleLabel.textAlignment = .center
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(change(_:)))
        titleLabel.addGestureRecognizer(gestureRecognizer)
        titleLabel.isUserInteractionEnabled = true
        navigationItem.titleView = titleLabel
        
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
        //タブバー
        self.tabBarController?.tabBar.isHidden = false
        //navigationbarの色
        if viewMode == 0 {
            self.navigationController?.navigationBar.barTintColor = ColorData.darkturquoise
        }else{
            self.navigationController?.navigationBar.barTintColor = ColorData.salmon
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = nil
    }
    
    //スクロールで隠す
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    //チェンジ処理
    @objc func change(_ sender: Any) {
        
        if viewMode == 0 {
            //モード変更
            viewMode = 1
            //ボタンの変更
            titleLabel.text = "通話後"
            self.navigationController?.navigationBar.barTintColor = ColorData.salmon
            //tabbarのマーク
            let tabBar = self.tabBarController?.tabBar.items![2]
            tabBar?.image = UIImage(systemName: "bubble.left.and.bubble.right")
            tabBar?.selectedImage = UIImage(systemName: "bubble.left.and.bubble.right")
            //ラベルの文字の変更
            topLabel.text = "自由にチャットをして仲を深めよう！"
            topLabel.textColor = ColorData.salmon
            //tableviewのリロード
            tableviewSetUp()
        }else{
            //モード変更
            viewMode = 0
            //ボタンの変更
            titleLabel.text = "通話前"
            self.navigationController?.navigationBar.barTintColor = ColorData.darkturquoise
            //tabbarのマーク
            let tabBar = self.tabBarController?.tabBar.items![2]
            tabBar?.image = UIImage(systemName: "phone")
            tabBar?.selectedImage = UIImage(systemName: "phone")
            //ラベルの文字の変更
            topLabel.text = "チャットで通話する時間を決めよう！"
            topLabel.textColor = ColorData.darkturquoise
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
        TalkCell.selectionStyle = .none
        TalkCell.photo.tag = indexPath.row + 1
        let avatarImage = TalkCell.viewWithTag(indexPath.row + 1) as! UIImageView
        let avatarImageTap = UITapGestureRecognizer(target: self, action: #selector(tappedAvatar))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(avatarImageTap)
        return TalkCell
    }
    
    //セルを選択した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ChatRoom = self.storyboard?.instantiateViewController(identifier: "ChatRoom") as! ChatRoom
        ChatRoom.setData(SetUserDataArray[indexPath.row])
        ChatRoom.chatroommode = viewMode
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
    
    //画像をタップ
    @objc func tappedAvatar(_ sender:UITapGestureRecognizer){
        let image = sender.view as? UIImageView
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        if userDefaults.integer(forKey: "gender") == 1 {
            Profile.setData(SetUserDataArray[image!.tag - 1].female!)
        }else{
            Profile.setData(SetUserDataArray[image!.tag - 1].male!)
        }
        Profile.goodButton.isHidden = true
        present(Profile,animated: true,completion: nil)
    }
    
}

