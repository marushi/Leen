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
    
    let titleArray:[String] = ["居住地","年齢","身長","体型","職種","年収","性格","会話","目的","お酒","タバコ"]
    
    
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
            titleLabel.text = titleArray[0]
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
            titleLabel.text = titleArray[1]
            self.subLabel.text = "こだわらない"
        case 2:
            titleLabel.text = titleArray[2]
            if searchQuery?.talk == nil {
                self.subLabel.text = "こだわらない"
            }else{
                self.subLabel.text = searchQuery?.talk
            }
        case 3:
            titleLabel.text = titleArray[3]
            if searchQuery?.purpose == nil {
                self.subLabel.text = "こだわらない"
            }else{
                self.subLabel.text = searchQuery?.purpose
            }
        case 4:
            titleLabel.text = titleArray[4]
            if searchQuery?.bodyType == nil {
                self.subLabel.text = "こだわらない"
            }else{
                self.subLabel.text = searchQuery?.bodyType
            }
        case 5:
            titleLabel.text = titleArray[5]
        
        case 6:
            titleLabel.text = titleArray[6]
        
        case 7:
            titleLabel.text = titleArray[7]
        
        case 8:
            titleLabel.text = titleArray[8]
        
        case 9:
            titleLabel.text = titleArray[9]
        
        case 10:
            titleLabel.text = titleArray[10]
        default:
            return
        }
    }
}
