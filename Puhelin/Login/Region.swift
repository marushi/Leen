//
//  Region.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/14.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SCLAlertView

class Region: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let prefectures = ["北海道", "青森県", "岩手県", "宮城県", "秋田県",
    "山形県", "福島県", "茨城県", "栃木県", "群馬県",
    "埼玉県", "千葉県", "東京都", "神奈川県","新潟県",
    "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県",
    "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
    "鳥取県", "島根県", "岡山県", "広島県", "山口県",
    "徳島県", "香川県", "愛媛県", "高知県", "福岡県",
    "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
    "鹿児島県", "沖縄県"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 1
    }
    
    //ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prefectures.count
    }
    
    //ドラムロールの各項目
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prefectures[row]
    }

    //選択した犬の名前をラベルに設定
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        region.text = prefectures[row]
    }
    
    //ボタン押す前に確認
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if region.text == "都道府県" {
            SCLAlertView().showInfo("都道府県を選択してください。", subTitle: "現在お住いの地域を選択してください。")
            return false
        }
        UserDefaults.standard.set(region.text, forKey: "region")
        return true
    }

    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
