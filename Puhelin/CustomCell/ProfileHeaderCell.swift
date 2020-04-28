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
    @IBOutlet weak var titleLabel: UILabel!
    
    let titleArray:[String] = ["身長","体型","会話","目的"]
    var data:MyProfileData?
    
    override func awakeFromNib() {
        titleLabel.layer.cornerRadius = titleLabel.frame.size.height / 2
        titleLabel.clipsToBounds = true
    }
    
    func setData(_ row:Int) {
        if data == nil {
            return
        }
        self.titleLabel.text = self.titleArray[row]
        switch row {
        case 0:
            if data?.tall != nil{
                label.text = "\(data!.tall!)cm"
            }else{
                label.text = "-cm"
            }
            //self.addBorder(width: 1, color: .lightGray, position: .right)
        case 1:
            if data?.bodyType == "" {
                label.text = "どちらでも"
            }else{
                label.text = data?.bodyType
            }
            //self.addBorder(width: 1, color: .lightGray, position: .right)
        case 2:
            if data?.talk == "" {
                label.text = "どちらでも"
            }else {
                label.text = data?.talk
            }
            //self.addBorder(width: 1, color: .lightGray, position: .right)
        case 3:
            if data?.purpose == "" {
                label.text = "どちらでも"
            }else{
                label.text = data?.purpose
            }
        default:
            return
        }
    }
}
