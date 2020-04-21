//
//  MyProfile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MyProfile: UIViewController {
    //部品
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var menuTitle: UILabel!
    
    //変数
    var DB = ""
    var ProfileData:MyProfileData?
    var infoData:[InformationData]?
    var identListener :ListenerRegistration!
    var infoListener: ListenerRegistration!
    var dataListener: ListenerRegistration!
    
    //定数
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
    let sectionInsets1 = UIEdgeInsets(top: 0, left: 15, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
        scrollView.delegate = self
        //addView.layer.cornerRadius = 10
        //addView.layer.borderWidth = 1
        //addView.layer.borderColor = UIColor.lightGray.cgColor
        menuTitle.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        menuTitle.layer.shadowColor = UIColor.black.cgColor
        menuTitle.layer.shadowOpacity = 0.6
        menuTitle.layer.shadowRadius = 2
        menuView.backgroundColor = ColorData.whitesmoke
        //セルの登録
        collectionView.register(UINib(nibName: "goodpointCell", bundle: nil), forCellWithReuseIdentifier: "goodpointCell")
        collectionView.register(UINib(nibName: "videoCell", bundle: nil), forCellWithReuseIdentifier: "videoCell")
        collectionView.register(UINib(nibName: "ExCell", bundle: nil), forCellWithReuseIdentifier: "ExCell")
        
        //画像を丸くする
        photo.layer.cornerRadius = photo.frame.size.width * 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // 画像の表示
        if dataListener == nil{
            let ref = Firestore.firestore().collection(DB).document(userDefaults.string(forKey: "uid")!)
                dataListener = ref.addSnapshotListener(){ (querysnapshot , error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                    if querysnapshot?.get("photoId") != nil {
                        self.photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(querysnapshot?.get("photoId") as! String)
                        self.photo.sd_setImage(with: imageRef)
                    }
                
                    self.nameLabel.text = querysnapshot?.get("name") as? String
                    self.ageLabel.text = String(querysnapshot?.get("age") as! Int) + "歳"
                    self.regionLabel.text = querysnapshot?.get("region") as? String
                    
            }
        }
        
        
        
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
                    self.collectionView.reloadData()
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
    
    //スクロールで隠す
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    //プロフィールを表示
    @IBAction func myprofile(_ sender: Any) {
        let profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        profile.ButtonMode = 3
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
            return 6
        }
    }
        
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            switch indexPath.row {
            case 0:
                let goodpointCell = collectionView.dequeueReusableCell(withReuseIdentifier: "goodpointCell", for: indexPath) as! goodpointCell
                goodpointCell.addBorder(width: 2, color: ColorData.whitesmoke, position: .right)
                return goodpointCell
            case 1:
                let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! videoCell
                videoCell.addBorder(width: 2, color: ColorData.whitesmoke, position: .right)
                return videoCell
            case 2:
                let ExCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExCell", for: indexPath) as! ExCell
                return ExCell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                return cell
            }
            
        }else{
            let MyProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfileCell", for: indexPath) as! MyProfileCell
            MyProfileCell.setData(indexPath.row)
            MyProfileCell.layer.cornerRadius = 20
            MyProfileCell.batch.isHidden = true
            MyProfileCell.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            MyProfileCell.layer.shadowColor = UIColor.darkGray.cgColor
            MyProfileCell.layer.shadowOpacity = 0.6
            MyProfileCell.layer.shadowRadius = 1
            return MyProfileCell
        }
    }
    
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width  - paddingSpace - 60
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: self.collectionView.frame.height)
        }else{
            let paddingSpace = sectionInsets1.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width  - paddingSpace - 60
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: widthPerItem + 20 )
        }
    }
    
    //セルの行間
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
        
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
        switch indexPath.row {
        case 0:
            let GoodBilling = self.storyboard?.instantiateViewController(identifier: "GoodBilling") as! GoodBilling
            self.navigationController?.pushViewController(GoodBilling, animated: true)
        case 1:
            let CallBilling = self.storyboard?.instantiateViewController(identifier: "CallBilling") as! CallBilling
            self.navigationController?.pushViewController(CallBilling, animated: true)
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
            case 3:
                let goodhis = self.storyboard?.instantiateViewController(identifier: "Goodhistory") as! Goodhistory
                self.navigationController?.pushViewController(goodhis, animated: true)
            case 4:
                let footprint = self.storyboard?.instantiateViewController(identifier: "Footprint") as! Footprint
                self.navigationController?.pushViewController(footprint, animated: true)
            case 5:
                let setting = self.storyboard?.instantiateViewController(identifier: "Settings") as! Settings
                self.navigationController?.pushViewController(setting, animated: true)
            default:
                return
            }
        }
    }
    
}
