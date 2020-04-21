//
//  talkAddCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/07.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class talkAddCell: UITableViewCell {

    @IBOutlet weak var gradation: GradationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradation.setGradation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
