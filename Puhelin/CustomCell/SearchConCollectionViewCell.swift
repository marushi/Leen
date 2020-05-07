//
//  SearchConCollectionViewCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/05/07.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class SearchConCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.button.layer.cornerRadius = self.button.frame.size.height / 2
        self.button.backgroundColor = ColorData.salmon
        self.button.tintColor = .white
    }
}
