//
//  Search.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase

class Search: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var conditionButton: UIButton!
    
    //変数設定
    var UserArray: [UserData] = []
    var DB = ""
    var searchCondition:Bool!
    var searchQuery:searchQueryData?
    
    //レイアウト設定
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //コレクションビューの設定
        collectionView.delegate = self
        collectionView.dataSource = self
        //ボタンの設定
        conditionButton.backgroundColor = ColorData.whitesmoke
        conditionButton.layer.cornerRadius = 15
        searchCondition = false
        
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        //異性の相手をビューに表示
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.FemalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.MalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        }
        searchQuery = searchQueryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        if searchCondition == false {
            self.setUp()
        }else{
            self.collectionView.reloadData()
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

    //ユーザーを画面に表示する
    func setUp(){
        
        //インジゲーター
        HUD.show(.progress)
        let Ref = Firestore.firestore().collection(DB)
        Ref.getDocuments() { (querySnapshot, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.UserArray = querySnapshot!.documents.map { document in               print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = UserData(document: document)
                return userData
            }
            // TableViewの表示を更新する
            self.collectionView.reloadData()
            //PKHUD
            HUD.hide()
        }
    }
    
    @IBAction func searchCon(_ sender: Any) {
        let searchCon = self.storyboard?.instantiateViewController(identifier: "SearchConditions") as! SearchCoditions
        searchCon.searchQuery = self.searchQuery
        let nav = UINavigationController.init(rootViewController: searchCon)
        self.present(nav,animated: true,completion: nil)
    }
    
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return UserArray.count
        
    }
    
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let SearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        SearchCell.setData(UserArray[indexPath.row])
        SearchCell.layer.cornerRadius = SearchCell.frame.size.width * 0.1
        return SearchCell
    }
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
                let availableWidth = view.frame.width  - paddingSpace
                let widthPerItem = availableWidth / itemsPerRow
                return CGSize(width: widthPerItem, height: 270)
    }
    
    // セルの行間の設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.setData(UserArray[indexPath.row].uid)
        Profile.ButtonMode = 1
        Profile.modalTransitionStyle = .crossDissolve
        present(Profile,animated: true,completion: nil)
    }
}

extension Search:searchConResultDelegate{
    func searchConResultFunction(_ userData: [UserData]) {
        self.UserArray = userData
        self.searchCondition = true
        self.collectionView.reloadData()
    }
}
