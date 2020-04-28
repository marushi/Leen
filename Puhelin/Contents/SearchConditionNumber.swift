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
    @IBOutlet weak var contentView: UIView!
    
    var ageArray:[Any] = Array(20..<61)
    
    var pickerMode:Int!
    var searchQuery:searchQueryData?
    var delegate:searchConditionDelegate?
    var minrow:Int = 0
    var maxrow:Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //View
        pickerView.delegate = self
        pickerView.dataSource = self
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
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
        self.searchQuery?.minAge = nil
        self.searchQuery?.maxAge = nil
        self.delegate?.searchQueryFunction(self.searchQuery!)
        self.dismiss(animated: true, completion: nil)
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
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if row == 0 {
                return"\(ageArray[row])"
            }else{
                return "\(ageArray[row])" + "歳"
            }
    }*/
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        // 表示するラベルを生成する
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .red
        if row == 0 {
            label.text = "\(ageArray[row])"
        }else{
            label.text =  "\(ageArray[row])" + "歳"
        }
        return label
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
