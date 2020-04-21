//
//  GoodCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import FirebaseUI
import SCLAlertView

class GoodCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var intro: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var Goods: goodData!
    var listener: ListenerRegistration!
    var opUserId:String?
    var Users:String?
    var profileData:MyProfileData?
    //足跡用
    var footUsers:[FootUsers] = []
    var footBool:Bool = false
    
    let userDefaults = UserDefaults.standard
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.maximumNumberOfLines = 4
        textView.isUserInteractionEnabled = false
        
        photo.layer.cornerRadius = photo.frame.size.width * 0.1
        
        goodButton.layer.cornerRadius = goodButton.frame.size.height / 2
        goodButton.backgroundColor = UIColor.init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        goodButton.setTitleColor(.white, for: .normal)
        goodButton.setTitle("話してみる！", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setFootData(_ row:Int) {
        goodButton.setTitle("いいね！", for: .normal)
        //日付処理
        let date:Timestamp? = footUsers[row].date
        let recieveDate: Date = date!.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        let showDate = "\(formatter.string(from: recieveDate))"
        dateLabel.text = "\(showDate)"
        //データ入れ
        let id:String = footUsers[row].uid!
        self.opUserId = id
        let ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(id)
        ref.getDocument(){(document,error) in
            if let error = error{
                print(error)
                return
            }
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(document?.get("photoId") as! String)
            self.photo.sd_setImage(with: imageRef)
            self.name.text = document?.get("name") as? String
            let age:Int = document?.get("age") as! Int
            let region:String = document?.get("region") as! String
            self.age.text = "\(age)" + "才　" + "\(region)"
            self.intro.text = document?.get("sentenceMessage") as? String
        }
        //いいねしているかどうか
        let select = fromAppDelegate.selectIdArray
        if select.firstIndex(of: id) != nil {
            goodButton.setTitle("いいね！済み", for: .normal)
            goodButton.backgroundColor = .lightGray
            goodButton.isEnabled = false
        }
    }
    
    //いいねリスト用
    func setData(_ goodData: goodData) {
        //データ入れ
        Goods = goodData
        //日付入れ
        //日付処理
        dateLabel.isHidden = true
        
        //性別毎に相手のuidを取得
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            opUserId = goodData.uid
            Users = "Female_Users"
        }else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            opUserId = goodData.uid
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
                self.profileData = MyProfileData(document: querySnapshot!)
            //画像設定
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(querySnapshot!.get("photoId") as! String)
            self.photo.sd_setImage(with: imageRef)
            //その他情報設定
            self.name.text = querySnapshot?.get("name") as? String
            self.intro.text = querySnapshot?.get("intro") as? String
            let age = querySnapshot?.get("age")
            let region = querySnapshot?.get("region")
            self.age.text = "\(age!)" + "才　" + "\(region!)"
            //日付処理
            let date:Timestamp? = querySnapshot?.get("date") as? Timestamp
            let recieveDate: Date = date!.dateValue()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM月dd日"
            let showDate = "\(formatter.string(from: recieveDate))"
            self.dateLabel.text = "\(showDate)"
            }
        }
    }
    
    @IBAction func Button(_ sender: Any) {
        
        if footBool == false{
        
        //HUD
        HUD.flash(.success,delay: 0.5)
        
        //チャットルーム作成
        let ChatRef = Firestore.firestore().collection(Const.ChatPath).document()
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            let DIc = ["1": userDefaults.string(forKey: "uid")!
                ,"2": Goods.uid as Any
                ,"3": false
                ,"4": false
                ,"token1": userDefaults.string(forKey: "token")!
                ,"token2": self.profileData?.token as Any
                ,"name1": userDefaults.string(forKey: "name")!
                ,"name2": self.profileData?.name as Any]
                as [String : Any]
            ChatRef.setData(DIc)
            let MesRef = ChatRef.collection(Const.MessagePath).document()
            let Dic = ["senderId": userDefaults.string(forKey: UserDefaultsData.uid) as Any
                ,"displayName": userDefaults.string(forKey: UserDefaultsData.name) as Any
                ,"text": "いいねありがとうございます！"
                ,"sendTime": Date() as Any] as [String:Any]
            MesRef.setData(Dic)
            
            let ref = Firestore.firestore().collection(Const.MalePath).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
            ref.delete()
        
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            let DIc = ["2": userDefaults.string(forKey: "uid")!
                ,"1": Goods.uid as Any
                ,"3": false
                ,"4": false
                ,"token2": userDefaults.string(forKey: "token")!
                ,"token1": self.profileData?.token as Any
                ,"name2": userDefaults.string(forKey: "name")!
                ,"name1": self.profileData?.name as Any] as [String : Any]
            ChatRef.setData(DIc)
            let MesRef = ChatRef.collection(Const.MessagePath).document()
            let Dic = ["senderId": userDefaults.string(forKey: UserDefaultsData.uid) as Any
                ,"displayName": userDefaults.string(forKey: UserDefaultsData.name) as Any
                ,"text": "いいねありがとうございます！"
                ,"sendTime": Date() as Any] as [String:Any]
            MesRef.setData(Dic)
            
            let ref = Firestore.firestore().collection(Const.FemalePath).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
            ref.delete()
            }
        }else if footBool == true{
            //相手のいいねリストに自分を追加
            let Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(opUserId!).collection(Const.GoodPath).document(userDefaults.string(forKey: "uid")!)
            let Dic = ["uid": userDefaults.string(forKey: "uid")!
                ,"name":userDefaults.string(forKey: "name")!
                ,"date":Date()] as [String: Any]
                Ref.setData(Dic)
            //自分のセレクトリストに相手を保存
            let selectRef = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!).collection(Const.SelectUsers).document(opUserId!)
            let selectDic = ["uid": opUserId!,"date":Date()] as [String : Any]
            selectRef.setData(selectDic)
            //--------ポイント処理-------
            //goodpoint
            var goodpoint = self.userDefaults.integer(forKey: UserDefaultsData.GoodPoint)
            goodpoint -= 1
            self.userDefaults.set(goodpoint, forKey: UserDefaultsData.GoodPoint)
            //remaingoodnum
            var remainNum = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
            remainNum -= 1
            self.userDefaults.set(remainNum, forKey: UserDefaultsData.remainGoodNum)
            //-------------------------
        }
    }
}
