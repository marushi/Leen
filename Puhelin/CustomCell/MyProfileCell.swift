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
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var batch: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photo.tintColor = ColorData.darkturquoise
        titleLabel.textColor = .darkGray
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 20
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.borderWidth = 1
        
    }
    
    func setData(_ row: Int){
        
        switch row {
        case 0:
            photo.image = UIImage(systemName: "folder")
            titleLabel.text = "本人確認"
            let ident = UserDefaults.standard.integer(forKey: "identification")
            if ident == 0 {
                contentLabel.text = "未提出"
            }else if ident == 1{
                contentLabel.text = "申請中"
            }else if ident == 2 {
                contentLabel.text = "確認済み"
            }
        case 1:
            photo.image = UIImage(systemName: "book")
            titleLabel.text = "使い方"
            contentLabel.isHidden = true
        case 2:
            photo.image = UIImage(systemName: "bell")
            titleLabel.text = "お知らせ"
            contentLabel.isHidden = true
        
        case 3:
            photo.image = UIImage(systemName: "hand.thumbsup")
            titleLabel.text = "いいね履歴"
            contentLabel.isHidden = true
        
        case 4:
            photo.image = UIImage(systemName: "person.2")
            titleLabel.text = "あしあと"
            contentLabel.isHidden = true
        
        case 5:
            photo.image = UIImage(systemName: "map")
            titleLabel.text = "各種設定"
            contentLabel.isHidden = true
        default:
            return
        }
        
    }
    
}
