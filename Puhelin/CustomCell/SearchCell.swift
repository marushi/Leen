//
//  SearchCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import FirebaseUI

class SearchCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var sentenceMes: UITextView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var identLabel: UILabel!
    @IBOutlet weak var phoneimage: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //アウトレットの設定
        photo.layer.cornerRadius = 10
        sentenceMes.textContainerInset = UIEdgeInsets.zero
        sentenceMes.textContainer.lineFragmentPadding = 0
        sentenceMes.isUserInteractionEnabled = false
        dateLabel.backgroundColor = .red
        dateLabel.layer.cornerRadius = 10
        dateLabel.clipsToBounds = true
        dateLabel.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        identLabel.clipsToBounds = true
        identLabel.layer.cornerRadius = 10
        identLabel.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
        identLabel.isHidden = true
        phoneLabel.isHidden = true
        phoneimage.isHidden = true
    }
    
    //データセット
    func setData(_ userData: UserData) {
        
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userData.photoId!)
        photo.sd_setImage(with: imageRef)
        
        //その他データ
        age.text = "\(userData.age!)" + "才"
        regionLabel.text = "\(userData.region!)"
        sentenceMes.text = userData.sentenceMessage
        
        //本人確認済みかどうか
        if userData.identification == true {
            identLabel.isHidden = false
            phoneimage.isHidden = false
            phoneLabel.isHidden = false
        } else {
            identLabel.isHidden = true
            phoneimage.isHidden = true
            phoneLabel.isHidden = true
        }
        
        let weekAgo = Date(timeIntervalSinceNow: -60*60*24*4)
        let signupDate: Date = userData.signupDate!.dateValue()
        if signupDate < weekAgo {
            dateLabel.isHidden = true
        }else{
            dateLabel.isHidden = false
        }
        
    }

}
