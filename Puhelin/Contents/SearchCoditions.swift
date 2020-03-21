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
    
    let userDefaults = UserDefaults.standard
    
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
        
        //tableviewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = 50
        
        //セルの登録
        let nib = UINib(nibName: "SearchConditionsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchConditionsCell")
        
        //UIbuttonの設定
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(Button(_:)), for: UIControl.Event.touchUpInside)
        button.backgroundColor = ColorData.salmon
        button.setTitleColor(.white, for: .normal)
        button.setTitle("条件変更", for: .normal)
        button.frame = CGRect(x: (self.view.frame.width - 250) / 2, y: self.view.frame.height - 120, width: 250, height: 60)
        button.layer.cornerRadius = button.frame.size.height / 2
        self.view.addSubview(button)
        
        //異性の相手をビューに表示
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.FemalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.MalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        }
        
        let tab = self.presentingViewController as? TabBarConrtroller
        let nav = tab?.viewControllers?[0] as? UINavigationController
        delegate = nav?.topViewController as? Search
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //タブバー 表示
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @objc func Button(_ sender: Any) {
        //インジゲーター
        HUD.show(.progress)
        //データ入れ
        var Ref = Firestore.firestore().collection(DB).limit(to: 10)
        let num:Int = searchQuery!.prefecturs!.count - 1
        if num >= 0 {
            for i in 0...num {
                Ref = Ref.whereField("region", isEqualTo: searchQuery?.prefecturs![i] as Any)
            }
        }
        if searchQuery?.age != nil {
        }
        if searchQuery?.bodyType != "こだわらない" {
            Ref = Ref.whereField("bodyType", isEqualTo: searchQuery?.bodyType as Any)
        }
        if searchQuery?.talk != "こだわらない" {
            Ref = Ref.whereField("talk", isEqualTo: searchQuery?.talk as Any)
        }
        if searchQuery?.tall != nil {
        }
        if searchQuery?.purpose  != "こだわらない" {
            Ref = Ref.whereField("purpose", isEqualTo: searchQuery?.purpose as Any)
            
        }
        Ref.getDocuments() { (querySnapshot, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            HUD.hide()
            return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.UserArray = querySnapshot!.documents.map { document in               print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = UserData(document: document)
                return userData
            }
            self.delegate?.searchConResultFunction(self.UserArray)
            self.dismiss(animated: true, completion: nil)
            HUD.hide()
        }
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        //アラート
        let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("さがす画面へ") {
                //探す画面に戻る
                self.tabBarController?.tabBar.isHidden = false
                self.dismiss(animated: true, completion: nil)
            }
            alertView.addButton("戻る",backgroundColor: .lightGray,textColor: .black) {
                return
            }
            alertView.showSuccess("検索条件は保存されません。よろしいですか？", subTitle: "")
        }
        
}


//tableviewの設定
extension SearchCoditions:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchConditionsCell") as! SearchConditionsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.searchQuery = self.searchQuery
        cell.setUp(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SearchConditions2 = self.storyboard?.instantiateViewController(identifier: "SearchConditions2") as! SearchConditions2
        if indexPath.row == 1{
            return
        }else{
            SearchConditions2.setUp(indexPath.row)
            SearchConditions2.searchQuery = self.searchQuery
        }
        self.navigationController?.pushViewController(SearchConditions2, animated: true)
    }
}

extension SearchCoditions:searchConditionDelegate{
    func searchQueryFunction(_ query: searchQueryData) {
        self.searchQuery = query
    }
}

protocol searchConResultDelegate {
    func searchConResultFunction(_ userData:[UserData])
}
