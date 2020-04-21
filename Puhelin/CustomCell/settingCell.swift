//
//  settingCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/10.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class settingCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let titleArray = ["退会手続き"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(_ row:Int) {
        titleLabel.text = titleArray[row]
    }

}
