//
//  Personality2.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/10.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

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
        
    //定数
    let per0 = ["どちらでも","話す方","聞く方"]
    let per1 = ["どちらでも","ライトな関係","真剣交際"]
    let per2 = ["どちらでも","インドア派","アウトドア派"]
    
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

    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNum
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
        switch conditionCase {
        case 0:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per0[indexPath.row]
            if (selectRow == indexPath.row){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 1:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per1[indexPath.row]
            if (selectRow == indexPath.row){
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        case 2:
            tableView.allowsMultipleSelectionDuringEditing = false
            cell.titleLabel.text = per2[indexPath.row]
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
                    selectString = self.per0[selectRow]
                case 1:
                    selectRow = indexPath.row
                    selectString = self.per1[selectRow]
                case 2:
                    selectRow = indexPath.row
                    selectString = self.per2[selectRow]
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
                cellNum = per0.count
                conditionCase = 0
            case 1:
                cellNum = per1.count
                conditionCase = 1
            case 2:
                cellNum = per2.count
                conditionCase = 2
            default:
                return
            }
        }
        
        //確定ボタンの処理
        @IBAction func selectButton(_ sender: Any) {
            let nav = self.navigationController!
            let pre = nav.viewControllers[nav.viewControllers.count - 2] as! EditProfile
            switch conditionCase {
            case 0:
                pre.personality0 = selectString
                pre.selectRow0 = selectRow
            case 1:
                pre.personality1 = selectString
                pre.selectRow1 = selectRow
            case 2:
                pre.personality2 = selectString
                pre.selectRow2 = selectRow
            default:
                return
                }
            pre.tableView.reloadData()
            self.navigationController?.popViewController(animated: true)
        }
}
