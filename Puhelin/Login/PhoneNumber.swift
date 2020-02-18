//
//  PhoneNumber.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class PhoneNumber: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func Button(_ sender: Any) {
        let PhoneNumber = phoneNumber.text
            
        PhoneAuthProvider.provider().verifyPhoneNumber(PhoneNumber!, uiDelegate: nil) { (verificationID, error) in
              
            if let error = error {

                print("bbbbbbbbbbbbbbbb")
                print(error.localizedDescription)
                return
            }
            print("aaaaaaaaaaaaaaaa")
            //ユーザーデフォルトにverificationIDをセット
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.performSegue(withIdentifier: "toSMS", sender: nil)
        }
        
    }
    
    
}
