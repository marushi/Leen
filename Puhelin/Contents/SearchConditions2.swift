//
//  SearchConditions2.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/06.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class SearchConditions2: UIViewController,UITableViewDataSource,UITableViewDelegate ,UINavigationControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    //データ用変数
    var cellNum:Int!
    var conditionCase:Int!
    var selectRow:String?
    var selectsArray:[String] = []
    var searchQuery:searchQueryData?
    var delegate:searchConditionDelegate?
    
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
    let per3 = ["こだわらない","がっしり","細め"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        let nav = self.navigationController
        delegate = nav!.viewControllers[nav!.viewControllers.count - 2] as? SearchCoditions
        self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //タブバー 表示
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //
    //
    //戻る時の処理
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is SearchCoditions {
            switch conditionCase {
            case 0:
                self.searchQuery?.prefecturs = self.selectsArray
            case 2:
                self.searchQuery?.talk = self.selectRow
            case 3:
                self.searchQuery?.purpose = self.selectRow
            case 4:
                self.searchQuery?.bodyType = self.selectRow
            default:
                return
            }
            let vc = viewController as! SearchCoditions
            vc.tableView.reloadData()
            self.delegate?.searchQueryFunction(self.searchQuery!)
        }
    }
    
    
    //
    //---------------------------Tableviewの設定ーーーーーーーーーーーーー
    //
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNum
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        switch conditionCase {
        case 0:
            tableView.allowsMultipleSelectionDuringEditing = true
            cell.titleLabel.text = prefectures[indexPath.row]
             if (selectsArray.contains(prefectures[indexPath.row])){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 2:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per1[indexPath.row]
            if (selectRow == per1[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 3:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per2[indexPath.row]
            if (selectRow == per2[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 4:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per3[indexPath.row]
            if (selectRow == per3[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        default:
            return cell
        }
        return cell
    }
    
    //セルを選択した時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        //セルのチェックがない時
        if(cell.accessoryType == UITableViewCell.AccessoryType.none){
            cell.accessoryType = .checkmark
            switch conditionCase {
            case 0:
                if indexPath.row == 0{
                    selectsArray = []
                }else{
                    self.selectsArray.append(prefectures[indexPath.row])
                }
            case 2:
                selectRow = per1[indexPath.row]
            case 3:
                selectRow = per2[indexPath.row]
            case 4:
                selectRow = per3[indexPath.row]
            default:
                return
            }
        }
        //セルにチェックがある時
        else{
            cell.accessoryType = .none
            if conditionCase  == 0 {
                if indexPath.row != 0 {
                let  listNumber = selectsArray.filter ({ (n:String) -> Bool in
                    if n != prefectures[indexPath.row]{
                        return true
                    }else{
                        return false
                    }})
                selectsArray = listNumber
                }
            }
        }
        if selectsArray == [] {
            selectsArray = []
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
}

protocol searchConditionDelegate {
    func searchQueryFunction(_ query:searchQueryData)
}
