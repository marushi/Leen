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
    var profileData:MyProfileData?
    var opUid:String?
    let userDefaults = UserDefaults.standard
    @objc dynamic var noneReadedMes:Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textMessage.textContainerInset = UIEdgeInsets.zero
        textMessage.textContainer.lineFragmentPadding = 0
        textMessage.textContainer.maximumNumberOfLines = 2
        textMessage.textContainer.lineBreakMode = .byTruncatingTail
        textMessage.isUserInteractionEnabled = false
        textMessage.backgroundColor = .white
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
        //画像
        let photoId:String? = profileData?.photoId
        if photoId != "" && photoId != nil{
            self.photo.contentMode = .scaleAspectFill
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(photoId!)
            self.photo.sd_setImage(with: imageRef)
        }else{
            self.photo.contentMode = .scaleAspectFit
            if UserDefaults.standard.integer(forKey: "gender") == 2 {
                self.photo.image = UIImage(named: "male")
            }else{
                self.photo.image = UIImage(named: "female")
            }
        }
        //情報
        if let name = profileData?.name
            ,let age = profileData?.age
            ,let region = profileData?.region {
            self.nameLabel.text = "\(name) " + "\(age)歳 " + "\(region)"
        }
        //最新メッセージ
        if let textData = userData.LastRefreshMessage {
            textMessage.text = textData
        }
        //日付処理
        if let lastDate = userData.LastRefreshTime {
            let date:Timestamp? = lastDate
            let recieveDate: Date = date!.dateValue()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM月dd日"
            let showDate = "\(formatter.string(from: recieveDate))"
            dateLabel.text = "\(showDate)"
        }
        //未読メッセージ処理
        if self.noneReadedMes == 0 {
            noneReadedLabel.isHidden = true
            textMessage.textColor = .lightGray
        }else{
            noneReadedLabel.isHidden = false
            noneReadedLabel.text = String(self.noneReadedMes)
            textMessage.textColor = .darkGray
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
