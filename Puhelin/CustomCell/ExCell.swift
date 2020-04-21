//
//  ExCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/19.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class ExCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.layer.cornerRadius = title.frame.size.height / 2
        title.clipsToBounds = true
    }

}
