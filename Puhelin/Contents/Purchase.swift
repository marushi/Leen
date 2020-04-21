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
    
    //部品
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var puhelinPointLabel: UILabel!
    
    //定数
    let productIdentifiers : [String] = ["goodPt"]
    let userDefaults = UserDefaults.standard
    
    //変数
    var PuhelinPoint:Int?
    var PurchaseBool:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //部品設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = tableView.frame.height / 4
        // プロダクト情報取得
        fetchProductInformationForIds(productIdentifiers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        PuhelinPoint = userDefaults.integer(forKey: UserDefaultsData.PuhelinPoint)
        puhelinPointLabel.text = "\(PuhelinPoint!)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if self.PurchaseBool == true {
            let tab = self.presentingViewController as? TabBarConrtroller
            let nav = tab?.viewControllers?[3] as? UINavigationController
            let pre = nav?.topViewController as? MyProfile
            //pre?.collectionView.reloadData()
            self.PurchaseBool = false
        }
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
        cell.purchaseButton.addTarget(self, action: #selector(purchaseStart), for: .touchUpInside)
        return cell
    }
    
    @objc func purchaseStart(_ sender:UIButton){
        let tag = sender.tag
        switch tag {
        case 1:
            startPurchase(productIdentifier: productIdentifiers[0])
        case 2:
            return
        default:
            return
        }
    }
    
    
}

extension Purchase:PurchaseManagerDelegate{
    //------------------------------------
    // 課金処理開始
    //------------------------------------
    func startPurchase(productIdentifier : String) {
        print("課金処理開始!!")
        //デリゲード設定
        PurchaseManager.sharedManager().delegate = self
        //プロダクト情報を取得
        ProductManager.productsWithProductIdentifiers(productIdentifiers: [productIdentifier], completion: { (products, error) -> Void in
            if (products?.count)! > 0 {
                //課金処理開始
                PurchaseManager.sharedManager().startWithProduct((products?[0])!)
            }
            if (error != nil) {
                print(error as Any)
            }
        })
    }

    // リストア開始
    func startRestore() {
        //デリゲード設定
        PurchaseManager.sharedManager().delegate = self
        //リストア開始
        PurchaseManager.sharedManager().startRestore()
    }

    //------------------------------------
    // MARK: - PurchaseManager Delegate
    //------------------------------------
    //課金終了時に呼び出される
    func purchaseManager(_ purchaseManager: PurchaseManager!, didFinishPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((_ complete: Bool) -> Void)!) {
        print("課金終了！！")
        self.PurchaseBool = true
        self.PuhelinPoint! += 10
        userDefaults.set(PuhelinPoint, forKey: UserDefaultsData.PuhelinPoint)
        loadView()
        viewDidLoad()
        viewWillAppear(true)
        decisionHandler(true)
    }

    //課金終了時に呼び出される(startPurchaseで指定したプロダクトID以外のものが課金された時。)
    func purchaseManager(_ purchaseManager: PurchaseManager!, didFinishUntreatedPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((_ complete: Bool) -> Void)!) {
        print("課金終了（指定プロダクトID以外）！！")
        //---------------------------
        // コンテンツ解放処理
        //---------------------------


        //コンテンツ解放が終了したら、この処理を実行(true: 課金処理全部完了, false 課金処理中断)
        decisionHandler(true)
    }

    //課金失敗時に呼び出される
    func purchaseManager(_ purchaseManager: PurchaseManager!, didFailWithError error: NSError!) {
        print("課金失敗！！")
        // TODO errorを使ってアラート表示
    }

    // リストア終了時に呼び出される(個々のトランザクションは”課金終了”で処理)
    func purchaseManagerDidFinishRestore(_ purchaseManager: PurchaseManager!) {
        print("リストア終了！！")
        // TODO インジケータなどを表示していたら非表示に
    }

    // 承認待ち状態時に呼び出される(ファミリー共有)
    func purchaseManagerDidDeferred(_ purchaseManager: PurchaseManager!) {
        print("承認待ち！！")
        // TODO インジケータなどを表示していたら非表示に

    }

    // プロダクト情報取得
    fileprivate func fetchProductInformationForIds(_ productIds:[String]) {
        ProductManager.productsWithProductIdentifiers(productIdentifiers: productIds,completion: {[weak self] (products : [SKProduct]?, error : NSError?) -> Void in
            if error != nil {
                if self != nil {
                }
                print(error?.localizedDescription as Any)
                return
            }

            for product in products! {
                let priceString = ProductManager.priceStringFromProduct(product: product)
                if self != nil {
                    print(product.localizedTitle + ":\(priceString)")
                }
                print(product.localizedTitle + ":\(priceString)" )
            }
            })
    }
}
