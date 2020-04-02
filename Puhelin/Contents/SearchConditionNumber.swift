//
//  SearchConditionNumber.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/01.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class SearchConditionNumber: UIViewController{

    @IBOutlet weak var pickerView: UIPickerView!
    
    var ageArray:[Any] = Array(20..<61)
    
    var pickerMode:Int!
    var searchQuery:searchQueryData?
    var delegate:searchConditionDelegate?
    var minrow:Int = 0
    var maxrow:Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        //配列
        ageArray.insert("未選択", at: 0)
        //データの受け渡し
        //Modalの設定
        let nav = self.presentingViewController as? UINavigationController
        delegate = nav?.topViewController as? SearchCoditions
    }
    
    @IBAction func reset(_ sender: Any) {
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
        self.pickerView.selectRow(0, inComponent: 1, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
        let location = touch.location(in: self.view) //in: には対象となるビューを入れます
        let ynum = self.view.frame.size.height - 250
        if location.y < ynum {
            self.delegate?.searchQueryFunction(self.searchQuery!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension SearchConditionNumber: UIPickerViewDelegate,UIPickerViewDataSource {
    //pickerの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //pickerの項目の数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var arrayNum:Int!
        if pickerMode == 1 {
            arrayNum = ageArray.count
        }
        return arrayNum
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if row == 0 {
                return"\(ageArray[row])"
            }else{
                return "\(ageArray[row])" + "歳"
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerMode == 1 {
            if component == 0{
                if row == 0 {
                    self.searchQuery?.minAge = nil
                }
                if row >= maxrow {
                    return
                }else{
                    searchQuery?.minAge = ageArray[row] as? Int
                    self.minrow = row
                }
            }else{
                if row == 0 {
                    self.searchQuery?.maxAge = nil
                }
                if row <= minrow{
                    return
                }else{
                    searchQuery?.maxAge = ageArray[row] as? Int
                    self.maxrow = row
                }
            }
        }
    }
}
