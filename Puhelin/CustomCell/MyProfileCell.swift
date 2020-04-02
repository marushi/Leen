//
//  MyProfileCell_2.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class MyProfileCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photo.tintColor = ColorData.darkturquoise
        titleLabel.textColor = .darkGray
        
    }
    
    func setData(_ row: Int){
        
        switch row {
        case 0:
            photo.image = UIImage(systemName: "folder.circle")
            titleLabel.text = "本人確認"
        case 1:
            photo.image = UIImage(systemName: "tag.circle")
            titleLabel.text = "使い方"
        case 2:
            photo.image = UIImage(systemName: "info.circle")
            titleLabel.text = "お知らせ"
        default:
            return
        }
        
    }
    
}
