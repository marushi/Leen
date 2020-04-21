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
            if section == 0{
                titleLabel.text = "会員ステータス"
                self.backgroundColor = ColorData.blond
                self.addBorder(width: 1, color: .lightGray, position: .bottom)
                self.addBorder(width: 1, color: .lightGray, position: .right)
            }else if section == 1{
                titleLabel.text = "通話し放題"
                self.backgroundColor = ColorData.whitesmoke
                self.addBorder(width: 1, color: .lightGray, position: .bottom)
                self.addBorder(width: 1, color: .lightGray, position: .right)
            }else if section == 2 {
                titleLabel.text = "いいね無制限"
                self.backgroundColor = ColorData.whitesmoke
                self.addBorder(width: 1, color: .lightGray, position: .right)
            }
        }
        if row == 1 {
            titleLabel.textAlignment = .center
            titleLabel.clipsToBounds = true
            if section == 0{
                self.addBorder(width: 1, color: .lightGray, position: .bottom)
                if UserDefaults.standard.bool(forKey: "goodInfinity") == true || UserDefaults.standard.bool(forKey: "callInfinity") == true
                {
                    titleLabel.text = "プレミアム会員"
                }else{
                    titleLabel.text = "無料会員"
                }
                
            }else if section == 1{
                self.addBorder(width: 1, color: .lightGray, position: .bottom)
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
