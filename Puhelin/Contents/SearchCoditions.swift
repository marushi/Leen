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
    
    //検索条件用の変数
    var region:String!
    var regionArray:[String] = []
    var minAge:Int = 20
    var maxAge:Int = 30
    var personality1:Int! = 0
    var personality2:Int! = 0
    var personality3:Int! = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        button.layer.cornerRadius = 10
        button.backgroundColor = ColorData.salmon
        button.setTitleColor(.white, for: .normal)
        button.setTitle("条件変更", for: .normal)
        button.frame = CGRect(x: (self.view.frame.width - 200) / 2, y: self.view.frame.height - 150, width: 200, height: 40)
        self.view.addSubview(button)
        
        //異性の相手をビューに表示
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.FemalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.MalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        }
        
    }
    
    @objc func Button(_ sender: Any) {
        //インジゲーター
        HUD.show(.progress)
        
        let Ref = Firestore.firestore().collection(DB)
            .whereField("region", isEqualTo: region as Any)
            .whereField("personality.1.\(personality1!)", isEqualTo: true)
            .whereField("personality.2.\(personality2!)", isEqualTo: true)
            .whereField("personality.3.\(personality3!)", isEqualTo: true)
            .whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
        
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
            //PKHUD
            HUD.hide()
            let nav = self.presentingViewController as! TabBarConrtroller
            let search = nav.viewControllers![0] as! Search
            search.UserArray = self.UserArray
            search.searchCondition = true
            search.collectionView.reloadData()
            self.dismiss(animated: true,completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        //アラート
        let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("さがす画面へ") {
                //探す画面に戻る
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
        cell.personality1 = self.personality1
        cell.personality2 = self.personality2
        cell.personality3 = self.personality3
        cell.setUp(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SearchConditions2 = self.storyboard?.instantiateViewController(identifier: "SearchConditions2") as! SearchConditions2
        if indexPath.row == 1{
            return
        }else{
            SearchConditions2.setUp(indexPath.row)
        }
        self.navigationController?.pushViewController(SearchConditions2, animated: true)
    }
}
