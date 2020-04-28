//
//  SearchCoditions.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import SCLAlertView

class SearchCoditions: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var registButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    let sectionTitle = ["検索項目","年齢","身長","出会いの目的"]
    
    var UserArray:[UserData] = []
    var DB = ""
    var region:String!
    var regionArray:[String] = []
    var minAge:Int = 20
    var maxAge:Int = 30
    var searchQuery:searchQueryData?
    var delegate:searchConResultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        //部品設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.rowHeight = 70
        resetButton.layer.cornerRadius = resetButton.frame.height / 2
        registButton.layer.cornerRadius = registButton.frame.height / 2
        
        //セルの登録
        let nib = UINib(nibName: "SearchConditionsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchConditionsCell")
        
        //異性の相手をビューに表示
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.FemalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.MalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        }
        
        let pre = self.navigationController?.viewControllers[0] as? Search
        delegate = pre
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //タブバー 表示
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func registCondition(_ sender: Any) {
        if searchQuery?.prefecturs == [] && searchQuery?.minAge == nil && searchQuery?.maxAge == nil && searchQuery?.tallClass == nil && searchQuery?.purpose == nil && searchQuery?.tabakoClass == nil{
            self.delegate?.searchConResultFunction(query: self.searchQuery, type: 3)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.delegate?.searchConResultFunction(query: self.searchQuery,type: 1)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    @IBAction func resetButton(_ sender: Any) {
        searchQuery = nil
        searchQuery = searchQueryData()
        self.delegate?.searchConResultFunction(query: self.searchQuery, type: 3)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        if searchQuery?.prefecturs == [] && searchQuery?.minAge == nil && searchQuery?.maxAge == nil && searchQuery?.tallClass == nil && searchQuery?.purpose == nil && searchQuery?.tabakoClass == nil{
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }else{
        //アラート
        let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("さがす画面へ") {
                //探す画面に戻る
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.popViewController(animated: true)
            }
            alertView.addButton("戻る",backgroundColor: .lightGray,textColor: .black) {
                return
            }
            alertView.showSuccess("検索条件は保存されません。よろしいですか？", subTitle: "")
        }
    }
        
}


//tableviewの設定
extension SearchCoditions:UITableViewDelegate,UITableViewDataSource{

    //セクションの数を返す.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "　　" + self.sectionTitle[section]
        label.textColor = ColorData.salmon
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.frame.size.height = 30
        label.backgroundColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchConditionsCell") as! SearchConditionsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.searchQuery = self.searchQuery
        cell.setUp(indexPath.row)
        cell.backgroundColor = .white
        return cell
    }
    
    //選択時処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SearchConditions2 = self.storyboard?.instantiateViewController(identifier: "SearchConditions2") as! SearchConditions2
        if indexPath.row == 1{
            let SearchConditionNumber = self.storyboard?.instantiateViewController(identifier: "SearchConditionNumber") as! SearchConditionNumber
            SearchConditionNumber.modalTransitionStyle = .coverVertical
            SearchConditionNumber.pickerMode = indexPath.row
            SearchConditionNumber.searchQuery = searchQuery
            present(SearchConditionNumber,animated: true,completion: nil)
        }else{
            SearchConditions2.setUp(indexPath.row)
        }
        SearchConditions2.searchQuery = self.searchQuery
        self.navigationController?.pushViewController(SearchConditions2, animated: true)
    }
}

extension SearchCoditions:searchConditionDelegate{
    func searchQueryFunction(_ query: searchQueryData) {
        self.searchQuery = query
        self.tableView.reloadData()
    }
}

protocol searchConResultDelegate {
    func searchConResultFunction(query:searchQueryData?,type: Int)
}
