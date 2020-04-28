//
//  matchingTicketCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/27.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class matchingTicketCell: UICollectionViewCell {
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var kingakuLabel: UILabel!
    
    //let titleArray = ["マッチング券1枚","マッチング券3枚","マッチング券5枚"]
    let numArray = ["×1","×3","×5"]
    let kingakuArray = ["¥250","¥730","¥1,100"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(_ row:Int) {
        //titleLabel.text = titleArray[row]
        numLabel.text = numArray[row]
        kingakuLabel.text = kingakuArray[row]
    }
}
