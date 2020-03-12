//
//  SearchConditionsCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/06.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class SearchConditionsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    var personality1:Int! = 0
    var personality2:Int! = 0
    var personality3:Int! = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(_ row:Int){
        switch row {
        case 0:
            titleLabel.text = "居住地"
        case 1:
            titleLabel.text = "年齢"
        case 2:
            titleLabel.text = "いつも話すときは"
            switch personality1 {
            case 0:
                subLabel.text = "こだわらない"
            case 1:
                subLabel.text = "話す方"
            case 2:
                subLabel.text = "聞く方"
            default:
                return
            }
        case 3:
            titleLabel.text = "出会いの目的は"
            switch personality2 {
            case 0:
                subLabel.text = "こだわらない"
            case 1:
                subLabel.text = "ライトな関係"
            case 2:
                subLabel.text = "真剣交際"
            default:
                return
            }
        case 4:
            titleLabel.text = "デートするなら"
            switch personality3 {
            case 0:
                subLabel.text = "こだわらない"
            case 1:
                subLabel.text = "インドア派"
            case 2:
                subLabel.text = "アウトドア派"
            default:
                return
            }
        default:
            return
        }
    }
}
