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
        
        button.layer.cornerRadius = button.frame.size.height / 2
    }
    
    func setdata(){
        let type = userDefaults.integer(forKey: UserDefaultsData.goodLimit)
        if type == 0 {
            goodnum.text = "5"
        }else if type == 1 {
            goodnum.text = "10"
        }else if type == 2 {
            goodnum.text = "15"
        }else if type == 3 {
            goodnum.text = "20"
        }
    }
}
