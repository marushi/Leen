//
//  Age.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SCLAlertView

class Age: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    

    @IBOutlet weak var pickerView: UIPickerView!
    
    var ageText: Int?
    let numArray:[Int] = Array(20...99)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numArray[row]) + "才"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageText = numArray[row]
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if ageText == nil {
            SCLAlertView().showInfo("年齢を選択してください。", subTitle: "現在の年齢を選択してください。")
            return false
        }
        UserDefaults.standard.set(ageText, forKey: "age")
        return true
    }
}
