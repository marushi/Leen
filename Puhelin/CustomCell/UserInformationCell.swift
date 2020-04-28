//
//  UserInformationCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/26.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class UserInformationCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    let titleArray = ["電話番号","生年月日","本人確認","1日のいいね数","通話時間","回復券"]
    let userDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(_ row:Int) {
        self.titleLabel.text = titleArray[row]
        switch row {
        case 0:
            contentLabel.text = Auth.auth().currentUser?.phoneNumber!
        case 1:
            let Ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!)
            Ref.getDocument() { (document, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
                }
                let num:Int? = document?.get("birthYear") as? Int
                let num2:Int? = document?.get("birthMonth") as? Int
                let num3:Int? = document?.get("birthDay") as? Int
                if num != nil && num2 != nil && num3 != nil {
                    let year = String(num!)
                    let month = String(num2!)
                    let day = String(num3!)
                    self.contentLabel.text = year + "/" + month + "/" + day
                }
            }
        case 2:
            let type = userDefaults.integer(forKey: UserDefaultsData.identification)
            var text:String!
            if type == 0 {
                text = "未確認"
            }
            if type == 1 {
                text = "承認待ち"
            }
            if type == 2 {
                text = "確認済み"
            }
            contentLabel.text = text
        case 3:
            let type = userDefaults.integer(forKey: UserDefaultsData.goodLimit)
            var text:String!
            if type == 0 {
                text = "5回"
            }
            if type == 1 {
                text = "10回"
            }
            if type == 2 {
                text = "15回"
            }
            if type == 3 {
                text = "20回"
            }
            contentLabel.text = text
        case 4:
            let type = userDefaults.integer(forKey: UserDefaultsData.callLimit)
            var text:String!
            if type == 0 {
                text = "15分"
            }
            if type == 1 {
                text = "30分"
            }
            if type == 2 {
                text = "45分"
            }
            if type == 3 {
                text = "60分"
            }
            contentLabel.text = text
        case 5:
            let num = userDefaults.integer(forKey: UserDefaultsData.ticketNum)
            contentLabel.text = String(num) + "枚"
        default:
            return
        }
    }
}
