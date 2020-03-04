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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photo.layer.cornerRadius = photo.frame.size.width * 0.1
        photo.layer.borderColor = CGColor.init(srgbRed: 0, green: 1, blue: 1, alpha: 1)
        photo.layer.borderWidth = 0.5
    }
    
    //データセット
    func setData(_ userData: UserData) {
        
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userData.photoId!)
        photo.sd_setImage(with: imageRef)
        
        //その他データ
        name.text = userData.name
        age.text = "\(userData.age!)" + "才　" + "\(userData.region!)"
        introLabel.text = userData.intro
        
    }

}
