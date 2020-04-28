//
//  GoodPointPurchase.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/22.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SCLAlertView
import GoogleMobileAds

class GoodPointPurchase: UIViewController, GADRewardedAdDelegate{
    
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var PointView: UIView!
    @IBOutlet weak var PuhelinPointView: UIView!
    @IBOutlet weak var PointNum: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var remainLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 3
    var cellHight:Int?
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        contentView.layer.cornerRadius = 20
        titleLabel.layer.cornerRadius = 20
        titleLabel.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        titleLabel2.layer.cornerRadius = titleLabel2.frame.size.height / 2
        titleLabel2.clipsToBounds = true
        titleLabel.clipsToBounds = true
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        PointView.layer.cornerRadius = PointView.frame.size.height / 2
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "goodPointPurchaseCell", bundle: nil), forCellWithReuseIdentifier: "goodPointPurchaseCell")
        
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
        let num = self.userDefaults.integer(forKey: UserDefaultsData.ticketNum)
        self.PointNum.text = String(num)
        let num2 = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
        remainLabel.text = String(num2)
        let type = self.userDefaults.integer(forKey: UserDefaultsData.goodLimit)
        if type == 0 {
            self.limitLabel.text = "上限：5回/日"
        }
        if type == 1 {
            self.limitLabel.text = "上限：10回/日"
        }
        if type == 2 {
            self.limitLabel.text = "上限：15回/日"
        }
        if type == 3 {
            self.limitLabel.text = "上限：20回/日"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    @IBAction func pointPurchase(_ sender: Any) {
        let GoodBilling = self.storyboard?.instantiateViewController(identifier: "GoodBilling") as! GoodBilling
        GoodBilling.preViewMode = 1
        self.present(GoodBilling,animated: true,completion: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
        let location = touch.location(in: self.view) //in: には対象となるビューを入れます
        let ynum = self.view.frame.size.height - 270
        if location.y < ynum {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //広告みた後の処理
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        let num = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
        self.userDefaults.set(num + 1, forKey: UserDefaultsData.remainGoodNum)
        self.viewWillAppear(true)
    }
}

extension GoodPointPurchase:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goodPointPurchaseCell", for: indexPath) as! goodPointPurchaseCell
        cell.setData(indexPath.row)
        return cell
    }
    
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.collectionView.frame.size.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: self.collectionView.frame.size.height)
    }
        
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let num = indexPath.row
        //満タンに回復する
        if num == 0 {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("回復する") {
                let num = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
                let num2 = self.userDefaults.integer(forKey: UserDefaultsData.goodLimit)
                let num3 = self.userDefaults.integer(forKey: UserDefaultsData.ticketNum)
                var limit:Int?
                if num2 == 0 {
                    limit = 5
                }
                if num2 == 1 {
                    limit = 10
                }
                if num2 == 2 {
                    limit = 15
                }
                if num2 == 3 {
                    limit = 20
                }
                
                //処理
                if num3 <= 0 {
                    SCLAlertView().showSuccess("回復券がありません。", subTitle: "回復券を購入してください。")
                    return
                }else{
                    if num >= limit! {
                        SCLAlertView().showSuccess("いいね数が満タンです。", subTitle: "使い切ってから回復してください。")
                        return
                    }else{
                        self.userDefaults.set(limit, forKey: UserDefaultsData.remainGoodNum)
                        self.userDefaults.set(num3 - 1, forKey: UserDefaultsData.ticketNum)
                        self.viewWillAppear(true)
                        return
                    }
                }
            }
            alertView.addButton("キャンセル",backgroundColor: .lightGray,textColor: .black) {
                return
            }
            alertView.showSuccess("いいね数を満タンにします。", subTitle: "回復券を1枚消費して回復してもよろしいですか？")
        }
        //広告を見て１回復
        if num == 1 {
            let num = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
            let num2 = self.userDefaults.integer(forKey: UserDefaultsData.goodLimit)
            var limit:Int?
            if num2 == 0 {
                limit = 5
            }
            if num2 == 1 {
                limit = 10
            }
            if num2 == 2 {
                limit = 15
            }
            if num2 == 3 {
                limit = 20
            }
            if num >= limit! {
                SCLAlertView().showSuccess("いいね数が満タンです", subTitle: "これ以上回復するには上限を増やしてください。")
            }else{
                if rewardedAd?.isReady == true {
                   rewardedAd?.present(fromRootViewController: self, delegate:self)
                }
            }
        }
        //上限を増やすページへ
        if num == 2 {
            let GoodBilling = self.storyboard?.instantiateViewController(identifier: "GoodBilling") as! GoodBilling
            self.present(GoodBilling,animated: true,completion: nil)
        }
    }
}
