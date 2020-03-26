//
//  goodPointPurchaseCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/22.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class goodPointPurchaseCell: UICollectionViewCell {
    @IBOutlet weak var purchaseNum: UILabel!
    @IBOutlet weak var usePoint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ row:Int) {
        switch row {
        case 0:
            purchaseNum.text = "×5"
            usePoint.text = "5pt"
        
        case 1:
            purchaseNum.text = "×10"
            usePoint.text = "10pt"
        
        case 2:
            purchaseNum.text = "×30"
            usePoint.text = "30pt"
        
        case 3:
            purchaseNum.text = "×50"
            usePoint.text = "50pt"
        
        case 4:
            purchaseNum.text = "×100"
            usePoint.text = "100pt"
        default:
            return
        }
    }

}
