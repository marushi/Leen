//
//  Purchase.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/20.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import StoreKit

class Purchase: UIViewController {

    
    //定数
    let productIdentifiers : [String] = ["goodPt"]
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // プロダクト情報取得
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension Purchase:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell") as! PurchaseCell
        cell.setData(indexPath.row)
        cell.selectionStyle = .none
        cell.purchaseButton.tag = indexPath.row + 1
        return cell
    }
    
}
