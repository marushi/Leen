//
//  ExCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/19.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class ExCell: UICollectionViewCell {

    @IBOutlet weak var ticketNum: UILabel!
    //@IBOutlet weak var remainGoodNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(){
        let num = UserDefaults.standard.integer(forKey: UserDefaultsData.remainGoodNum)
        let num2 = UserDefaults.standard.integer(forKey: UserDefaultsData.ticketNum)
        self.ticketNum.text = "×" + String(num2)
        //self.remainGoodNum.text = String(num)
    }

}
