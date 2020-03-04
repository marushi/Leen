//
//  SearchCoditions.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}

//テキストフィールドの制限
extension SearchCoditions: UITextFieldDelegate{
    //キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNum.resignFirstResponder()
        lastNum.resignFirstResponder()
    }
}


class SearchCoditions: UIViewController {
    
    @IBOutlet weak var pickerView0: UIPickerView!
    @IBOutlet weak var firstNum: UITextField!
    @IBOutlet weak var lastNum: UITextField!
    
    var region = "未選択"
    var firstnum = 20
    var lastnum = 99
    var Ref:Query!
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    let userDefaults = UserDefaults.standard
    var firstAgeNumArray:[Int] = []
    var lastAgeNumArray:[Int] = []
    let prefectures = ["未選択","北海道", "青森県", "岩手県", "宮城県", "秋田県",
    "山形県", "福島県", "茨城県", "栃木県", "群馬県",
    "埼玉県", "千葉県", "東京都", "神奈川県","新潟県",
    "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県",
    "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
    "鳥取県", "島根県", "岡山県", "広島県", "山口県",
    "徳島県", "香川県", "愛媛県", "高知県", "福岡県",
    "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
    "鹿児島県", "沖縄県"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pickerViewの設定
        pickerView0.delegate = self
        pickerView0.dataSource = self
        picker1.delegate = self
        picker1.delegate = self
        picker1.tag = 1
        picker2.delegate = self
        picker2.delegate = self
        picker2.tag = 2
        firstAgeNumArray = Array(20...lastnum)
        lastAgeNumArray = Array(firstnum...99)
        
        //textviewの設定
        firstNum.delegate = self
        lastNum.delegate = self
        self.firstNum.inputView = picker1
        self.lastNum.inputView = picker2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefaults.integer(forKey: "gender") == 1 {
            Ref = Firestore.firestore().collection(Const.FemalePath)
        }else{
            Ref = Firestore.firestore().collection(Const.MalePath)
        }
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        //探す画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeButton(_ sender: Any) {
        if firstNum.text?.trimmingCharacters(in: .whitespacesAndNewlines) != nil {
            
        }
        let selectedFirstNum:Int! = Int(firstnum)
        let selectedLastNum:Int! = Int(lastnum)
        let numArray = Array(selectedFirstNum...selectedLastNum)
        userDefaults.set(true, forKey: "searchCondition")
        let search = self.storyboard?.instantiateViewController(identifier: "Search") as! Search
        search.searchRef = Ref.whereField("age", isEqualTo: numArray)
        self.dismiss(animated: true, completion: nil)    
    }
}

extension SearchCoditions:UIPickerViewDelegate,UIPickerViewDataSource {
    
    //ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    
    //ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return firstAgeNumArray.count
        }else if pickerView.tag == 2 {
            return lastAgeNumArray.count
        }
        else{
        return prefectures.count
        }
    }
    
    //ドラムロールの各項目
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return String(firstAgeNumArray[row]) + "才"
        }else if pickerView.tag == 2 {
            return String(lastAgeNumArray[row]) + "才"
        }
        else{
        return prefectures[row]
        }
    }

    //選択時の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            firstnum = firstAgeNumArray[row]
            firstNum.text = String(firstnum) + "才"
            lastAgeNumArray = Array(firstnum + 1...99)
            picker2.reloadAllComponents()
        }else if pickerView.tag == 2 {
            lastnum = lastAgeNumArray[row]
            lastNum.text = String(lastnum) + "才"
            firstAgeNumArray = Array(20...lastnum - 1)
            picker1.reloadAllComponents()
        }else{
            region = prefectures[row]
            if region != "未選択" {
                Ref = Ref.whereField("region", isEqualTo: region)
            }
        }
    }
    
    @objc func cancelBarButton(_ sender: UIBarButtonItem) {
        firstNum.text = nil
        lastNum.text = nil
    }
    
    @objc func doneBarButton(_ sender: UIBarButtonItem) {
        firstNum.resignFirstResponder()
        lastNum.resignFirstResponder()
    }
    
}

//ピッカービューをtoolbarに設定
extension SearchCoditions{
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)

        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 12
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButton(_:)))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButton(_:)))

        let toolbarItems = [space, cancelItem, flexSpaceItem, doneButtonItem, space]

        toolbar.setItems(toolbarItems, animated: true)

        return toolbar
    }
}
