//
//  CallBilling.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/07.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import StoreKit

class CallBilling: UIViewController {
    
    @IBOutlet weak var titleView1: UIView!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var standard1: UIView!
    @IBOutlet weak var standard2: UIView!
    @IBOutlet weak var stndard3: UIView!
    @IBOutlet weak var kaifukuken: UIView!
    
    let productIdentifiers : [String] = ["callLimitRelease1","callLimitRelease2","callLimitRelease3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        titleView1.layer.cornerRadius = 75
        kaifukuken.layer.cornerRadius = 75
        titleView1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        titleView1.layer.shadowColor = UIColor.black.cgColor
        titleView1.layer.shadowOpacity = 0.6
        titleView1.layer.shadowRadius = 2
        kaifukuken.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        kaifukuken.layer.shadowColor = UIColor.black.cgColor
        kaifukuken.layer.shadowOpacity = 0.6
        kaifukuken.layer.shadowRadius = 2
        titleLabel1.layer.cornerRadius = titleLabel1.frame.size.height / 2
        titleLabel1.clipsToBounds = true
        standard1.layer.cornerRadius = 30
        standard2.layer.cornerRadius = 30
        stndard3.layer.cornerRadius = 30
        standard1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        standard1.layer.shadowColor = UIColor.black.cgColor
        standard1.layer.shadowOpacity = 0.6
        standard1.layer.shadowRadius = 2
        standard2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        standard2.layer.shadowColor = UIColor.black.cgColor
        standard2.layer.shadowOpacity = 0.6
        standard2.layer.shadowRadius = 2
        stndard3.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        stndard3.layer.shadowColor = UIColor.black.cgColor
        stndard3.layer.shadowOpacity = 0.6
        stndard3.layer.shadowRadius = 2
        
        // プロダクト情報取得
        fetchProductInformationForIds(productIdentifiers)
        
        // ジェスチャーの生成・追加
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture1(gestureRecognizer:)))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture2(gestureRecognizer:)))
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture3(gestureRecognizer:)))
        standard1.addGestureRecognizer(tapGestureRecognizer1)
        standard2.addGestureRecognizer(tapGestureRecognizer2)
        stndard3.addGestureRecognizer(tapGestureRecognizer3)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // ジェスチャーイベント処理
       @objc func tapGesture1(gestureRecognizer: UITapGestureRecognizer){
           print("purchase1")
           startPurchase(productIdentifier: productIdentifiers[0])
       }
       @objc func tapGesture2(gestureRecognizer: UITapGestureRecognizer){
           print("purchase2")
           startPurchase(productIdentifier: productIdentifiers[1])
       }
       @objc func tapGesture3(gestureRecognizer: UITapGestureRecognizer){
           print("purchase3")
           startPurchase(productIdentifier: productIdentifiers[2])
       }
}


//課金処理を追加
extension CallBilling:PurchaseManagerDelegate{
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
