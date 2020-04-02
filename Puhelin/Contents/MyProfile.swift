//
//  MyProfile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import FirebaseUI

class MyProfile: UIViewController {
    //部品
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView1: UICollectionView!
    
    //変数
    var DB = ""
    var ProfileData:MyProfileData?
    var infoData:[InformationData]?
    var identListener :ListenerRegistration!
    var infoListener: ListenerRegistration!
    
    //定数
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
    let sectionInsets1 = UIEdgeInsets(top: 0, left: 10, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //自分の性別のデータベースを設定
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }

        //テーブルビューの設定
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView1.delegate = self
        collectionView1.dataSource = self
        addView.layer.cornerRadius = 10
        addView.layer.borderWidth = 1
        addView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.6
        headerView.layer.shadowRadius = 1
        //セルの登録
        collectionView.register(UINib(nibName: "MypageHeader", bundle: nil), forCellWithReuseIdentifier: "MypageHeader")
        //画像を丸くする
        photo.layer.cornerRadius = photo.frame.size.width * 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(UserDefaults.standard.string(forKey: "photoId")!)
        photo.sd_setImage(with: imageRef)
        nameLabel.text = self.userDefaults.string(forKey: UserDefaultsData.name)
        self.collectionView.reloadData()
        
        //本人確認の完了待機
        if userDefaults.integer(forKey: "identification") == 1 {
            if identListener == nil {
                let Ref = Firestore.firestore().collection(DB).document(userDefaults.string(forKey: "uid")!)
                identListener = Ref.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    let identBool:Bool? = querySnapshot?.get("identification") as? Bool
                    if identBool == true {
                        self.userDefaults.set(2, forKey: "identification")
                        self.identListener.remove()
                    }
                }
            }
        }
        
        //お知らせの新着情報待機
        if infoListener == nil {
            let infoRef = Firestore.firestore().collection(DB).document(userDefaults.string(forKey: "uid")!).collection(Const.InformationPath)
            infoListener = infoRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                self.infoData = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let infodata = InformationData(document: document)
                    return infodata
                }
            }
        }
        
    }
        
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //プロフィールを表示
    @IBAction func myprofile(_ sender: Any) {
        let profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        profile.profileSetData()
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    //広告画面へ
    @IBAction func promotion(_ sender: Any) {
        let bil = self.storyboard?.instantiateViewController(identifier: "Billing") as! Billing
        present(bil,animated: true,completion: nil)
    }
    
}

extension MyProfile:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 {
            return 1
        }else{
            return 1
        }
    }
        
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return 3
        }else{
            return 3
        }
    }
        
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let MypageHeader = collectionView.dequeueReusableCell(withReuseIdentifier: "MypageHeader", for: indexPath) as! MypageHeader
            MypageHeader.setData(indexPath.row)
            return MypageHeader
        }else{
            let MyProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfileCell", for: indexPath) as! MyProfileCell
            MyProfileCell.setData(indexPath.row)
            MyProfileCell.layer.borderWidth = 1
            MyProfileCell.layer.borderColor = UIColor.lightGray.cgColor
            MyProfileCell.layer.cornerRadius = 20
            MyProfileCell.backgroundColor = .white
            return MyProfileCell
        }
    }
    
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width  - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: self.collectionView.frame.height)
        }else{
            let paddingSpace = sectionInsets1.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width  - paddingSpace - 20
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 100 )
        }
    }
        
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
        switch indexPath.row {
        case 0:
            let goodpurchase = self.storyboard?.instantiateViewController(identifier: "GoodPointPurchase") as! GoodPointPurchase
            goodpurchase.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            present(goodpurchase,animated: true,completion: nil)
        case 1:
            let UserStatus = self.storyboard?.instantiateViewController(identifier: "UserStatus") as! UserStatus
            self.navigationController?.pushViewController(UserStatus, animated: true)
        case 2:
            let Purchase = self.storyboard?.instantiateViewController(identifier: "Purchase")
            let nav = UINavigationController.init(rootViewController: Purchase!)
            present(nav,animated: true,completion: nil)
        default:
            return
        }
        }else{
            switch indexPath.row {
            case 0:
                let ident = self.storyboard?.instantiateViewController(identifier: "Identification") as! Identification
                self.navigationController?.pushViewController(ident,animated: true)
            case 2:
                let Information = self.storyboard?.instantiateViewController(identifier: "Information") as! Information
                Information.infoData = infoData
                self.navigationController?.pushViewController(Information,animated: true)
            default:
                return
            }
        }
    }
    
}
