//
//  TalkCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class TalkCell: UITableViewCell {
    
    @IBOutlet weak var noneReadedLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textMessage: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var jsqMessages:[MessageData]?
    @objc dynamic var noneReadedMes:Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textMessage.textContainerInset = UIEdgeInsets.zero
        textMessage.textContainer.lineFragmentPadding = 0
        textMessage.textContainer.maximumNumberOfLines = 2
        textMessage.textContainer.lineBreakMode = .byTruncatingTail
        textMessage.isUserInteractionEnabled = false
        noneReadedLabel.layer.cornerRadius = noneReadedLabel.frame.size.height / 2
        noneReadedLabel.clipsToBounds = true
        noneReadedLabel.isHidden = true
        photo.layer.cornerRadius = photo.frame.size.width * 0.5
        self.addObserver(self, forKeyPath: "noneReadedMes", options: [.old,.new], context: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ userData: ChatRoomData) {
        var listener2: ListenerRegistration!
        var listener3: ListenerRegistration!
        var opUserId:String?
        var Users:String?
        
        //性別毎に相手のuidを取得
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            opUserId = userData.female
            Users = "Female_Users"
        }else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            opUserId = userData.male
            Users = "Male_Users"
        }
        
        let Ref = Firestore.firestore().collection(Users!).document(opUserId!)
        Ref.getDocument() { (querySnapshot, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            return
        }
        self.photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(querySnapshot?.get("photoId") as! String)
        self.photo.sd_setImage(with: imageRef)
        let name = querySnapshot?.get("name") as! String
        let age = querySnapshot?.get("age") as! Int
        let region = querySnapshot?.get("region") as! String
        self.nameLabel.text = "\(name) " + "\(age)歳 " + "\(region)"
        }
        
        if listener2 == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.ChatPath).document(userData.roomId!).collection(Const.MessagePath).order(by: "sendTime",descending: true).limit(to: 1)
            listener2 = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
                self.jsqMessages = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT_Message: document取得 \(document.documentID)")
                    let mesData = MessageData(document: document)
                    return mesData
                }
                if self.jsqMessages!.count != 0 {
                    self.textMessage.text = self.jsqMessages![0].text
                    let date:Timestamp = self.jsqMessages![0].sendTime!
                    let recieveDate: Date = date.dateValue()
                    // 日付のフォーマット
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM月dd日"
                    //(from: datePicker.date))を指定してあげることで
                    //datePickerで指定した日付が表示される
                    let showDate = "\(formatter.string(from: recieveDate))"
                    self.dateLabel.text = "\(showDate)"
                }else{
                    self.textMessage.text = ""
                }
            }
        }
        if listener3 == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.ChatPath).document(userData.roomId!).collection(Const.MessagePath).whereField("readed", isEqualTo: false).whereField("senderId", isEqualTo: opUserId!)
                listener3 = Ref.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
                }
                    if querySnapshot?.count != 0 {
                        self.noneReadedLabel.isHidden = false
                        self.noneReadedMes = querySnapshot!.count
                        self.noneReadedLabel.text = "\(String(describing: self.noneReadedMes))"
                    }else{
                        self.noneReadedLabel.isHidden = true
                        self.noneReadedMes = 0
                    }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let preNum:Int = change![.oldKey] as! Int
        let newNum:Int = change![.newKey] as! Int
        let plusNum:Int = newNum - preNum
        if preNum == newNum{
            return
        }else{
            if plusNum < 0 {
                return
            }
            talk_before.count += plusNum
            NotificationCenter.default.post(name: .NewMessage, object: nil)
        }
    }
}
