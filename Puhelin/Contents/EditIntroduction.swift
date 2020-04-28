//
//  EditIntroduction.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/18.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class EditIntroduction: UIViewController,UITextViewDelegate {

    //部品
    @IBOutlet weak var linenumlabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    //定数
    let userDefaults = UserDefaults.standard
    let uid = UserDefaults.standard.string(forKey: "uid")
    //変数
    var savedtext:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        button.layer.cornerRadius = button.frame.size.height / 2
        button.backgroundColor = ColorData.darkturquoise
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.textView.text = savedtext
        let lineNum = textView.numberOfLines
        linenumlabel.text = "\(lineNum)" + "/20"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let lineNum = textView.numberOfLines
        linenumlabel.text = "\(lineNum)" + "/20"
    }
    
    //入力画面ないしkeyboardの外を押したら、キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        let lineNum = textView.numberOfLines
        if lineNum > 20 {
            SCLAlertView().showInfo("入力制限を超えています。", subTitle: "20行以内で入力してください。")
        }else{
            //保存先を指定
            var DB = ""
            if userDefaults.integer(forKey: "gender") == 1 {
                DB = Const.MalePath
            }else if userDefaults.integer(forKey: "gender") == 2 {
                DB = Const.FemalePath
            }
            let Ref = Firestore.firestore().collection(DB).document(uid!)
            Ref.setData(["intro":textView.text as Any], merge: true)

            let nav = self.navigationController!
            let pre = nav.viewControllers[nav.viewControllers.count - 2] as! EditProfile
            pre.profileData?.intro = textView.text
            pre.setUp()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
