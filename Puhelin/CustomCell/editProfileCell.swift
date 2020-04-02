//
//  editProfileCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class editProfileCell: UITableViewCell {

    //部品
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UIButton!
    
    //定数
    let titleArray:[String] = ["ニックネーム","年齢","居住地","身長","体型","職種","年収","性格","会話","目的","お酒","タバコ","好きなこと趣味"]
    
    //変数
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
        if self.profileData != nil{
        switch row {
        case 0:
            content.setTitle(profileData?.name, for: .normal)
            title.text = titleArray[0]
        case 1:
            if profileData?.tall != nil {
                content.setTitle("\(profileData!.age!)" + "歳", for: .normal)
            }
            title.text = titleArray[1]
            content.setImage(UIImage(), for: .normal)
        case 2:
            content.setTitle(profileData?.region, for: .normal)
            title.text = titleArray[2]
        case 3:
            if profileData?.tall == nil {
                content.setTitle("未入力", for: .normal)
            }else{
                content.setTitle("\(profileData!.tall!)" + "cm", for: .normal)
            }
            title.text = titleArray[3]
        case 4:
            content.setTitle(profileData?.bodyType, for: .normal)
            title.text = titleArray[4]
        case 5:
            content.setTitle(profileData?.job, for: .normal)
            title.text = titleArray[5]
        
        case 6:
            content.setTitle(profileData?.income, for: .normal)
            title.text = titleArray[6]
        
        case 7:
            content.setTitle(profileData?.personality, for: .normal)
            title.text = titleArray[7]
        
        case 8:
            content.setTitle(profileData?.talk, for: .normal)
            title.text = titleArray[8]
        
        case 9:
            content.setTitle(profileData?.purpose, for: .normal)
            title.text = titleArray[9]
        
        case 10:
            content.setTitle(profileData?.alchoal, for: .normal)
            title.text = titleArray[10]
        
        case 11:
            content.setTitle(profileData?.tabako, for: .normal)
            title.text = titleArray[11]
        
        case 12:
            content.setTitle(profileData?.hobby, for: .normal)
            title.text = titleArray[12]

        default:
            return
            }}
        
    }
    
}


