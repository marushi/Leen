//
//  Information.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/02.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class Information: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var infoData:[InformationData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView(frame: .zero)
        //セルの登録
        let nib = UINib(nibName: "informationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "informationCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellNum:Int!
        if infoData?.count != nil && infoData?.count != 0{
            cellNum = infoData!.count
        }else{
            cellNum = 0
        }
        return cellNum
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! informationCell
        cell.selectionStyle = .none
        cell.infoData = infoData
        cell.setUp(indexPath.row)
        return cell
    }
    
    //せるをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let information2 = self.storyboard?.instantiateViewController(identifier: "information2") as! information2
        information2.infodata = infoData![indexPath.row]
        self.navigationController?.pushViewController(information2, animated: true)
        
    }
}
