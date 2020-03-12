//
//  editProfileCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class editProfileCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UIButton!
    
    let titleArray:[String] = ["ニックネーム","居住地","身長","体型","会話","デート","目的"]
    
    var nickName:String?
    var region:String?
    var tallNum:String?
    var bodyType:String?
    var personality0 = "どちらでも"
    var personality1 = "どちらでも"
    var personality2 = "どちらでも"
    var selectRow0 = 0
    var selectRow1 = 0
    var selectRow2 = 0
    var cellRow:Int?
    var profileData:MyProfileData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        content.iconToRight()
        content.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //セットアップ
    func setUp(_ row:Int) {
        switch row {
        case 0:
            cellRow = 0
            content.setTitle(profileData?.name, for: .normal)
            title.text = titleArray[0]
        case 1:
            cellRow = 1
            content.setTitle(profileData?.region, for: .normal)
            title.text = titleArray[1]
        case 2:
            cellRow = 2
            content.titleLabel?.text = tallNum
            title.text = titleArray[2]
        case 3:
            cellRow = 3
            content.titleLabel?.text = bodyType
            title.text = titleArray[3]
        case 4:
            cellRow = 4
            if profileData?.personality0?.count != 1{
                content.setTitle(profileData?.personality0![1], for: .normal)
            }else{
                content.setTitle(profileData?.personality0![0], for: .normal)
            }
            title.text = titleArray[4]
        case 5:
            cellRow = 5
            if profileData?.personality0?.count != 1{
                content.setTitle(profileData?.personality1![1], for: .normal)
            }else{
                content.setTitle(profileData?.personality1![0], for: .normal)
            }
            title.text = titleArray[5]
        case 6:
            cellRow = 6
            if profileData?.personality0?.count != 1{
                content.setTitle(profileData?.personality2![1], for: .normal)
            }else{
                content.setTitle(profileData?.personality2![0], for: .normal)
            }
            title.text = titleArray[6]

        default:
            return
        }
        
    }
    
}


