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
    @IBOutlet weak var tagImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //アウトレットの設定
        photo.layer.cornerRadius = 20
        sentenceMes.textContainerInset = UIEdgeInsets.zero
        sentenceMes.textContainer.lineFragmentPadding = 0
        sentenceMes.isUserInteractionEnabled = false
        dateLabel.backgroundColor = ColorData.salmon
        dateLabel.layer.cornerRadius = 10
        dateLabel.clipsToBounds = true
        dateLabel.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
    }
    
    //データセット
    func setData(_ userData: UserData) {
        
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userData.photoId!)
        photo.sd_setImage(with: imageRef)
        
        //その他データ
        age.text = "\(userData.age!)" + "才　" + "\(userData.region!)"
        sentenceMes.text = userData.sentenceMessage
        
        //本人確認済みかどうか
        if userData.identification == true {
            tagImage.tintColor = ColorData.darkturquoise
        } else {
            tagImage.tintColor = ColorData.naplesYellow
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
