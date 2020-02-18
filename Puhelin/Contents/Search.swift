//
//  Search.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class Search: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var UserArray: [UserData] = []
    var listener: ListenerRegistration!
    var DB = ""
    //レイアウト設定
    let sectionInsets = UIEdgeInsets(top: 10, left: 1, bottom: 10 , right: 0)
    let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //コレクションビューの設定
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        
        self.view.backgroundColor = .brown
        
        UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "uid")
        
        
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.FemalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.MalePath
            UserDefaults.standard.set(DB, forKey: "DB")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
        let Ref = Firestore.firestore().collection(DB)
        listener = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.UserArray = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = UserData(document: document)
                return userData
            }
            // TableViewの表示を更新する
            self.collectionView.reloadData()
            
            }
        }
    }

    //検索条件ボタン押した時
    @IBAction func SearchConditionButton(_ sender: Any) {
        
        //検索条件画面へ遷移
        let SearchConditions = self.storyboard?.instantiateViewController(identifier: "SearchConditions")
        present(SearchConditions!,animated: true,completion: nil)
    }
    
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return UserArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Section", for: indexPath)

        headerView.backgroundColor = UIColor.white

        return headerView
    }
    
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let SearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let TopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath)
        
        
        switch (indexPath.section) {
        case 0:
            TopCell.isUserInteractionEnabled = false
            return TopCell
        case 1:
            SearchCell.backgroundColor = .lightGray
            SearchCell.setData(UserArray[indexPath.row])
            return SearchCell
        default:
            return TopCell
        }
    }
    
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch (indexPath.section) {
        case 0:
            return CGSize(width: view.frame.width, height: 50)
        case 1:
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
                   let availableWidth = view.frame.width - paddingSpace
                   let widthPerItem = availableWidth / itemsPerRow
                   return CGSize(width: widthPerItem, height: 280)
        default:
            return CGSize(width: view.frame.width, height: 50)
        }
       
    }
    
    // セルの行間の設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 60
    }
    
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.userInfo = UserArray[indexPath.row]
        present(Profile,animated: true,completion: nil)
    }
}
