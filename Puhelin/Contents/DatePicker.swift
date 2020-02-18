//
//  DatePicker.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/15.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class DatePicker: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var datePicker: UIPickerView!
    
    var dayofweeks = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    var day = "日曜日"
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.delegate = self
        datePicker.dataSource = self
    }
    
    @IBAction func Button(_ sender: Any) {
        UserDefaults.standard.set(day, forKey: "callday_\(num)")
        let MyProfile = self.storyboard?.instantiateViewController(identifier: "MyProfile") as! MyProfile
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let r0 = UserDefaults.standard.string(forKey: "callday_\(num - 2)")
        let r1 = UserDefaults.standard.string(forKey: "callday_\(num - 1)")
        let r2 = UserDefaults.standard.string(forKey: "callday_\(num + 1)")
        let r3 = UserDefaults.standard.string(forKey: "callday_\(num + 2)")
        
        if r0 != nil {
            dayofweeks.remove(value: r0!)
        }
        if r1 != nil {
            dayofweeks.remove(value: r1!)
        }
        if r2 != nil {
            dayofweeks.remove(value: r2!)
        }
        if r3 != nil {
            dayofweeks.remove(value: r3!)
        }
        return dayofweeks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let r0 = UserDefaults.standard.string(forKey: "callday_\(num - 2)")
        let r1 = UserDefaults.standard.string(forKey: "callday_\(num - 1)")
        let r2 = UserDefaults.standard.string(forKey: "callday_\(num + 1)")
        let r3 = UserDefaults.standard.string(forKey: "callday_\(num + 2)")
        
        if r0 != nil {
            dayofweeks.remove(value: r0!)
        }
        if r1 != nil {
            dayofweeks.remove(value: r1!)
        }
        if r2 != nil {
            dayofweeks.remove(value: r2!)
        }
        if r3 != nil {
            dayofweeks.remove(value: r3!)
        }
        
        day = dayofweeks[0]
        return dayofweeks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        day = dayofweeks[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}
