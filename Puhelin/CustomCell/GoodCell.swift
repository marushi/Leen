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
import AudioToolbox
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
        textView.backgroundColor = .white
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
    
    func setFootData(_ data:FootUsers) {
        goodButton.setTitle("いいね！", for: .normal)
        //日付処理
        let date:Timestamp? = data.date
        let recieveDate: Date = date!.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        let showDate = "\(formatter.string(from: recieveDate))"
        dateLabel.text = "\(showDate)"
        //データ入れ
        self.name.text = profileData?.name
        let age:Int? = profileData?.age
        let region:String? = profileData?.region
        self.age.text = "\(age!)" + "才　" + "\(region!)"
        self.intro.text = profileData?.intro
        //いいねしているかどうか
        let select = fromAppDelegate.selectIdArray
        if select.firstIndex(of: profileData!.uid) != nil {
            goodButton.setTitle("いいね！済み", for: .normal)
            goodButton.backgroundColor = .lightGray
            goodButton.isEnabled = false
        }
    }
    
    //いいねリスト用
    func setData(_ goodData: goodData) {
        //データ入れ
        Goods = goodData
        opUserId = goodData.uid
        //日付入れ
        if let goodDate = goodData.date {
            let date:Timestamp? = goodDate
            let recieveDate: Date = date!.dateValue()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM月dd日"
            let showDate = "\(formatter.string(from: recieveDate))"
            self.dateLabel.text = "\(showDate)"
        }
        
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(opUserId!)
            listener = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
                self.profileData = MyProfileData(document: querySnapshot!)
                //画像設定
                //自分の情報を設定
                if self.profileData?.photoId != "" && self.profileData?.photoId != nil{
                    self.photo.contentMode = .scaleAspectFill
                    let imageRef = Storage.storage().reference().child(Const.ImagePath).child((self.profileData?.photoId!)!)
                    self.photo.sd_setImage(with: imageRef)
                }else{
                    self.photo.contentMode = .scaleAspectFit
                    if UserDefaults.standard.integer(forKey: "gender") == 2 {
                        self.photo.image = UIImage(named: "male")
                    }else{
                        self.photo.image = UIImage(named: "female")
                    }
                }
                //その他情報設定
                self.name.text = querySnapshot?.get("name") as? String
                self.intro.text = querySnapshot?.get("intro") as? String
                let age = querySnapshot?.get("age")
                let region = querySnapshot?.get("region")
                self.age.text = "\(age!)" + "才　" + "\(region!)"
                
            }
        }
    }
    
    @IBAction func Button(_ sender: Any) {
        
        if footBool == false{
        
        //HUD
        HUD.flash(.success,delay: 0.5)
        AudioServicesPlaySystemSound(1520)
        
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
                ,"name2": self.profileData?.name as Any
                ,"LastRefreshTime":Date()
                ,"LastRefreshMessage":"いいねありがとうございます！"]
                as [String : Any]
            ChatRef.setData(DIc)
            let MesRef = ChatRef.collection(Const.MessagePath).document()
            let Dic = ["senderId": userDefaults.string(forKey: "uid") as Any
                ,"displayName": userDefaults.string(forKey: "name") as Any
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
            let Dic = ["senderId": userDefaults.string(forKey: "uid") as Any
                ,"displayName": userDefaults.string(forKey: "name") as Any
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
            //remaingoodnum
            var remainNum = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
            remainNum -= 1
            self.userDefaults.set(remainNum, forKey: UserDefaultsData.remainGoodNum)
            //-------------------------
        }
    }
}
