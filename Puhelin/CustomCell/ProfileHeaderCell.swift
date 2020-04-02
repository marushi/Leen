//
//  ProfileHeaderCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/26.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    var data:MyProfileData?
    
    override func awakeFromNib() {
    }
    
    func setData(_ row:Int) {
        if data == nil {
            return
        }
        switch row {
        case 0:
            if data?.tall != nil{
                label.text = "\(data!.tall!)cm"
            }else{
                label.text = "未入力"
            }
            self.addBorder(width: 1, color: .lightGray, position: .right)
        case 1:
            label.text = data?.bodyType
            self.addBorder(width: 1, color: .lightGray, position: .right)
        case 2:
            if data?.talk == "未選択" {
                label.text = "どちらでも"
            }else {
                label.text = data?.talk
            }
            self.addBorder(width: 1, color: .lightGray, position: .right)
        case 3:
            if data?.purpose == "未選択" {
                label.text = "どちらでも"
            }else{
                label.text = data?.purpose
            }
        default:
            return
        }
    }
}
