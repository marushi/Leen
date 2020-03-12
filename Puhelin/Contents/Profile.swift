//
//  Profile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import FirebaseUI

extension Profile:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.personality0 = personality0
        cell.personality1 = personality1
        cell.personality2 = personality2
        cell.setUp(indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
}

class Profile: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var sentenceMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    //定数変数
    let goodButton = UIButton(type: .system)
    let userDefaults = UserDefaults.standard

    //可変変数
    var userInfo: UserData!
    var ButtonMode:Int?
    var listener: ListenerRegistration!
    var opUserId:String?
    var Users:String?
    var profileData:MyProfileData?
    var personality0: [String]? = ["どちらでも"]
    var personality1: [String]? = ["どちらでも"]
    var personality2: [String]? = ["どちらでも"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //photo設定
        photo.layer.cornerRadius = photo.frame.width * 0.5
        
        //view設定
        view3.layer.cornerRadius = 10
        view4.layer.cornerRadius = 10
        
        //tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        
        
        //設定
        introTextView.isUserInteractionEnabled = false
        
        self.view.backgroundColor = .init(red: 1, green: 0.9, blue: 0.9, alpha: 1)
        self.view2.backgroundColor = .init(red: 1, green: 0.9, blue: 0.9, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ButtonMode == 1{
            goodButton.setTitle("いいね！", for: .normal)
        }else if ButtonMode == 2 {
            goodButton.setTitle("話してみる！", for: .normal)
        }else {
            goodButton.setTitle("編集する", for: .normal)
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController!.navigationBar.shadowImage = UIImage()
        }
        //ボタンの設定
        goodButton.addTarget(self, action: #selector(Button(_:)), for: UIControl.Event.touchUpInside)
        goodButton.layer.cornerRadius = 10
        goodButton.backgroundColor = UIColor.init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        goodButton.setTitleColor(.white, for: .normal)
        goodButton.frame = CGRect(x: (self.view.frame.width - 300) / 2, y: self.view.frame.height - 100, width: 300, height: 40)
        self.view.addSubview(goodButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if ButtonMode == 3 {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController!.navigationBar.shadowImage = nil
        }
    }
    
    //戻るボタン
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //いいねユーザーを取得する時
    func setData(_ userData: UserData) {
        
        //UserInfoにデータを入れる
        self.userInfo = userData
        
        //性別毎に相手のuidを取得
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            opUserId = userData.uid
            Users = "Female_Users"
        }else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            opUserId = userData.uid
            Users = "Male_Users"
        }
        
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Users!).document(opUserId!)
        listener = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
            //画像設定
            self.photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(querySnapshot?.get("photoId") as! String)
            self.photo.sd_setImage(with: imageRef)
            //その他情報設定
            let name = querySnapshot?.get("name")
            let age =  querySnapshot?.get("age")
            let region = querySnapshot?.get("region")
            let intro = querySnapshot?.get("intro")
            let sentenceMes = querySnapshot?.get("sentenceMessage")
            self.name.text = name as? String
            self.age.text = "\(age!)才　" + "\(region!)"
            self.introTextView.text = intro! as? String
            self.sentenceMessage.text = sentenceMes! as? String
            self.personality0 = querySnapshot?.get("Personality.0") as? [String]
            self.personality1 = querySnapshot?.get("Personality.1") as? [String]
            self.personality2 = querySnapshot?.get("Personality.2") as? [String]
            self.tableView.reloadData()
            }
        }
    }
    
    func profileSetData(){
        
        ButtonMode = 3
        var DB = ""
        
        //自分の性別を入れる
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }
        
        let Ref = Firestore.firestore().collection(DB).document(userDefaults.string(forKey: "uid")!)
        Ref.getDocument() { (document, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            return
            }
            self.profileData = MyProfileData(document: document!)
            //自分の情報を設定
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(self.profileData!.photoId!)
            self.photo.sd_setImage(with: imageRef)
            
            let name = self.profileData!.name
            let age = self.profileData!.age
            let region = self.profileData!.region
            let intro = self.profileData!.intro
            let sentenceMes = self.profileData!.sentenceMessage
            self.name.text = name
            self.age.text = "\(age!)才　" + "\(region!)"
            self.introTextView.text = intro!
            self.sentenceMessage.text = sentenceMes!
            self.personality0 = self.profileData!.personality0
            self.personality1 = self.profileData!.personality1
            self.personality2 = self.profileData!.personality2
            self.tableView.reloadData()
        }
    }
    
    //イイネボタンの処理
    @objc func Button(_ sender: Any) {
        if ButtonMode == 1{
            let Ref = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "DB")!).document(userInfo.uid).collection(Const.GoodPath).document(userDefaults.string(forKey: "uid")!)
            let Dic = ["uid": userDefaults.string(forKey: "uid")!] as [String: Any]
                Ref.setData(Dic)
                self.dismiss(animated: true, completion: nil)
        }else if ButtonMode == 2 {
            //HUD
            HUD.flash(.success,delay: 0.5)
            
            //チャットルーム作成
            let ChatRef = Firestore.firestore().collection(Const.ChatPath).document()
            if UserDefaults.standard.integer(forKey: "gender") == 1 {
                let DIc = ["1": userDefaults.string(forKey: "uid")!,"2": opUserId!]
                    as [String : Any]
                ChatRef.setData(DIc)
                let ref = Firestore.firestore().collection(Const.MalePath).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
                ref.delete()
            
            } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
                let DIc = ["2": userDefaults.string(forKey: "uid")!
                    ,"1": opUserId!] as [String : Any]
                ChatRef.setData(DIc)
                let ref = Firestore.firestore().collection(Const.FemalePath).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
                ref.delete()
            }
            self.dismiss(animated: true, completion: nil)
        }else {
            let EditProfile = self.storyboard?.instantiateViewController(identifier: "EditProfile") as! EditProfile
            EditProfile.profileData = self.profileData
            self.navigationController?.pushViewController(EditProfile, animated: true)
        }
    }
}
