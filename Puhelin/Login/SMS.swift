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

    @IBOutlet weak var confirmCodeTextField: UITextField!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Button(_ sender: Any) {
        // 確認コードを変数に代入
        if let verificationCode = confirmCodeTextField.text {
            // 先ほどの画面で保存した値を取得
            if (userDefaults.object(forKey: "verificationID") != nil) {
                let verificationID = userDefaults.object(forKey: "verificationID") as! String
                // IDとコードをろログインに使用する形式にセット
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
                // 電話番号認証を行う
                Auth.auth().signIn(with: credential) {(authResult, error) in
                    if let error = error {
                        print(error)
                        
                        return
                    }
                    if let authResult = authResult {
                        print(authResult)
                        let NickName = self.storyboard?.instantiateViewController(identifier: "NickName")
                        self.navigationController?.pushViewController(NickName!, animated: true)
                    }
                }
            }
        }
    }
    
    
}
