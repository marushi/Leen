//
//  MypageHeader.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/20.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class MypageHeader: UICollectionViewCell {
    //部品
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(_ row:Int){
        switch row {
        case 0:
            imageview.image = UIImage(systemName: "hand.thumbsup.fill")
            imageview.tintColor = ColorData.salmon
            titleLabel.text = "残いいね"
            contentLabel.text = "10"
        case 1:
            imageview.image = UIImage()
            titleLabel.text = "会員ステータス"
            contentLabel.text = "無料会員"
            contentLabel.textColor = .lightGray
        case 2:
            imageview.image = UIImage(systemName: "p.circle.fill")
            imageview.tintColor = ColorData.blond
            titleLabel.text = "残ポイント"
            contentLabel.text = "15"
        default:
            return
        }
    }
}
