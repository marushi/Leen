//
//  SMS.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class SMS: UIViewController {

    @IBOutlet weak var verificationCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Button(_ sender: Any) {
        let VerificationCode = verificationCode.text
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: VerificationCode!)

        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            print("ログインエラー")
            return
          }
          print("ログイン成功")
        }
    }
    
    
}
