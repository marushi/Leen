//
//  MyProfileCell_2.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class MyProfileCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photo.tintColor = ColorData.darkturquoise
        titleLabel.textColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ row: Int){
        
        switch row {
        case 0:
            photo.image = UIImage(systemName: "tag")
            titleLabel.text = "使い方"
        case 1:
            photo.image = UIImage(systemName: "folder")
            titleLabel.text = "本人確認"
        case 2:
            photo.image = UIImage(systemName: "yensign.circle")
            titleLabel.text = "コイン購入"
        case 3:
            photo.image = UIImage(systemName: "info")
            titleLabel.text = "お問い合わせ"
        default:
            return
        }
        
    }
    
}
