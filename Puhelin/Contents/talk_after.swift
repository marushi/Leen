//
//  talk_after.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/14.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import XLPagerTabStrip

class talk_after: UIViewController ,IndicatorInfoProvider{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nonarray: UILabel!
    
    @objc dynamic static var count:Int = 0
    
    var UserArray2 : [ChatRoomData] = []
    var listener2: ListenerRegistration!
    var adViewType:Int? = 0
    var itemInfo: IndicatorInfo = "通話後"
    
    let userDefaults = UserDefaults.standard
    let gradientLayer: CAGradientLayer = CAGradientLayer()
       

    override func viewDidLoad() {
        super.viewDidLoad()

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
                self.tableView.reloadData()
                if self.UserArray2.count == 0 {
                    self.tableView.isHidden = true
                    self.nonarray.isHidden = false
                }else{
                    self.tableView.isHidden = false
                    self.nonarray.isHidden = true
                }
            }
        }
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension talk_after:UITableViewDataSource,UITableViewDelegate{
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserArray2.count
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TalkCell = tableView.dequeueReusableCell(withIdentifier: "TalkCell", for: indexPath) as! TalkCell
        TalkCell.setData(UserArray2[indexPath.row])
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
        let ChatRoom2 = self.storyboard?.instantiateViewController(identifier: "ChatRoom2") as! ChatRoom2
        ChatRoom2.setData(UserArray2[indexPath.row])
        navigationController?.pushViewController(ChatRoom2, animated: true)
    }
    
    //画像をタップ
    @objc func tappedAvatar(_ sender:UITapGestureRecognizer){
        let image = sender.view as? UIImageView
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        if userDefaults.integer(forKey: "gender") == 1 {
            Profile.setData(UserArray2[image!.tag - 1].female!)
        }else{
            Profile.setData(UserArray2[image!.tag - 1].male!)
        }
        Profile.goodButton.isHidden = true
        present(Profile,animated: true,completion: nil)
    }
    
    //バッチ処理
    @objc func TabbarButch(){
        let tabItem = self.tabBarController?.tabBar.items![2]
        tabItem?.badgeValue = ""
    }
}
