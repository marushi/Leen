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

class MyProfile: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //部品
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
    //変数
    var DB = ""
    var ProfileData:MyProfileData?
    
    //定数
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 3
    var identListener :ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //異性の相手をビューに表示
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }

        //テーブルビューの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.addBorder(width: 1, color: .lightGray, position: .bottom)
        tableView.addBorder(width: 1, color: .lightGray, position: .top)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addBorder(width: 1, color: .lightGray, position: .bottom)
        //checkLabel.layer.cornerRadius = checkLabel.frame.height / 2
        //checkLabel.layer.borderColor = UIColor.white.cgColor
        //checkLabel.layer.borderWidth = 3
        //セルの登録
        let nib_1 = UINib(nibName: "MyProfileCell", bundle: nil)
        tableView.register(nib_1, forCellReuseIdentifier: "MyProfileCell")
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
    }
        
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell", for: indexPath) as! MyProfileCell
        cell.selectionStyle = .none
        cell.setData(indexPath.row)
        return cell
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let Identification = self.storyboard?.instantiateViewController(identifier: "Identification") as! Identification
            self.navigationController?.pushViewController(Identification, animated: true)
        case 1:
            let Usage = self.storyboard?.instantiateViewController(identifier: "Usage") as! Usage
            self.present(Usage,animated: true,completion: nil)
        case 2:
            let Information = self.storyboard?.instantiateViewController(identifier: "Information") as! Information
            self.navigationController?.pushViewController(Information, animated: true)
        default:
            return
        }
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
        return 1
    }
        
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
    }
        
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let MypageHeader = collectionView.dequeueReusableCell(withReuseIdentifier: "MypageHeader", for: indexPath) as! MypageHeader
        MypageHeader.setData(indexPath.row)
        return MypageHeader
    }
    
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width  - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: self.collectionView.frame.height)
    }
        
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let goodpurchase = self.storyboard?.instantiateViewController(identifier: "GoodPointPurchase") as! GoodPointPurchase
            goodpurchase.modalTransitionStyle = .crossDissolve
            self.tabBarController?.tabBar.isHidden = true
            present(goodpurchase,animated: true,completion: nil)
        case 2:
            let Purchase = self.storyboard?.instantiateViewController(identifier: "Purchase")
            let nav = UINavigationController.init(rootViewController: Purchase!)
            present(nav,animated: true,completion: nil)
        default:
            return
        }
    }
    
}
