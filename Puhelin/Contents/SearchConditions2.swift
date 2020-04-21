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
    let region = ["こだわらない","北海道","東北", "関東","中部","近畿","中国","四国","九州","沖縄"]
    let bodyType = ["こだわらない","ぽっちゃり","普通","細め"]
    let job = ["こだわらない","営業","会社員","医師","弁護士"]
    let income = ["こだわらない","200万","300万","1億以上"]
    let personality = ["こだわらない","マイペース","明るい"]
    let talk = ["こだわらない","おしゃべり","話す方","聞く方","聞き上手"]
    let purpose = ["こだわらない","ライトな関係","真剣交際"]
    let alchoal = ["こだわらない","ほぼ毎日","週２〜３回","ときどき","たまに","あまり飲まない","飲めない"]
    let tabako = ["こだわらない","吸わない","ごくたまに","飲みの時だけ","1日に数本","1日に一箱"]
    let maleTall = ["こだわらない","〜160cm","160〜175cm","175cm〜"]
    let femaleTall = ["こだわらない","〜150cm","150〜165cm","165cm〜"]
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
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
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
            case 1:
                self.searchQuery?.region = self.selectsArray
            case 2:
                self.searchQuery?.bodyType = self.selectRow
            case 3:
                self.searchQuery?.job = self.selectRow
            case 4:
                self.searchQuery?.income = self.selectRow
            case 5:
                self.searchQuery?.personality = self.selectRow
            case 6:
                self.searchQuery?.talk = self.selectRow
            case 7:
                self.searchQuery?.purpose = self.selectRow
            case 8:
                self.searchQuery?.alchoal = self.selectRow
            case 9:
                self.searchQuery?.tabako = self.selectRow
            case 10:
                self.searchQuery?.tallClass = self.selectRow
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let label : UILabel = UILabel()
        label.backgroundColor = ColorData.whitesmoke
        label.textColor = .darkGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        if self.conditionCase == 1 {
            label.text = "　※ 複数選択可（5つまで）"
        }else{
            label.text = "　※ 複数選択不可　　"
        }
        return label
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNum
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        switch conditionCase {
        case 1:
            tableView.allowsMultipleSelectionDuringEditing = true
            cell.titleLabel.text = region[indexPath.row]
            //すでに検索条件が設定されている時
            //文字列を都道府県配列から検索して一致する要素のインデックスパスをセレクト配列に入れる。
            //チェックマークは下の処理でつけてもらう
            if self.searchQuery?.prefecturs?.count != 0{
                let searchdata = searchQuery?.prefecturs
                for hikaku1 in searchdata! {
                    for hikaku2 in self.region {
                        if hikaku1 == hikaku2 {
                        
                            if selectsArray.contains(hikaku1) == false {
                                self.selectsArray.append(hikaku1)
                            }
                        }
                    }
                }
                self.searchQuery?.prefecturs = []
            }
             if (selectsArray.contains(region[indexPath.row])){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            if selectsArray == [] && indexPath.row == 0{
                cell.accessoryType = .checkmark
            }
        case 2:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = bodyType[indexPath.row]
            if (selectRow == bodyType[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 3:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = job[indexPath.row]
            if (selectRow == job[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 4:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = income[indexPath.row]
            if (selectRow == income[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 5:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = personality[indexPath.row]
            if (selectRow == personality[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 6:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = talk[indexPath.row]
            if (selectRow == talk[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 7:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = purpose[indexPath.row]
            if let  str = self.searchQuery?.purpose {
                self.selectRow = str
                searchQuery?.purpose = nil
            }
            if (selectRow == purpose[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 8:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = alchoal[indexPath.row]
            if (selectRow == alchoal[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 9:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = tabako[indexPath.row]
            if (selectRow == tabako[indexPath.row]){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 10:
            tableView.allowsMultipleSelectionDuringEditing = true
            if let  str = self.searchQuery?.tallClass {
                self.selectRow = str
                searchQuery?.tallClass = nil
            }
            if UserDefaults.standard.integer(forKey: "gender") == 1{
                cell.titleLabel.text = femaleTall[indexPath.row]
                if (selectRow == femaleTall[indexPath.row]){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else{
                cell.titleLabel.text = maleTall[indexPath.row]
                if (selectRow == maleTall[indexPath.row]){
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
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
            switch conditionCase {
            case 1:
                if indexPath.row == 0{
                    selectsArray = []
                    cell.accessoryType = .checkmark
                }else if selectsArray.count == 5 && indexPath.row != 0 {
                    return
                }else{
                    self.selectsArray.append(region[indexPath.row])
                    cell.accessoryType = .checkmark
                }
            case 2:
                selectRow = bodyType[indexPath.row]
            case 3:
                selectRow = job[indexPath.row]
            case 4:
                selectRow = income[indexPath.row]
            case 5:
                selectRow = personality[indexPath.row]
            case 6:
                selectRow = talk[indexPath.row]
            case 7:
                selectRow = purpose[indexPath.row]
            case 8:
                selectRow = alchoal[indexPath.row]
            case 9:
                selectRow = tabako[indexPath.row]
            case 10:
                if UserDefaults.standard.integer(forKey: "gender") == 1{
                    selectRow = femaleTall[indexPath.row]
                }else{
                    selectRow = maleTall[indexPath.row]
                }
            default:
                return
            }
        }
        //セルにチェックがある時
        else{
            cell.accessoryType = .none
            if conditionCase  == 1 {
                if indexPath.row != 0 {
                let  listNumber = selectsArray.filter ({ (n:String) -> Bool in
                    if n != region[indexPath.row]{
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
        
    }
    
    func setUp(_ row:Int) {
        switch row {
        case 0:
            cellNum = region.count
            conditionCase = 1
        case 2:
            conditionCase = 10 // 身長後から追加
            if UserDefaults.standard.integer(forKey: "gender") == 1{
                cellNum = femaleTall.count
            }else{
                cellNum = maleTall.count
            }
        case 3:
            cellNum = purpose.count
            conditionCase = 7
        case 4:
            cellNum = job.count
            conditionCase = 3
        case 5:
            cellNum = income.count
            conditionCase = 4
        case 6:
            cellNum = personality.count
            conditionCase = 5
        case 7:
            cellNum = talk.count
            conditionCase = 6
        case 8:
            cellNum = purpose.count
            conditionCase = 7
        case 9:
            cellNum = alchoal.count
            conditionCase = 8
        case 10:
            cellNum = tabako.count
            conditionCase = 9
            
        default:
            return
        }
    }
}

protocol searchConditionDelegate {
    func searchQueryFunction(_ query:searchQueryData)
}
