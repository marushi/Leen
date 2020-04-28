//
//  goodPointPurchaseCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/22.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class goodPointPurchaseCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = backView.frame.size.height / 2
        backView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.6
        backView.layer.shadowRadius = 2
    }
    
    func setData(_ row:Int) {
        switch row {
        case 0:
            backView.backgroundColor = ColorData.darkturquoise
            contentLabel.text = "回復する"
            titleImage.image = UIImage(named: "ticket")
            titleLabel.text = "で回復する"
        case 1:
            backView.backgroundColor = ColorData.blond
            contentLabel.text = "広告を見る"
            titleImage.image = UIImage(systemName: "livephoto.play")
            titleImage.tintColor = ColorData.blond
            titleLabel.text = "広告で無料で回復"
        case 2:
            backView.backgroundColor = ColorData.salmon
            contentLabel.text = "上限を増やす"
            titleImage.image = UIImage(systemName: "hand.thumbsup.fill")
            titleImage.tintColor = ColorData.salmon
            titleLabel.text = "上限を増やす"
        default:
            return
        }
    }

    
}
