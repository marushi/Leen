//
//  GoodPointPurchase.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/22.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SCLAlertView

class GoodPointPurchase: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var PointView: UIView!
    @IBOutlet weak var PuhelinPointView: UIView!
    @IBOutlet weak var PointNum: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        scrollView.showsHorizontalScrollIndicator = false
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        PointView.layer.cornerRadius = PointView.frame.size.height / 2
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "goodPointPurchaseCell", bundle: nil), forCellWithReuseIdentifier: "goodPointPurchaseCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        PointNum.text = "\(userDefaults.integer(forKey: UserDefaultsData.PuhelinPoint))"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        print("viewwilldisappear")
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    @IBAction func pointPurchase(_ sender: Any) {
        let purchase = self.storyboard?.instantiateViewController(identifier: "Purchase")
        self.present(purchase!,animated: true,completion: nil)
        self.dismiss(animated: false, completion: nil)
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

extension GoodPointPurchase:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goodPointPurchaseCell", for: indexPath) as! goodPointPurchaseCell
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = ColorData.whitesmoke.cgColor
        cell.layer.borderWidth = 3
        cell.setData(indexPath.row)
        return cell
    }
    
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.collectionView.frame.size.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
        
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var purchaseAmount:Int!
        switch indexPath.row {
        case 0:
            purchaseAmount = 5
        case 1:
            purchaseAmount = 10
        case 2:
            purchaseAmount = 30
        case 3:
            purchaseAmount = 50
        case 4:
            purchaseAmount = 100
        default:
            purchaseAmount = 0
        }
        //アラート
        let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("購入する") {
                //探す画面に戻る
                var puhelinpoint:Int = self.userDefaults.integer(forKey: UserDefaultsData.PuhelinPoint)
                var goodpoint:Int = self.userDefaults.integer(forKey: UserDefaultsData.GoodPoint)
                if puhelinpoint < purchaseAmount {
                    SCLAlertView().showSuccess("ポイントが足りません。", subTitle: "")
                    return
                }else{
                    puhelinpoint -= purchaseAmount
                    goodpoint += purchaseAmount
                    self.userDefaults.set(puhelinpoint, forKey: UserDefaultsData.PuhelinPoint)
                    self.userDefaults.set(goodpoint, forKey: UserDefaultsData.GoodPoint)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertView.addButton("戻る",backgroundColor: .lightGray,textColor: .black) {
                return
            }
            alertView.showSuccess("\(purchaseAmount!)ポイントでいいねを購入します。よろしいですか？", subTitle: "")
    }
}
