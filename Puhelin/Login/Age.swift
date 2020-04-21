//
//  Age.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SCLAlertView

class Age: UIViewController{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfield0: UITextField!
    @IBOutlet weak var textfield1: UITextField!
    @IBOutlet weak var textfield2: UITextField!
    @IBOutlet weak var textfield3: UITextField!
    @IBOutlet weak var textfield4: UITextField!
    @IBOutlet weak var textfield5: UITextField!
    @IBOutlet weak var textfield6: UITextField!
    @IBOutlet weak var textfield7: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 1
        
        textfield0.delegate = self
        textfield1.delegate = self
        textfield2.delegate = self
        textfield3.delegate = self
        textfield4.delegate = self
        textfield5.delegate = self
        textfield6.delegate = self
        textfield7.delegate = self
        
        textfield0.borderStyle = .none
        textfield1.borderStyle = .none
        textfield2.borderStyle = .none
        textfield3.borderStyle = .none
        textfield4.borderStyle = .none
        textfield5.borderStyle = .none
        textfield6.borderStyle = .none
        textfield7.borderStyle = .none
        textfield0.addBorderBottom(height: 2, color: .lightGray)
        textfield1.addBorderBottom(height: 2, color: .lightGray)
        textfield2.addBorderBottom(height: 2, color: .lightGray)
        textfield3.addBorderBottom(height: 2, color: .lightGray)
        textfield4.addBorderBottom(height: 2, color: .lightGray)
        textfield5.addBorderBottom(height: 2, color: .lightGray)
        textfield6.addBorderBottom(height: 2, color: .lightGray)
        textfield7.addBorderBottom(height: 2, color: .lightGray)
                        
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //エラー処理
        if textfield0.text != "1" && textfield0.text != "2" {
            SCLAlertView().showInfo("形式が正しくありません。", subTitle: "もう一度入力してください。")
            return false
        }
        if textfield4.text != "0" && textfield4.text != "1" {
            SCLAlertView().showInfo("形式が正しくありません。", subTitle: "もう一度入力してください。")
            return false
        }
        if textfield6.text != "0" && textfield6.text != "1" && textfield6.text != "2" && textfield6.text != "3" {
            SCLAlertView().showInfo("形式が正しくありません。", subTitle: "もう一度入力してください。")
            return false
        }
        
        if textfield0.text == nil || textfield1.text == nil || textfield2.text == nil || textfield3.text == nil || textfield4.text == nil || textfield5.text == nil || textfield6.text == nil || textfield7.text == nil{
            SCLAlertView().showInfo("形式が正しくありません。", subTitle: "空白がないように入力してください。")
            return false
        }
        
        let barthYear:Int? = Int(textfield0.text! + textfield1.text! + textfield2.text! + textfield3.text!)
        var barthMonth:Int?
        if Int(textfield4.text!) == 0{
            barthMonth = Int(textfield5.text!)
        }else{
            barthMonth = Int(textfield4.text! + textfield5.text!)
        }
        var barthDay:Int?
        if Int(textfield6.text!) == 0{
            barthDay = Int(textfield7.text!)
        }else{
            barthDay = Int(textfield6.text! + textfield7.text!)
        }
        
        if (2020 - barthYear!) > 100 || (2020 - barthYear!) < 18 {
            SCLAlertView().showInfo("西暦が正しくありません。", subTitle: "正しい数値を入力してください。")
            return false
        }
        
        
        //エラー無し登録処理
        UserDefaults.standard.set(barthYear, forKey: "birthYear")
        UserDefaults.standard.set(barthMonth,forKey: "birthMonth")
        UserDefaults.standard.set(barthDay, forKey: "birthDay")
        return true
    }
}

extension Age:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField:UITextField = self.view.viewWithTag(nextTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.text = string
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
