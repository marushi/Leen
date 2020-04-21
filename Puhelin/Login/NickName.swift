//
//  NickName.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SCLAlertView

class NickName: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()

        text.delegate = self
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 1
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //空白を除いたな入力テキスト
        let nameText = text?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //文字数が２文字以下の時
        if (nameText!.count) < 2 {
            SCLAlertView().showInfo("文字数が足りません。", subTitle: "名前は2文字以上で入力してください。")
            return false
        }
            
        //文字数が15文字以上の場合
        if nameText!.count > 15 {
            SCLAlertView().showInfo("名前が長すぎます。", subTitle: "名前は15文字以下で入力してください。")
            return false
        }
            
        //記号を除いた文字数が２文字以下の時
        if nameText!.trimmingCharacters(in: .punctuationCharacters).count < 2 {
            SCLAlertView().showInfo("入力エラー", subTitle: "記号以外に2文字以上の入力が必要です。")
            return false
        }
        
        //エラーがない時
        else{
            UserDefaults.standard.set(text.text, forKey: "name")
            return true
        }

    }
    
}



