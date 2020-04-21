//
//  searchTopCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/04.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class searchTopCell: UICollectionViewCell {

    @IBOutlet weak var thumpsImage: UIImageView!
    @IBOutlet weak var goodNum: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var multipImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var nonlabel: UILabel!
    @IBOutlet weak var multipnon: UIImageView!
    @IBOutlet weak var nonimage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkButton.layer.cornerRadius = checkButton.frame.height / 2
        checkButton.layer.borderColor = UIColor.white.cgColor
        checkButton.layer.borderWidth = 1
        checkView.layer.cornerRadius = 10
    }
    
    func setData(){
        goodNum.text = "\(UserDefaults.standard.integer(forKey: UserDefaultsData.remainGoodNum))"
    }
   

}
