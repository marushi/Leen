//
//  TalkCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import FirebaseUI

class TalkCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ userData: UserData) {
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userData.uid + ".jpg")
        photo.sd_setImage(with: imageRef)
        
    }
    @IBAction func callButton(_ sender: Any) {
    }
    
}
