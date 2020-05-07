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
        backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        backView.layer.shadowColor = UIColor.darkGray.cgColor
        backView.layer.shadowOpacity = 0.6
        backView.layer.shadowRadius = 1
        
    }
    
    func setData(_ row: Int){
        backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.6
        backView.layer.shadowRadius = 1
        photo.tintColor = ColorData.darkturquoise
        switch row {
        case 0:
            photo.image = UIImage(systemName: "folder")
            titleLabel.text = "本人確認"
            contentLabel.isHidden = false
            let ident = UserDefaults.standard.integer(forKey: UserDefaultsData.identification)
            if ident == 0 {
                contentLabel.text = "未提出"
            }else if ident == 1{
                contentLabel.text = "申請中"
                backView.layer.shadowOffset = CGSize(width: 0, height: 0)
                backView.layer.shadowOpacity = 0
                backView.layer.shadowRadius = 0
                photo.tintColor = .lightGray
            }else if ident == 2 {
                contentLabel.text = "確認済み"
                backView.layer.shadowOffset = CGSize(width: 0, height: 0)
                backView.layer.shadowOpacity = 0
                backView.layer.shadowRadius = 0
                photo.tintColor = .lightGray
            }else {
                contentLabel.text = "確認エラー"
                photo.tintColor = .red
            }
        case 1:
            photo.image = UIImage(systemName: "hand.thumbsup")
            titleLabel.text = "いいね履歴"
            contentLabel.isHidden = true
        case 2:
            photo.image = UIImage(systemName: "person.2")
            titleLabel.text = "あしあと"
            contentLabel.isHidden = true
        case 3:
            photo.image = UIImage(systemName: "map")
            titleLabel.text = "設定"
            contentLabel.isHidden = true
        default:
            return
        }
        
    }
    
}
