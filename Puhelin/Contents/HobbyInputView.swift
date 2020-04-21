//
//  HobbyInputView.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/02.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class HobbyInputView: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    var inputMode:Int?
    var nameText:String?
    var delegate:perToEdit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 10
        textField.delegate = self
        //delegateの設定
        let nav = self.presentingViewController as? UINavigationController
        delegate = nav?.topViewController as? EditProfile
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        textField.text = nameText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //キャンセル
    @IBAction func canseleButton(_ sender: Any) {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
    
    //保存
    @IBAction func registButton(_ sender: Any) {
        self.modalTransitionStyle = .crossDissolve
        var num:Int?
        
        if UserDefaults.standard.integer(forKey: "gender") == 1{
            let Ref = Firestore.firestore().collection(Const.MalePath).document(UserDefaults.standard.string(forKey: "uid")!)
            if inputMode == 0{
                num = 9
                Ref.setData(["name":textField.text!],merge: true)
                UserDefaults.standard.set(textField.text!, forKey: "name")
            }else{
                num = 10
                Ref.setData(["hobby":textField.text!],merge: true)
            }
        }else{
            let Ref = Firestore.firestore().collection(Const.FemalePath).document(UserDefaults.standard.string(forKey: "uid")!)
            if inputMode == 0{
                num = 9
                Ref.setData(["name":textField.text!],merge: true)
                UserDefaults.standard.set(textField.text!, forKey: "name")
            }else{
                num = 10
                Ref.setData(["hobby":textField.text!],merge: true)
            }
        }
        delegate?.perToEditText(text: textField.text!, row: num!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
