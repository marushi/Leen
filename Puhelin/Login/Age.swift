//
//  Age.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class Age: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        let resultText: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if resultText.count <= 2 {
            return Int(string) != nil
        }
        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           
           if textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
               return false
           }else{
            UserDefaults.standard.set(textField.text, forKey: "age")
            return true
           }
    }
}
