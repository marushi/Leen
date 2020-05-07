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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    

    let userDefaults = UserDefaults.standard
    let uid = Auth.auth().currentUser?.uid
    let introText = "初めまして！プロフィールを見ていただきありがとうございます。気軽にいいねしてください！まずはお話ししてみましょう！"
    let sentenceMes = "よろしくお願いします！"
    let hokkaidou = ["北海道"]
    let touhoku = ["青森県", "岩手県", "宮城県", "秋田県",
    "山形県", "福島県"]
    let kantou = ["茨城県", "栃木県", "群馬県",
    "埼玉県", "千葉県", "東京都", "神奈川県"]
    let chubu = ["新潟県",
    "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県"]
    let kinki = ["三重県", "滋賀県",
    "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県"]
    let chugoku = ["鳥取県", "島根県", "岡山県", "広島県", "山口県"]
    let shikoku = ["徳島県", "香川県", "愛媛県", "高知県"]
    let kyushu = ["福岡県",
    "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
    "鹿児島県"]
    let okinawa = ["沖縄県"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickName.isEnabled = false
        nickName.borderStyle = .none
        nickName.addBorderBottom(height: 2, color: .lightGray)
        age.isEnabled = false
        age.borderStyle = .none
        age.addBorderBottom(height: 2, color: .lightGray)
        gender.isEnabled = false
        gender.borderStyle = .none
        gender.addBorderBottom(height: 2, color: .lightGray)
        region.isEnabled = false
        region.borderStyle = .none
        region.addBorderBottom(height: 2, color: .lightGray)
        
        registButton.backgroundColor = ColorData.salmon
        registButton.layer.cornerRadius = registButton.frame.height * 0.5
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var gendertext = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            gendertext = "男性"
        }else if userDefaults.integer(forKey: "gender") == 2 {
            gendertext = "女性"
        }
        nickName.text = userDefaults.string(forKey: "name")
        let by:String = String(userDefaults.integer(forKey: "birthYear")) + "/"
        let bm:String = String(userDefaults.integer(forKey: "birthMonth")) + "/"
        let bd:String = String(userDefaults.integer(forKey: "birthDay"))
        age.text = by + bm + bd
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
        //地域がどこかを検索
        var str:String?
        if let reg = userDefaults.string(forKey: "region") {
            if self.hokkaidou.contains(reg) {
                str = "北海道"
            }
            if self.touhoku.contains(reg) {
                str = "東北"
            }
            if self.kantou.contains(reg) {
                str = "関東"
            }
            if self.chubu.contains(reg) {
                str = "中部"
            }
            if self.kinki.contains(reg) {
                str = "近畿"
            }
            if self.chugoku.contains(reg) {
                str = "中国"
            }
            if self.shikoku.contains(reg) {
                str = "四国"
            }
            if self.kyushu.contains(reg) {
                str = "九州"
            }
            if self.okinawa.contains(reg) {
                str = "沖縄"
            }
        }
        let Ref = Firestore.firestore().collection(DB).document(uid!)
        let Dic = [
            "name": userDefaults.string(forKey: "name")!
            ,"age": userDefaults.integer(forKey: "age")
            ,"region": userDefaults.string(forKey: "region")!
            ,"regionClass": str!
            ,"intro": self.introText
            ,"sentenceMessage": self.sentenceMes
            ,"talk": ""
            ,"tall": ""
            ,"bodyType": ""
            ,"purpose": ""
            ,"tabako": ""
            ,"alchoal": ""
            ,"job": ""
            ,"personality": ""
            ,"hobby": ""
            ,"newMesNum": 0
            ,"token": userDefaults.string(forKey: "token") as Any
            ,"birthYear": userDefaults.integer(forKey: "birthYear") as Any
            ,"birthMonth": userDefaults.integer(forKey: "birthMonth") as Any
            ,"birthDay": userDefaults.integer(forKey: "birthDay") as Any
            ,"searchPermis": true
            ,"identification":false
            ,"signupDate": Date()
            ,"goodLimit": 0
            ,"callLimit": 0
            ,"recoveryTicket": 0
            ] as [String: Any]
        Ref.setData(Dic)
        
        //ユーザーデフォルト処理
        //課金事項
        userDefaults.set(0, forKey: "goodLimit")
        userDefaults.set(0, forKey: "callLimit")
        userDefaults.set(0, forKey: "recoveryTicket")
        userDefaults.set(5, forKey: "remainGoodNum")
        //本人確認
        userDefaults.set(0, forKey: "identification")
        
        //HUD
        HUD.flash(.success, delay: 1) { _ in
            //写真選択画面に移行
            let photo = self.storyboard?.instantiateViewController(identifier: "photo")
            self.present(photo!,animated: true,completion: nil)
        }
        
        
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
}
