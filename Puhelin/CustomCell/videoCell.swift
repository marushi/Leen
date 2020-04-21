//
//  videoCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/15.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class videoCell: UICollectionViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button.layer.cornerRadius = button.frame.size.height / 2
    }

}
