//
//  scheduleCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/07.
//  Copyright © 2020 shion.maruko. All rights reserved.
//
import UIKit

class scheduleCell:UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    let pickerView = UIDatePicker()
    var selectDate:String?
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
        textField.inputView = pickerView
        pickerView.datePickerMode = .dateAndTime
        pickerView.minuteInterval = 15
        pickerView.locale = Locale(identifier: "ja")
        pickerView.minimumDate = Date()
        
    }
    
        
    func setUp(_ row:Int) {
        switch row {
        case 0:
            titleLabel.text = "第1候補日"
        case 1:
            titleLabel.text = "第2候補日"
        case 2:
            titleLabel.text = "第3候補日"
        case 3:
            titleLabel.text = "第4候補日"
        case 4:
            titleLabel.text = "第5候補日"
        default:
            return
        }
    }
}

//ピッカービューをtoolbarに設定
extension scheduleCell{
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)

        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 12
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButton(_:)))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButton(_:)))

        let toolbarItems = [space, cancelItem, flexSpaceItem, doneButtonItem, space]

        toolbar.setItems(toolbarItems, animated: true)

        return toolbar
    }
    
    @objc func cancelBarButton(_ sender: UIBarButtonItem){
        textField.resignFirstResponder()
    }
    
    @objc func doneBarButton(_ sender: UIBarButtonItem){
        textField.resignFirstResponder()
        
        // 日付のフォーマット
        let formatter = DateFormatter()

        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できるよ
        formatter.dateFormat = "MM月dd日 HH:mm"

        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        selectDate = "\(formatter.string(from: pickerView.date))"
        textField.text = selectDate
    }
    
    
}
