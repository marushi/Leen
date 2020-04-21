//
//  talk_before.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/14.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import XLPagerTabStrip

class talk_before: UIViewController,IndicatorInfoProvider {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nonarray1: UILabel!
    @IBOutlet weak var nonarray2: UILabel!
    
    @objc dynamic static var count:Int = 0
    var UserArray: [ChatRoomData] = []
    var listener: ListenerRegistration!
    var adViewType:Int? = 0
    var itemInfo: IndicatorInfo = "通話前"
    
    let userDefaults = UserDefaults.standard
    let gradientLayer: CAGradientLayer = CAGradientLayer()
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(TabbarButch), name: .NewMessage, object: nil)
        //セルの登録
        let nib = UINib(nibName: "TalkCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TalkCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
         //トーク前のデータ取得
        if listener == nil{
            // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.ChatPath).whereField("\(userDefaults.integer(forKey: "gender"))", isEqualTo: userDefaults.string(forKey: "uid")!).order(by: "LastRefreshTime",descending: true)
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
                self.tableView.reloadData()
                if self.UserArray.count == 0 {
                    self.tableView.isHidden = true
                    self.nonarray1.isHidden = false
                    self.nonarray2.isHidden = false
                }else{
                    self.tableView.isHidden = false
                    self.nonarray1.isHidden = true
                    self.nonarray2.isHidden = true
                }
            }
        }
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension talk_before:UITableViewDelegate,UITableViewDataSource {
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserArray.count
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TalkCell = tableView.dequeueReusableCell(withIdentifier: "TalkCell", for: indexPath) as! TalkCell
        TalkCell.setData(UserArray[indexPath.row])
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
                let messeageRef = ref.collection(Const.ChatPath).document(self.UserArray[indexPath.row ].roomId!).collection(Const.MessagePath)
                Ref.delete(completion: nil)
                messeageRef.document().delete()
            }
            self.UserArray.remove(at: indexPath.row)
            self.UserArray.remove(at: indexPath.row)
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
            Profile.setData(UserArray[image!.tag - 1].female!)
        }else{
            Profile.setData(UserArray[image!.tag - 1].male!)
        }
        Profile.goodButton.isHidden = true
        present(Profile,animated: true,completion: nil)
    }
    
    //バッチ処理
    @objc func TabbarButch(){
        let tabItem = self.tabBarController?.tabBar.items![2]
        tabItem?.badgeValue = "\(talk_before.count)"
        if talk_before.count <= 0 {
            tabItem?.badgeValue = nil
        }
    }
}
