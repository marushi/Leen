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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photo.layer.cornerRadius = photo.frame.size.width * 0.1
        //photo.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        //view.backgroundColor = .init(red: 1, green: 248/255, blue: 240/255, alpha: 1)
        
        sentenceMes.textContainerInset = UIEdgeInsets.zero
        sentenceMes.textContainer.lineFragmentPadding = 0
        //sentenceMes.backgroundColor = .init(red: 1, green: 248/255, blue: 240/255, alpha: 1)
        sentenceMes.isUserInteractionEnabled = false
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
        
    }

}
