//
//  SearchConditionsCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/06.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class SearchConditionsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    var searchQuery:searchQueryData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(_ row:Int){
        switch row {
        case 0:
            titleLabel.text = "居住地"
            if searchQuery?.prefecturs == nil || searchQuery?.prefecturs == [] {
                subLabel.text = "こだわらない"
            }else{
                let Num:Int = searchQuery!.prefecturs!.count - 1
                var str:String = ""
                for i in 0...Num {
                    str = str + "\(searchQuery!.prefecturs![i]),"
                }
                self.subLabel.text = str
            }
        case 1:
            titleLabel.text = "年齢"
            self.subLabel.text = "こだわらない"
        case 2:
            titleLabel.text = "会話"
            if searchQuery?.talk == nil {
                self.subLabel.text = "こだわらない"
            }else{
                self.subLabel.text = searchQuery?.talk
            }
        case 3:
            titleLabel.text = "目的"
            if searchQuery?.purpose == nil {
                self.subLabel.text = "こだわらない"
            }else{
                self.subLabel.text = searchQuery?.purpose
            }
        case 4:
            titleLabel.text = "体型"
            if searchQuery?.bodyType == nil {
                self.subLabel.text = "こだわらない"
            }else{
                self.subLabel.text = searchQuery?.bodyType
            }
        default:
            return
        }
    }
}
