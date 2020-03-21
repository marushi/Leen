//
//  PurchaseCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/20.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class PurchaseCell: UITableViewCell {

    @IBOutlet weak var purchasePointAmount: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        purchaseButton.layer.cornerRadius = purchaseButton.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ row:Int) {
        switch row {
        case 0:
            return
        case 1:
            purchasePointAmount.text = "30"
            purchaseButton.setTitle("2,000円", for: .normal)
        
        case 2:
            purchasePointAmount.text = "50"
            purchaseButton.setTitle("4,000円", for: .normal)
        
        case 3:
            purchasePointAmount.text = "100"
            purchaseButton.setTitle("7,500円", for: .normal)
        default:
            return
        }
    }

}
