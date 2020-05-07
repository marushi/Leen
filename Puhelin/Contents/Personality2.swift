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
    let Tall:[Int] = Array(140..<200)
    let bodyType = ["こだわらない","太ってる","ぽっちゃり","普通","細め","鍛えてる","自信あり","モデル級"]
    let talk = ["こだわらない","おしゃべり","話す方","聞く方","聞き上手"]
    let purpose = ["こだわらない","通話だけ","友達探し","恋人探し"]
    let alchoal = ["こだわらない","ほぼ毎日","週２〜３回","ときどき","たまに","あまり飲まない","飲めない"]
    let tabako = ["こだわらない","吸わない","吸う","相手が嫌ならやめる"]
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
        tableView.backgroundColor = .white
        
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
        cell.selectionStyle = .none
            
        switch conditionCase {
        case 0:
            self.titleLabel.text = "居住地"
            cell.titleLabel.text = prefectures[indexPath.row]
        case 1:
            self.titleLabel.text = "体型"
            cell.titleLabel.text = bodyType[indexPath.row]
        case 2:
            return cell
        case 3:
            return cell
        case 4:
            return cell
        case 5:
            self.titleLabel.text = "会話"
            cell.titleLabel.text = talk[indexPath.row]
        case 6:
            self.titleLabel.text = "目的"
            cell.titleLabel.text = purpose[indexPath.row]
        case 7:
            self.titleLabel.text = "お酒"
            cell.titleLabel.text = alchoal[indexPath.row]
        case 8:
            self.titleLabel.text = "タバコ"
            cell.titleLabel.text = tabako[indexPath.row]
        case 9:
            self.titleLabel.text = "身長"
            cell.titleLabel.text = String(Tall[indexPath.row]) + "cm"
        default:
            return cell
        }
        
        tableView.allowsMultipleSelectionDuringEditing = false
        if (selectRow == indexPath.row){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
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
                    selectString = self.bodyType[selectRow]
                case 2:
                    return
                case 3:
                    return
                case 4:
                    return
                case 5:
                    selectRow = indexPath.row
                    selectString = self.talk[selectRow]
                case 6:
                    selectRow = indexPath.row
                    selectString = self.purpose[selectRow]
                case 7:
                    selectRow = indexPath.row
                    selectString = self.alchoal[selectRow]
                case 8:
                    selectRow = indexPath.row
                    selectString = self.tabako[selectRow]
                case 9:
                    selectRow = indexPath.row
                    selectString = String(Tall[selectRow]) + "cm"
                default:
                    return
                }
            }else{
                cell.accessoryType = .none
            }
            tableView.reloadData()
            
        }
        
        func setUp(_ row:Int) {
            switch row {
            case 2:
                cellNum = prefectures.count
                conditionCase = 0
            case 3:
                cellNum = Tall.count
                conditionCase = 9 //後から追加
            case 4:
                cellNum = bodyType.count
                conditionCase = 1
            case 5:
                return
            /*case 6:
                return*/
            case 6:
                return
            case 7:
                cellNum = talk.count
                conditionCase = 5
            case 8:
                cellNum = purpose.count
                conditionCase = 6
            case 9:
                cellNum = alchoal.count
                conditionCase = 7
            case 10:
                cellNum = tabako.count
                conditionCase = 8
            default:
                return
            }
        }
        
       
    //確定ボタンの処理
    @IBAction func selectButton(_ sender: Any) {
        var dataTitle:String!
        //保存先を指定
        var DB = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }else if userDefaults.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }
        let Ref = Firestore.firestore().collection(DB).document(uid!)
        
        switch conditionCase {
        case 0:
            delegate?.perToEditText(text: selectString, row: 0)
            dataTitle = "region"
        case 1:
            delegate?.perToEditText(text: selectString, row: 1)
            dataTitle = "bodyType"
        case 2:
            delegate?.perToEditText(text: selectString, row: 2)
            dataTitle = "job"
        case 3:
            delegate?.perToEditText(text: selectString, row: 3)
            dataTitle = "income"
        case 4:
            delegate?.perToEditText(text: selectString, row: 4)
            dataTitle = "personality"
        case 5:
            delegate?.perToEditText(text: selectString, row: 5)
            dataTitle = "talk"
        case 6:
            delegate?.perToEditText(text: selectString, row: 6)
            dataTitle = "purpose"
        case 7:
            delegate?.perToEditText(text: selectString, row: 7)
            dataTitle = "alchoal"
        case 8:
            delegate?.perToEditText(text: selectString, row: 8)
            dataTitle = "tabako"
            var tabakoClass:String?
            let str = tabako[selectRow]
            if str == "吸わない" || str == "相手が嫌ならやめる"{
                tabakoClass = "吸わない"
            }else if str == "吸う" {
                tabakoClass = "吸う"
            }
            
            Ref.setData(["tabakoClass":tabakoClass!],merge: true)
        case 9:
            delegate?.perToEditNum(number: Tall[selectRow], row: 9)
            dataTitle = "tall"
            var tallClass:String?
            let num = Tall[selectRow]
            if userDefaults.integer(forKey: "gender") == 1{
                if num < 160 {
                    tallClass = "〜160cm"
                }else if num >= 160 && num < 175 {
                    tallClass = "160〜175cm"
                }else {
                    tallClass = "175cm〜"
                }
            }else{
                if num < 150 {
                    tallClass = "〜150cm"
                }else if num >= 150 && num < 165 {
                    tallClass = "150〜165cm"
                }else {
                    tallClass = "165cm〜"
                }
            }
            Ref.setData(["tallClass":tallClass!],merge: true)
        default:
            return
        }
        if conditionCase == 9{
            Ref.setData(["tall":Tall[selectRow]],merge: true)
        }else{
            Ref.setData([dataTitle:selectString as Any], merge: true)
        }
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
    func perToEditNum(number:Int,row:Int)
}
