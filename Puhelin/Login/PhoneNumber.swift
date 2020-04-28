//
//  PhoneNumber.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class PhoneNumber: UIViewController {

    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var tellNumberTextField: UITextField!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        Button.backgroundColor = ColorData.salmon
        Button.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tellNumberTextField.becomeFirstResponder()
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Button(_ sender: Any) {
        // 国番号を付与して変数に代入
        let phoneNumber = "+81" + tellNumberTextField.text!
        // 電話番号が10桁か11桁なのでバリデーションチェック
        if (phoneNumber.count == 13 || phoneNumber.count == 14) {
            // 入力した電話番号先に確認コードのメールを送信する
            //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print(error)
                    SCLAlertView().showInfo("通信エラー", subTitle: "通信環境をご確認ください。")
                    return
                } else {
                    // 確認IDをアプリ側で保持しておく
                    if let verificationID = verificationID {
                        self.userDefaults.set(verificationID, forKey: "verificationID")
                        print("verificationID \(verificationID)")
                    }
                    // 確認コードの認証画面へ
                    let SMS = self.storyboard?.instantiateViewController(identifier: "SMS") as! SMS
                    self.navigationController?.pushViewController(SMS, animated: true)
                }
            }
        }else{
          SCLAlertView().showInfo("電話番号の形式が正しくありません。", subTitle: "10桁または11桁で入力してください。")
        }
        
        }
}
