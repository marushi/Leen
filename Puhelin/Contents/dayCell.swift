//
//  dayCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/15.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class dayCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
