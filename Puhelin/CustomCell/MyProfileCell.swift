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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ row: Int){
        
        switch row {
        case 0:
            
            titleLabel.text = "自己紹介・性格入力"
        case 1:
            
            titleLabel.text = "使い方"
        case 2:
            
            titleLabel.text = "本人確認"
        case 3:
            
            titleLabel.text = "コイン購入"
        case 4:
            
            titleLabel.text = "お問い合わせ"
        default:
            return
        }
        
    }
    
}
