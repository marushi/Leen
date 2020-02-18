//
//  Confirm.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/14.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class Confirm: UIViewController {

    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var region: UITextField!
    @IBOutlet weak var mailAddress: UITextField!
    

    let userDefaults = UserDefaults.standard
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickName.isEnabled = false
        age.isEnabled = false
        gender.isEnabled = false
        region.isEnabled = false
        mailAddress.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var gendertext = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            gendertext = "男"
        }else if userDefaults.integer(forKey: "gender") == 2 {
            gendertext = "女"
        }
        nickName.text = userDefaults.string(forKey: "name")
        age.text = userDefaults.string(forKey: "age")
        gender.text = gendertext
        region.text = userDefaults.string(forKey: "region")
        mailAddress.text = userDefaults.string(forKey: "mailaddress")
    }
    
    @IBAction func Button(_ sender: Any) {
        
        //投稿中表示
        SVProgressHUD.show()
        
        //保存先を指定
        var DB = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }else if userDefaults.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }
        let Ref = Firestore.firestore().collection(DB).document(uid!)
        let Dic = ["name": userDefaults.string(forKey: "name")
            ,"age": userDefaults.integer(forKey: "age")
            ,"region": userDefaults.string(forKey: "region")
        ,"mailaddress": userDefaults.string(forKey: "mailaddress")] as [String: Any]
        Ref.setData(Dic)
        userDefaults.set(uid, forKey: "uid")
        
        SVProgressHUD.showSuccess(withStatus: "登録完了")
        
        if userDefaults.bool(forKey: "photoUP") == false {
            let photo = self.storyboard?.instantiateViewController(identifier: "photo")
            present(photo!,animated: true,completion: nil)
        }
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
   
}
