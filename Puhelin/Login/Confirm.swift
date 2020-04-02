//
//  Confirm.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/14.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import SCLAlertView

class Confirm: UIViewController {

    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var region: UITextField!
    @IBOutlet weak var registButton: UIButton!
    

    let userDefaults = UserDefaults.standard
    let uid = Auth.auth().currentUser?.uid
    let introText = "初めまして！プロフィールを見ていただきありがとうございます。気軽にいいねしてください！まずはお話ししてみましょう！"
    let sentenceMes = "よろしくお願いします！"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickName.isEnabled = false
        age.isEnabled = false
        gender.isEnabled = false
        region.isEnabled = false
        
        registButton.backgroundColor = ColorData.salmon
        registButton.layer.cornerRadius = registButton.frame.height * 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var gendertext = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            gendertext = "男性"
        }else if userDefaults.integer(forKey: "gender") == 2 {
            gendertext = "女性"
        }
        nickName.text = userDefaults.string(forKey: "name")
        age.text = userDefaults.string(forKey: "age")
        gender.text = gendertext
        region.text = userDefaults.string(forKey: "region")
    }
    
    //登録処理
    @IBAction func Button(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("登録する") {
            //HUD
            HUD.show(.progress)
            //登録関数
            self.regist()
        }
        alertView.addButton("変更する",backgroundColor: .lightGray,textColor: .black) {
            return
        }
        alertView.showSuccess("この内容で登録しますか？", subTitle: "一部情報は登録後変更できません。")
    }
    
    func regist(){
        
        //保存先を指定
        var DB = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }else if userDefaults.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }
        let Ref = Firestore.firestore().collection(DB).document(uid!)
        let Dic = [
            "name": userDefaults.string(forKey: "name")!
            ,"age": userDefaults.integer(forKey: "age")
            ,"region": userDefaults.string(forKey: "region")!
            ,"intro": self.introText
            ,"sentenceMessage": self.sentenceMes
            ,"talk": "未選択"
            ,"tall": "未選択"
            ,"bodyType": "未選択"
            ,"purpose": "未選択"
            ,"signupDate": Date()
            ,"tabako": "未選択"
            ,"alchoal": "未選択"
            ,"job": "未選択"
            ,"income": "未選択"
            ,"personality": "未選択"
            ,"hobby": "未入力"
            ,"identification":false
            ,"newMesNum": 0
            ] as [String: Any]
        Ref.setData(Dic)
        
        //ユーザーデフォルト処理
        userDefaults.set(true, forKey: "FirstLaunch")
        
        //HUD
        HUD.flash(.success, delay: 1) { _ in
            //写真選択画面に移行
            let photo = self.storyboard?.instantiateViewController(identifier: "photo")
            self.present(photo!,animated: true,completion: nil)
        }
        
        
    }
   
}
