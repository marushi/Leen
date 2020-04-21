//
//  MypageHeader.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/20.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class goodpointCell: UICollectionViewCell {
    //部品
    @IBOutlet weak var goodnum: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let userDefaults = UserDefaults.standard

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        goodnum.text = String(userDefaults.integer(forKey: UserDefaultsData.remainGoodNum))
        button.layer.cornerRadius = button.frame.size.height / 2
    }
}
