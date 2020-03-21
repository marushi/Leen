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
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textMessage: UITextView!
    
    var jsqMessages:[MessageData]?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textMessage.textContainerInset = UIEdgeInsets.zero
        textMessage.textContainer.lineFragmentPadding = 0
        textMessage.textContainer.maximumNumberOfLines = 2
        textMessage.textContainer.lineBreakMode = .byTruncatingTail
        textMessage.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        photo.layer.cornerRadius = photo.frame.size.width * 0.5
    }
    
    func setData(_ userData: ChatRoomData) {
        var listener: ListenerRegistration!
        var listener2: ListenerRegistration!
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
        
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Users!).document(opUserId!)
            listener = Ref.addSnapshotListener() { (querySnapshot, error) in
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
                }else{
                    self.textMessage.text = ""
                }
            }
        }
    }
}
