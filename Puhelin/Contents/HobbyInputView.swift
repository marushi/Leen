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
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var mojisuseigen: UILabel!
    
    var inputMode:Int?
    var nameText:String?
    var delegate:perToEdit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 10
        textField.delegate = self
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [.foregroundColor : UIColor.lightGray])
        textField.layer.cornerRadius = 5
        //delegateの設定
        let nav = self.presentingViewController as? UINavigationController
        delegate = nav?.topViewController as? EditProfile
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        textField.text = nameText
        if inputMode == 0 {
            mojisuseigen.text = "※ 文字数制限（2〜6文字以内）"
        }else{
            mojisuseigen.text = "※ 文字数制限（10文字以内）"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //キャンセル
    @IBAction func canseleButton(_ sender: Any) {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
    
    //-------textField------//
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textNum = textField.text?.count else {
            return true
        }
        if inputMode == 0 {
            if textNum > 1 && textNum < 7 {
                self.registButton.isEnabled = true
                return true
            }else{
                registButton.isEnabled = false
                return true
            }
        }else{
            if textNum < 10 {
                self.registButton.isEnabled = true
                return true
            }else{
                registButton.isEnabled = false
                return true
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -60)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: 60)
        })
    }
    
    //保存
    @IBAction func registButton(_ sender: Any) {
        self.modalTransitionStyle = .crossDissolve
        var num:Int?
        
        let Ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(UserDefaults.standard.string(forKey: "uid")!)
        if inputMode == 0{
            num = 9
            Ref.setData(["name":textField.text!],merge: true)
            UserDefaults.standard.set(textField.text!, forKey: "name")
        }else if inputMode == 1{
            num = 10
            Ref.setData(["hobby":textField.text!],merge: true)
        }else if inputMode == 2 {
            num = 2
            Ref.setData(["job":textField.text!],merge: true)
        }else if inputMode == 3 {
            num = 4
            Ref.setData(["personality":textField.text!],merge: true)
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
