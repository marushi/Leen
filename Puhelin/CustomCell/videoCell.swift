//
//  videoCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/15.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class videoCell: UICollectionViewCell {

    //@IBOutlet weak var button: UIButton!
    @IBOutlet weak var ticketNum: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //button.layer.cornerRadius = button.frame.size.height / 2
    }
    
    func setData() {
        let num:Int = userDefaults.integer(forKey: UserDefaultsData.matchingNum)
        ticketNum.text = "×" + String(num)
    }
}
