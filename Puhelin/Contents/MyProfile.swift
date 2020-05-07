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
    @IBOutlet weak var backView: UIView!
    
    //変数
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
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]

        //テーブルビューの設定
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView1.delegate = self
        collectionView1.dataSource = self
        scrollView.delegate = self
        menuTitle.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        menuTitle.layer.shadowColor = UIColor.black.cgColor
        menuTitle.layer.shadowOpacity = 0.6
        menuTitle.layer.shadowRadius = 2
        backView.isHidden = true
        //セルの登録
        collectionView.register(UINib(nibName: "goodpointCell", bundle: nil), forCellWithReuseIdentifier: "goodpointCell")
        collectionView.register(UINib(nibName: "videoCell", bundle: nil), forCellWithReuseIdentifier: "videoCell")
        collectionView.register(UINib(nibName: "ExCell", bundle: nil), forCellWithReuseIdentifier: "ExCell")
        
        //画像を丸くする
        photo.layer.cornerRadius = photo.frame.size.width * 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.collectionView.reloadData()
        backView.isHidden = true
        setMyData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //本人確認の完了待機
        if userDefaults.integer(forKey: "identification") == 1 {
            self.collectionView1.reloadData()
            if identListener == nil {
                let Ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!)
                identListener = Ref.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    
                    if let ident:Int = querySnapshot?.get("identification") as? Int{
                        if ident != 0 && ident != 1 {
                            self.userDefaults.set(ident, forKey: "identification")
                            self.collectionView1.reloadData()
                            self.identListener.remove()
                            self.identListener = nil
                        }
                    }
                }
            }
        }
    }
    
    func setMyData(){
        ProfileData = fromAppDelegate.myProfileData
        let photoId = ProfileData?.photoId
        if photoId != "" && photoId != nil{
            self.photo.contentMode = .scaleAspectFill
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(photoId!)
            self.photo.sd_setImage(with: imageRef)
        }else{
            self.photo.contentMode = .scaleAspectFit
            if self.userDefaults.integer(forKey: "gender") == 1 {
                self.photo.image = UIImage(named: "male")
            }else{
                self.photo.image = UIImage(named: "female")
            }
        }
        self.nameLabel.text = ProfileData?.name
        if let age = ProfileData?.age {
            self.ageLabel.text = String(age) + "歳"
        }
        self.regionLabel.text = ProfileData?.region
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
        profile.profileData = ProfileData
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
            return 4
        }
    }
        
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            switch indexPath.row {
            case 0:
                let goodpointCell = collectionView.dequeueReusableCell(withReuseIdentifier: "goodpointCell", for: indexPath) as! goodpointCell
                goodpointCell.addBorder(width: 2, color: ColorData.whitesmoke, position: .right)
                goodpointCell.setdata()
                return goodpointCell
            case 1:
                let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! videoCell
                videoCell.addBorder(width: 2, color: ColorData.whitesmoke, position: .right)
                videoCell.setData()
                return videoCell
            case 2:
                let ExCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExCell", for: indexPath) as! ExCell
                ExCell.setData()
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
            let MatchingTicket = self.storyboard?.instantiateViewController(identifier: "MatchingTicket") as! MatchingTicket
            backView.isHidden = false
            backView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.backView.alpha = 1
            })
            self.tabBarController?.tabBar.isHidden = true
            present(MatchingTicket,animated: true,completion: nil)
        case 2:
            let GoodPointPurchase = self.storyboard?.instantiateViewController(identifier: "GoodPointPurchase") as! GoodPointPurchase
            backView.isHidden = false
            backView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.backView.alpha = 1
            })
            self.tabBarController?.tabBar.isHidden = true
            present(GoodPointPurchase,animated: true,completion: nil)
        default:
            return
        }
        }else{
            switch indexPath.row {
            case 0:
                let num = self.userDefaults.integer(forKey: "identification")
                if num == 1 || num == 2 {
                    return
                }
                let ident = self.storyboard?.instantiateViewController(identifier: "Identification") as! Identification
                let navigationController = UINavigationController(rootViewController: ident)
                self.present(navigationController,animated: true,completion: nil)
            /*case 1:
                let Information = self.storyboard?.instantiateViewController(identifier: "Information") as! Information
                Information.infoData = infoData
                self.navigationController?.pushViewController(Information,animated: true)*/
            case 1:
                let goodhis = self.storyboard?.instantiateViewController(identifier: "Goodhistory") as! Goodhistory
                self.navigationController?.pushViewController(goodhis, animated: true)
            case 2:
                let footprint = self.storyboard?.instantiateViewController(identifier: "Footprint") as! Footprint
                self.navigationController?.pushViewController(footprint, animated: true)
            case 3:
                let setting = self.storyboard?.instantiateViewController(identifier: "Settings") as! Settings
                self.navigationController?.pushViewController(setting, animated: true)
            default:
                return
            }
        }
    }
    
}
