//
//  SearchConditions2.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/06.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class SearchConditions2: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //データ用変数
    var cellNum:Int!
    var conditionCase:Int!
    var selectRow:Int!
    var selectsArray:[Int] = []
    
    //データ用定数
    let prefectures = ["こだわらない","北海道", "青森県", "岩手県", "宮城県", "秋田県",
    "山形県", "福島県", "茨城県", "栃木県", "群馬県",
    "埼玉県", "千葉県", "東京都", "神奈川県","新潟県",
    "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県",
    "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
    "鳥取県", "島根県", "岡山県", "広島県", "山口県",
    "徳島県", "香川県", "愛媛県", "高知県", "福岡県",
    "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
    "鹿児島県", "沖縄県"]
    let per1 = ["こだわらない","話す方","聞く方"]
    let per2 = ["こだわらない","ライトな関係","真剣交際"]
    let per3 = ["こだわらない","インドア派","アウトドア派"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        switch conditionCase {
        case 0:
            tableView.allowsMultipleSelectionDuringEditing = true
            cell.titleLabel.text = prefectures[indexPath.row]
             if (selectsArray.contains(indexPath.row)){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 2:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per1[indexPath.row]
            if (selectRow == indexPath.row){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 3:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per2[indexPath.row]
            if (selectRow == indexPath.row){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 4:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per3[indexPath.row]
            if (selectRow == indexPath.row){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if(cell.accessoryType == UITableViewCell.AccessoryType.none){
            cell.accessoryType = .checkmark
            switch conditionCase {
            case 0:
                if indexPath.row == 0{
                    selectsArray = [0]
                }else{
                    self.selectsArray.append(indexPath.row)
                }
            case 2:
                selectRow = indexPath.row
            case 3:
                selectRow = indexPath.row
            case 4:
                selectRow = indexPath.row
            default:
                return
            }
        }else{
            cell.accessoryType = .none
            if conditionCase  == 0 {
                if indexPath.row != 0 {
                let  listNumber = selectsArray.filter ({ (n:Int) -> Bool in
                    if n != indexPath.row{
                        return true
                    }else{
                        return false
                    }})
                selectsArray = listNumber
                }
            }
        }
        if selectsArray == [] {
            selectsArray = [0]
        }
        selectsArray.sort{ $0 < $1 }
        tableView.reloadData()
        print(selectsArray)
        
    }
    
    func setUp(_ row:Int) {
        switch row {
        case 0:
            cellNum = prefectures.count
            conditionCase = 0
        case 2:
            cellNum = per1.count
            conditionCase = 2
        case 3:
            cellNum = per2.count
            conditionCase = 3
        case 4:
            cellNum = per3.count
            conditionCase = 4
        default:
            return
        }
    }
    
    //確定ボタンの処理
    @IBAction func selectButton(_ sender: Any) {
        let nav = self.navigationController!
        let pre = nav.viewControllers[nav.viewControllers.count - 2] as! SearchCoditions
        if selectRow != nil{
        switch conditionCase {
        case 0:
            pre.regionArray = prefectures
        case 2:
            pre.personality1 = selectRow
        case 3:
            pre.personality2 = selectRow
        case 4:
            pre.personality3 = selectRow
        default:
            return
            }}
        pre.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}
