//
//  informationCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/30.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class informationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    
    var infoData:[InformationData]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentText.textContainerInset = UIEdgeInsets.zero
        contentText.textContainer.lineFragmentPadding = 0
        contentText.isUserInteractionEnabled = false
        contentText.textContainer.maximumNumberOfLines = 3
        contentText.textContainer.lineBreakMode = .byTruncatingTail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(_ row:Int) {
        titleLabel.text = infoData![row].title
        let date:Timestamp = infoData![row].date!
        let recieveDate: Date = date.dateValue()
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        let showDate = "\(formatter.string(from: recieveDate))"
        dateLabel.text = "\(showDate)"
        contentText.text = infoData![row].content
    }
}
