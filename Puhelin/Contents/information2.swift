//
//  information2.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/31.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class information2: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var infodata:InformationData?

    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        titleLabel.text = infodata?.title
        contentTextView.text = infodata?.content
        let date:Timestamp? = infodata?.date
        let recieveDate: Date = date!.dateValue()
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年MM月dd日"
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        let showDate = "\(formatter.string(from: recieveDate))"
        dateLabel.text = "\(showDate)"
    }
    
    
}
