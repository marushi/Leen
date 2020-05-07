//
//  MatchingTicket.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/27.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import StoreKit
import SCLAlertView

class MatchingTicket: UIViewController {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var remainTicketView: UIView!
    //@IBOutlet weak var toLPButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 3
    let productIdentifiers : [String] = ["matchingTicket","matchingTicket3","matchingTicket5"]
    
    var num:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        titleLabel.layer.cornerRadius = 20
        titleLabel.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        titleLabel.clipsToBounds = true
        backView.layer.cornerRadius = 20
        backView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        remainTicketView.layer.cornerRadius = remainTicketView.frame.size.height / 2
        //toLPButton.layer.cornerRadius = toLPButton.frame.size.height / 2
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "matchingTicketCell", bundle: nil), forCellWithReuseIdentifier: "matchingTicketCell")
        // プロダクト情報取得
        fetchProductInformationForIds(productIdentifiers)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let num = userDefaults.integer(forKey: UserDefaultsData.matchingNum)
        numLabel.text = String(num)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
        let location = touch.location(in: self.view) //in: には対象となるビューを入れます
        let ynum = self.view.frame.size.height - 300
        if location.y < ynum {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension MatchingTicket:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchingTicketCell", for: indexPath) as! matchingTicketCell
        cell.setData(indexPath.row)
        cell.layer.borderColor = ColorData.salmon.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 20
        return cell
    }

    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.collectionView.frame.size.width - paddingSpace - 60
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: self.collectionView.frame.size.height)
    }
    
    //セルを選択する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HUD.show(.progress)
        num = indexPath.row
        startPurchase(productIdentifier: productIdentifiers[num!])
        
    }
}

//課金処理を追加
extension MatchingTicket:PurchaseManagerDelegate{
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
        let remainNum = self.userDefaults.integer(forKey: UserDefaultsData.matchingNum)
        var plusNum:Int?
        if self.num == 0{
            plusNum = 1
        }
        if self.num == 1{
            plusNum = 3
        }
        if self.num == 2{
            plusNum = 5
        }
        let registNum = remainNum + plusNum!
        self.userDefaults.set(registNum, forKey: UserDefaultsData.matchingNum)
        let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!)
        ref.setData([UserDefaultsData.matchingNum:registNum], merge: true)
        
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
        HUD.hide()
        SCLAlertView().showError("課金エラー", subTitle: "お手数ですがもう一度お試しください。")
    }

    // リストア終了時に呼び出される(個々のトランザクションは”課金終了”で処理)
    func purchaseManagerDidFinishRestore(_ purchaseManager: PurchaseManager!) {
        print("リストア終了！！")
        // TODO インジケータなどを表示していたら非表示に
        HUD.hide()
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
