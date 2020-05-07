//
//  SMS.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase

class SMS: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var confirmCodeTextField: UITextField!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = button.frame.size.height / 2
        confirmCodeTextField.layer.borderColor = UIColor.lightGray.cgColor
        confirmCodeTextField.layer.borderWidth = 1
        confirmCodeTextField.backgroundColor = .white
        confirmCodeTextField.layer.cornerRadius = 5
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Button(_ sender: Any) {
        HUD.show(.progress)
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
                        HUD.hide()
                        return
                    }
                    if let authResult = authResult {
                        print(authResult)
                        let uid = Auth.auth().currentUser?.uid
                        self.userDefaults.set(uid, forKey: "uid")
                        HUD.hide()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
