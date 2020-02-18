//
//  MailAddress.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class MailAddress: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           
           if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            return false
           }else{
            UserDefaults.standard.set(textField.text, forKey: "mailaddress")
            return true
           }
    }
}

