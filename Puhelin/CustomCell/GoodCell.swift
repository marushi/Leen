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
    
    var UserArray: UserData!
    var listener: ListenerRegistration!
    var opUserId:String?
    var Users:String?
    let userdefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.maximumNumberOfLines = 5
        textView.isEditable = false
        
        photo.layer.cornerRadius = photo.frame.size.width * 0.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ userData: UserData) {
        UserArray = userData
        
        //性別毎に相手のuidを取得
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
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
            self.name.text = querySnapshot?.get("name") as! String
            self.intro.text = querySnapshot?.get("intro") as! String
            }
        }
    }
    
    @IBAction func Button(_ sender: Any) {
        //HUD
        HUD.flash(.success,delay: 0.5)
        
        //チャットルーム作成
        let ChatRef = Firestore.firestore().collection(Const.ChatPath).document()
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            let DIc = ["1": userdefaults.string(forKey: "uid")!,"2": UserArray.uid]
                as [String : Any]
            ChatRef.setData(DIc)
            let ref = Firestore.firestore().collection(Const.MalePath).document(userdefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
            ref.delete()
        
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            let DIc = ["2": userdefaults.string(forKey: "uid")!
                ,"1": UserArray.uid] as [String : Any]
            ChatRef.setData(DIc)
            let ref = Firestore.firestore().collection(Const.FemalePath).document(userdefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
            ref.delete()
        }
    }
}