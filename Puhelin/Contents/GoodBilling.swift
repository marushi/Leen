//
//  GoodBilling.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/05.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import StoreKit
import SCLAlertView
import GoogleMobileAds

class GoodBilling: UIViewController,GADRewardedAdDelegate {
    

    //いいねアンリミット
    @IBOutlet weak var titleLabel: UILabel!
    //お手軽プラン
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var standardView: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var standard2: UIView!
    @IBOutlet weak var standard3: UIView!
    @IBOutlet weak var mantanView: UIView!
    @IBOutlet weak var mantanPurchase: UIView!
    @IBOutlet weak var coverView1: UIView!
    @IBOutlet weak var coverView2: UIView!
    @IBOutlet weak var coverView3: UIView!
    @IBOutlet weak var goodnum: UILabel!
    @IBOutlet weak var goodRmain: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ticketNum: UILabel!
    @IBOutlet weak var restore: UIButton!
    
    //購入処理用
    let productIdentifiers : [String] = ["goodLimitRelease1","goodLimitRelease2","goodLimitRelease3"]
    let recovery = "goodRecoveryCard"
    let userDefaults = UserDefaults.standard
    let type = UserDefaults.standard.integer(forKey: "goodLimit")
    var rewardedAd: GADRewardedAd?
    var purchaseType:Int?
    var preViewMode:Int?
    var limit:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.clipsToBounds = false
        coverView1.layer.cornerRadius = 30
        coverView2.layer.cornerRadius = 30
        coverView3.layer.cornerRadius = 30
        restore.layer.cornerRadius = 20
        standardView.layer.cornerRadius = 30
        standard2.layer.cornerRadius = 30
        standard3.layer.cornerRadius = 30
        adView.layer.cornerRadius = 30
        mantanPurchase.layer.cornerRadius = 30
        adView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        adView.layer.shadowColor = UIColor.black.cgColor
        adView.layer.shadowOpacity = 0.6
        adView.layer.shadowRadius = 2
        mantanPurchase.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mantanPurchase.layer.shadowColor = UIColor.black.cgColor
        mantanPurchase.layer.shadowOpacity = 0.6
        mantanPurchase.layer.shadowRadius = 2
        view1.layer.cornerRadius = 75
        mantanView.layer.cornerRadius = 75
        view1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view1.layer.shadowColor = UIColor.black.cgColor
        view1.layer.shadowOpacity = 0.6
        view1.layer.shadowRadius = 2
        mantanView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mantanView.layer.shadowColor = UIColor.black.cgColor
        mantanView.layer.shadowOpacity = 0.6
        mantanView.layer.shadowRadius = 2
        upLabel.layer.cornerRadius = upLabel.frame.size.height / 2
        upLabel.clipsToBounds = true
        standardView.layer.shadowColor = UIColor.black.cgColor
        standard2.layer.shadowColor = UIColor.black.cgColor
        standard3.layer.shadowColor = UIColor.black.cgColor
        restore.isHidden = true
        // プロダクト情報取得
        fetchProductInformationForIds(productIdentifiers)
        
        // ジェスチャーの生成・追加
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture1(gestureRecognizer:)))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture2(gestureRecognizer:)))
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture3(gestureRecognizer:)))
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture4(gestureRecognizer:)))
        let adGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture5(gestureRecognizer:)))
        standardView.addGestureRecognizer(tapGestureRecognizer1)
        standard2.addGestureRecognizer(tapGestureRecognizer2)
        standard3.addGestureRecognizer(tapGestureRecognizer3)
        mantanPurchase.addGestureRecognizer(tapGestureRecognizer4)
        adView.addGestureRecognizer(adGesture)
        
        //広告読み込み
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAd?.load(GADRequest()) { error in
          if let error = error {
            print(error)
            // Handle ad failed to load case.
          } else {
            // Ad successfully loaded.
          }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let goodRemainNum = UserDefaults.standard.integer(forKey: UserDefaultsData.remainGoodNum)
        goodRmain.text = "現在：" + String(goodRemainNum) + "回"
        let num = userDefaults.integer(forKey: UserDefaultsData.ticketNum)
        ticketNum.text = "×" + String(num)
        //課金状態ごとの場合わけ
        let type = userDefaults.integer(forKey: "goodLimit")
        if type == 0 {
            standardView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            standardView.layer.shadowOpacity = 0.6
            standardView.layer.shadowRadius = 2
            standard2.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standard2.layer.shadowOpacity = 0
            standard2.layer.shadowRadius = 0
            standard3.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standard3.layer.shadowOpacity = 0
            standard3.layer.shadowRadius = 0
            coverView1.isHidden = true
            coverView2.isHidden = false
            coverView3.isHidden = false
            goodnum.text = "現在：5回/日"
            limit = 5
            
        }else if type == 1 {
            standardView.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standardView.layer.shadowOpacity = 0
            standardView.layer.shadowRadius = 0
            standard2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            standard2.layer.shadowOpacity = 0.6
            standard2.layer.shadowRadius = 2
            standard3.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standard3.layer.shadowOpacity = 0
            standard3.layer.shadowRadius = 0
            coverView1.isHidden = false
            coverView2.isHidden = true
            coverView3.isHidden = false
            goodnum.text = "現在：10回/日"
            limit = 10
        }else if type == 2 {
            standardView.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standardView.layer.shadowOpacity = 0
            standardView.layer.shadowRadius = 0
            standard2.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standard2.layer.shadowOpacity = 0
            standard2.layer.shadowRadius = 0
            standard3.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            standard3.layer.shadowOpacity = 0.6
            standard3.layer.shadowRadius = 2
            coverView1.isHidden = false
            coverView2.isHidden = false
            coverView3.isHidden = true
            goodnum.text = "現在：15回/日"
            limit = 15
        }else {
            standardView.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standardView.layer.shadowOpacity = 0
            standardView.layer.shadowRadius = 0
            standard2.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standard2.layer.shadowOpacity = 0
            standard2.layer.shadowRadius = 0
            standard3.layer.shadowOffset = CGSize(width: 0.0, height: 0)
            standard3.layer.shadowOpacity = 0
            standard3.layer.shadowRadius = 0
            coverView1.isHidden = false
            coverView2.isHidden = false
            coverView3.isHidden = false
            goodnum.text = "現在：20回/日"
            limit = 20
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.preViewMode == 1 {
            UIView.animate(withDuration: 0.6, animations: {
                self.scrollView.contentOffset.y = 450
            })
        }
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // ジェスチャーイベント処理
    @objc func tapGesture1(gestureRecognizer: UITapGestureRecognizer){
        print("purchase1")
        purchaseType = 1
        if type == 0 {
            HUD.show(.progress)
        startPurchase(productIdentifier: productIdentifiers[0])
        }
    }
    @objc func tapGesture2(gestureRecognizer: UITapGestureRecognizer){
        print("purchase2")
        purchaseType = 2
        if type == 1 {
            HUD.show(.progress)
        startPurchase(productIdentifier: productIdentifiers[1])
        }
    }
    @objc func tapGesture3(gestureRecognizer: UITapGestureRecognizer){
        print("purchase3")
        purchaseType = 3
        if type == 2 {
            HUD.show(.progress)
        startPurchase(productIdentifier: productIdentifiers[2])
        }
    }
    @objc func tapGesture4(gestureRecognizer: UITapGestureRecognizer){
        print("purchase4")
        purchaseType = 4
        HUD.show(.progress)
        startPurchase(productIdentifier: recovery)
    }
    @objc func tapGesture5(gestureRecognizer: UITapGestureRecognizer){
        let num = userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
        if num >= limit! {
            SCLAlertView().showSuccess("いいね数が満タンです", subTitle: "これ以上回復するには上限を増やしてください。")
        }else{
            if rewardedAd?.isReady == true {
               rewardedAd?.present(fromRootViewController: self, delegate:self)
            }
        }
        
    }
    
    @IBAction func restoreButton(_ sender: Any) {
        HUD.show(.progress)
        startRestore()
    }
    
    
    //広告の報酬処理
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        var limitnum:Int!
        let goodRemainNum:Int = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
        if type == 0 {
            limitnum = 5
        }
        if type == 1 {
            limitnum = 10
        }
        if type == 2 {
            limitnum = 15
        }
        if type == 3 {
            limitnum = 20
        }
        
        //処理
        //限界値以下の時
        if goodRemainNum < limitnum {
            let num = goodRemainNum + 1
            self.userDefaults.set(num, forKey: UserDefaultsData.remainGoodNum)
        }
        self.viewWillAppear(true)
        
        
    }

}

//課金処理を追加
extension GoodBilling:PurchaseManagerDelegate{
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
        //------------課金処理---------------
        let type = self.purchaseType
        //回復券処理
        if type == 4 {
            let num = self.userDefaults.integer(forKey: UserDefaultsData.ticketNum)
            let num2 = num + 1
            self.userDefaults.set(num2, forKey: UserDefaultsData.ticketNum)
            //DBの保存
            let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!)
            ref.setData([UserDefaultsData.ticketNum:num2], merge: true)
        }else{
        //上限解放
        self.userDefaults.set(type, forKey: UserDefaultsData.goodLimit)
        //回復券
        let num = self.userDefaults.integer(forKey: UserDefaultsData.ticketNum)
        let num2 = num + 1
        self.userDefaults.set(num2, forKey: UserDefaultsData.ticketNum)
        //DBの保存
        let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!)
        ref.setData([UserDefaultsData.goodLimit:type as Any,UserDefaultsData.ticketNum:num2], merge: true)
        }
        
        HUD.hide()
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
        HUD.hide()
        decisionHandler(true)
    }

    //課金失敗時に呼び出される
    func purchaseManager(_ purchaseManager: PurchaseManager!, didFailWithError error: NSError!) {
        print("課金失敗！！")
        // TODO errorを使ってアラート表示
        SCLAlertView().showError("課金エラー", subTitle: "お手数ですがもう一度お試しください。")
        HUD.hide()
    }

    // リストア終了時に呼び出される(個々のトランザクションは”課金終了”で処理)
    func purchaseManagerDidFinishRestore(_ purchaseManager: PurchaseManager!) {
        print("リストア終了！！")
        // TODO インジケータなどを表示していたら非表示に
        HUD.hide()
        SCLAlertView().showSuccess("購入内容の復元が完了しました。", subTitle: "")
    }

    // 承認待ち状態時に呼び出される(ファミリー共有)
    func purchaseManagerDidDeferred(_ purchaseManager: PurchaseManager!) {
        print("承認待ち！！")
        // TODO インジケータなどを表示していたら非表示に
        HUD.hide()

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
