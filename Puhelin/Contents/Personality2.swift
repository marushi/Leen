//
//  Personality2.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/10.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class Personality2: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    //データ用変数
    var cellNum:Int!
    var conditionCase:Int!
    var selectString = "どちらでも"
    var selectsArray:[Int] = []
    var selectRow = 0
    var delegate:perToEdit?
        
    //定数
    let talkArray = ["どちらでも","話す方","聞く方"]
    let purposeArray = ["どちらでも","ライトな関係","真剣交際"]
    let bodyTypeArray = ["普通","がっしり","細め"]
    let prefectures = ["北海道", "青森県", "岩手県", "宮城県", "秋田県",
    "山形県", "福島県", "茨城県", "栃木県", "群馬県",
    "埼玉県", "千葉県", "東京都", "神奈川県","新潟県",
    "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県",
    "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
    "鳥取県", "島根県", "岡山県", "広島県", "山口県",
    "徳島県", "香川県", "愛媛県", "高知県", "福岡県",
    "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
    "鹿児島県", "沖縄県"]
    let userDefaults = UserDefaults.standard
    let uid = UserDefaults.standard.string(forKey: "uid")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        //アウトレットの設定
        let viewWidth = contentView.frame.width
        cancelButton.frame.size.width = viewWidth / 2
        okButton.frame.size.width = viewWidth / 2
        self.contentView.layer.cornerRadius = 10
        
        //delegateの設定
        let nav = self.presentingViewController as? UINavigationController
        delegate = nav?.topViewController as? EditProfile

    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNum
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
        switch conditionCase {
        case 0:
            self.titleLabel.text = "居住地"
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = prefectures[indexPath.row]
            if (selectRow == indexPath.row){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 1:
            self.titleLabel.text = "体型"
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = bodyTypeArray[indexPath.row]
            if (selectRow == indexPath.row){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 2:
            self.titleLabel.text = "会話"
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = talkArray[indexPath.row]
            if (selectRow == indexPath.row){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 3:
            self.titleLabel.text = "目的"
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = purposeArray[indexPath.row]
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
                    selectRow = indexPath.row
                    selectString = self.prefectures[selectRow]
                case 1:
                    selectRow = indexPath.row
                    selectString = self.bodyTypeArray[selectRow]
                case 2:
                    selectRow = indexPath.row
                    selectString = self.talkArray[selectRow]
                case 3:
                    selectRow = indexPath.row
                    selectString = self.purposeArray[selectRow]
                default:
                    return
                }
            }else{
                cell.accessoryType = .none
            }
            tableView.reloadData()
            print(selectsArray)
            
        }
        
        func setUp(_ row:Int) {
            switch row {
            case 0:
                cellNum = prefectures.count
                conditionCase = 0
            case 2:
                cellNum = bodyTypeArray.count
                conditionCase = 1
            case 3:
                cellNum = talkArray.count
                conditionCase = 2
            case 4:
                cellNum = purposeArray.count
                conditionCase = 3
            default:
                return
            }
        }
        
       
    //確定ボタンの処理
    @IBAction func selectButton(_ sender: Any) {
        var dataTitle:String!
        switch conditionCase {
        case 0:
            delegate?.perToEditText(text: selectString, row: 0)
            dataTitle = "region"
        case 1:
            delegate?.perToEditText(text: selectString, row: 1)
            dataTitle = "bodyType"
        case 2:
            delegate?.perToEditText(text: selectString, row: 2)
            dataTitle = "talk"
        case 3:
            delegate?.perToEditText(text: selectString, row: 3)
            dataTitle = "purpose"
        default:
            return
        }
        //保存先を指定
        var DB = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }else if userDefaults.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }
        let Ref = Firestore.firestore().collection(DB).document(uid!)
        Ref.setData([dataTitle:selectString as Any], merge: true)
        
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//
//EditProfileへの値渡し
//
protocol perToEdit {
    func perToEditText(text:String,row:Int)
}
