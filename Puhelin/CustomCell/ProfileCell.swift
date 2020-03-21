//
//  ProfileCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/08.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    //部品
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    //定数
    let titleArray = ["居住地","身長","体型","会話","目的"]
    //変数
    var profileData:MyProfileData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(_ row:Int) {
        if profileData != nil {
        switch row {
        case 0:
            contentLabel.text = profileData?.region
            titleLabel.text = titleArray[0]
        case 1:
            contentLabel.text = "\(profileData!.tall!)" + "cm"
            titleLabel.text = titleArray[1]
        case 2:
            contentLabel.text = profileData?.bodyType
            titleLabel.text = titleArray[2]
        case 3:
            contentLabel.text = profileData?.talk
            titleLabel.text = titleArray[3]
        case 4:
            contentLabel.text = profileData?.purpose
            titleLabel.text = titleArray[4]

        default:
            return
            }}
    
    }

}
