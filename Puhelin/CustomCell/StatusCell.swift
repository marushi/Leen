//
//  StatusCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/02.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class StatusCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setUp(row:Int,section:Int) {
        if row == 0 {
            self.backgroundColor = ColorData.turquoise
            if section == 0{
                titleLabel.text = "会員ステータス"
            }else if section == 1{
                titleLabel.text = "通話し放題"
            }else if section == 2 {
                titleLabel.text = "いいね無制限"
            }
        }
        if row == 1 {
            titleLabel.textAlignment = .center
            titleLabel.clipsToBounds = true
            if section == 0{
                if UserDefaults.standard.bool(forKey: "goodInfinity") == true || UserDefaults.standard.bool(forKey: "callInfinity") == true
                {
                    titleLabel.text = "プレミアム会員"
                }else{
                    titleLabel.text = "無料会員"
                }
                
            }else if section == 1{
                if UserDefaults.standard.bool(forKey: "goodInfinity") == true{
                    titleLabel.text = "加入中"
                }else{
                    titleLabel.text = "ー"
                }
            }else if section == 2 {
                if UserDefaults.standard.bool(forKey: "callInfinity") == true{
                    titleLabel.text = "加入中"
                }else{
                    titleLabel.text = "ー"
                }
            }
        }
        
    }
}
