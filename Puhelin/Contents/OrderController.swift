//
//  OrderController.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase

class OrderController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var searchQuery:searchQueryData?
    var selectNum:Int?
    var delegate:orderdelegate?
    var UserArray:[UserData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        //セルの登録
        let nib = UINib(nibName: "orderCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "orderCell")
        //Modalの設定
        let nav = self.presentingViewController as? UINavigationController
        delegate = nav?.topViewController as? Search
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
        let location = touch.location(in: self.view) //in: には対象となるビューを入れます
        let ynum = self.view.frame.size.height - 250
        if location.y < ynum {
            self.dismiss(animated: true, completion: nil)
            delegate?.orderFunc(Type: 0)
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

extension OrderController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as! orderCell
        if let num = selectNum {
            orderCell.selectCell = num - 1
        }
        orderCell.setData(indexPath.row)
        return orderCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectNum = indexPath.row + 1
        self.tableView.reloadData()
        //検索処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.orderFunc(Type: self.selectNum!)
            self.tabBarController?.tabBar.isHidden = false
            self.dismiss(animated: true, completion: nil)}
        }
        
    

    }
protocol orderdelegate {
    func orderFunc(Type:Int)
}
