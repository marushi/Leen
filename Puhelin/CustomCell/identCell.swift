//
//  identCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class identCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    //定数
    let imageNameArray:[String] = ["","","",""]
    let titleLabelArray:[String] = ["運転免許証","パスポート","健康保険証","住基カード"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ row:Int) {
        switch row {
        case 0:
            titleLabel.text = titleLabelArray[0]
        
        case 1:
            titleLabel.text = titleLabelArray[1]
        
        case 2:
            titleLabel.text = titleLabelArray[2]
        
        case 3:
            titleLabel.text = titleLabelArray[3]
        default:
            return
        }
    }

}
