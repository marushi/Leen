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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    let intro = "初めまして！プロフィールを見ていただきありがとうございます！"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        introLabel.text = intro
    }
    
    
    func setData(_ userData: UserData) {
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userData.uid + ".jpg")
        photo.sd_setImage(with: imageRef)
        
        name.text = userData.name
        age.text = "\(userData.age!)" + "才　" + "\(userData.region!)"
        
    }

}
