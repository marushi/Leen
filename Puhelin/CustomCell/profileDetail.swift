//
//  profileDetail.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/09.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class profileDetail: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    let titleArray = ["会話のスタンスは","出会いの目的は","デートするなら"]
    
    var personality0 = ""
    var personality1 = ""
    var personality2 = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.backgroundColor = .init(red: 1, green: 248/255, blue: 240/255, alpha: 1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ row:Int) {
        switch row {
        case 0:
            titleLabel.text = titleArray[0]
            subtitleLabel.text = personality0
        case 1:
            titleLabel.text = titleArray[1]
            subtitleLabel.text = personality1
        case 2:
            titleLabel.text = titleArray[2]
            subtitleLabel.text = personality2
        default:
            return
        }
    }

}
