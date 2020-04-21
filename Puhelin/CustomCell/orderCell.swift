//
//  orderCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class orderCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    
    var selectCell:Int?
    
    let titleArray = ["ログイン順","登録日順","年齢順","運命に委ねる（ランダム）"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ row:Int) {
        self.label.text = titleArray[row]
        if row == selectCell {
            self.selectImage.isHidden = false
        }else{
            self.selectImage.isHidden = true
        }
    }
    
    
    
}
