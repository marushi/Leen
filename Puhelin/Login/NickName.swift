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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        text.delegate = self
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //空白を除いたな入力テキスト
        let nameText = text?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //文字数が２文字以下の時
        if (nameText!.count) < 3 {
            SCLAlertView().showInfo("文字数が足りません。", subTitle: "名前は３文字以上で入力してください。")
            return false
        }
            
        //文字数が15文字以上の場合
        if nameText!.count > 15 {
            SCLAlertView().showInfo("名前が長すぎます。", subTitle: "名前は１５文字以下で入力してください。")
            return false
        }
            
        //記号を除いた文字数が２文字以下の時
        if nameText!.trimmingCharacters(in: .punctuationCharacters).count < 3 {
            SCLAlertView().showInfo("入力エラー", subTitle: "記号以外に３文字以上の入力が必要です。")
            return false
        }
        
        //エラーがない時
        else{
            UserDefaults.standard.set(text.text, forKey: "name")
            return true
        }

    }
    
}



