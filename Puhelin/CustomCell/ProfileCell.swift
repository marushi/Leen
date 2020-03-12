//
//  ProfileCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/08.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    let titleArray = ["いつも話す時：","出会いの目的：","デートするなら："]
    
    var personality0: [String]?
    var personality1: [String]?
    var personality2: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(_ row:Int) {
        switch row {
        case 0:
            titleLabel.text = titleArray[0]
            if personality0?.count == 1 {
                contentLabel.text = "どちらでも"
            }else{
                contentLabel.text = personality0![1]
            }
        
        case 1:
            titleLabel.text = titleArray[1]
            if personality1?.count == 1 {
                contentLabel.text = "どちらでも"
            }else{
                contentLabel.text = personality1![1]
            }
        
        case 2:
            titleLabel.text = titleArray[2]
            if personality2?.count == 1 {
                contentLabel.text = "どちらでも"
            }else{
                contentLabel.text = personality2![1]
            }
            
        default:
            return
        }
    }

}
