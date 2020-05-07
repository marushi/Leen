//
//  Search.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//
import UIKit
import Firebase
import AudioToolbox
import SCLAlertView
import SkeletonView

class Search: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //条件有り
    @IBOutlet weak var collectionView: UICollectionView!
    
    //条件有り、0の時
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var zeroView: UIView!
    
    //変数設定
    var UserArray: [UserData] = []  // 検索したドキュメントのmapデータ
    var UserIdArray: [String] = []  //検索したデータのUidだけの文字列
    var searchUidData:[String] = [] //新しい人が入ってる検索用データ
    var setUserDataArray:[MyProfileData] = []
    var searchCondition:Bool!
    var searchQuery:searchQueryData?
    var refreshControl = UIRefreshControl()
    var didBecomeActiveBool:Bool?
    var orderType:Int?
    var last:DocumentSnapshot? = nil
    var setUp2Bool:Bool? = false
    var limitNum:Int?
    var searchRef:Query?
    var reloadBool:Bool? = false
    //レイアウト設定
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 2
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //部品の設定
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = ColorData.snow
        searchCondition = false
        
        //0の時
        zeroView.isHidden = true
        zeroView.backgroundColor = ColorData.snow
        button0.layer.cornerRadius = button0.frame.size.height / 2
        button0.layer.borderColor = UIColor.darkGray.cgColor
        button0.layer.borderWidth = 3
        
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        collectionView.register(UINib(nibName: "SearchConCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchConCollectionViewCell")
        limitNum = 30
        //検索条件オブジェクト
        searchQuery = searchQueryData()
        //下にスワイプした時に更新処理
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControl
        //検索条件の受信
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchConditionTrue), name: .notifyName, object: nil)

    }
    
    //したにスワイプした時の更新処理
    @objc func refreshTable() {
        AudioServicesPlaySystemSound(1520)
         // 更新処理
        if searchCondition == true {
            self.searchConditionTrue()
        }
     }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        //配列準備
        let allDataArray = arrayPrepare()
        let dataArray = self.hikaku(allData: allDataArray, searchData: self.searchUidData)
        if dataArray != searchUidData {
            self.searchUidData = dataArray
            self.collectionView.alpha = 0
            self.collectionView.reloadData()
            UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
                    self.collectionView.alpha = 1
                })
            }, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        zeroViewAppear()
    }
    
    //スクロールで追加読み込み
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        if distanceToBottom < 100 && self.setUp2Bool == false{
            //次の人を取得する
            self.setUp2Bool = true
            if self.searchCondition == true {
                self.searchConditionTrue2()
            }
        }
    }

    //表示の変更
    func zeroViewAppear(){
        //ユーザー有り
        if self.setUserDataArray != [] {
            self.collectionView.isHidden = false
            zeroView.isHidden = true
        }else{
            //0の時
            self.collectionView.isHidden = true
            zeroView.isHidden = false
            zeroView.alpha = 0
            UIView.animate(withDuration: 1, animations: {
                    self.zeroView.alpha = 1
            })
        }
    }
    
    //アクション済みユーザの配列
    func arrayPrepare() -> [String]{
        //配列準備
        let selectData = fromAppDelegate.selectIdArray
        let downData = fromAppDelegate.downIdArray
        let goodData = fromAppDelegate.goodIdArray
        let receiveData = fromAppDelegate.receiveIdArray
        let allDataArray = selectData + downData + goodData + receiveData
        return allDataArray
    }
    
    //初期化
    func Initialization() {
        //初期化処理
        UserArray = []
        UserIdArray = []
        searchUidData = []
    }
    
    //----------配列の並び替え用---------
    typealias SortDescriptor<Value> = (Value, Value) -> Bool
    func combine<Value>(sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {

        return { lhs, rhs in
            for isOrderedBefore in sortDescriptors {
                if isOrderedBefore(lhs,rhs) { return true }
                if isOrderedBefore(rhs,lhs) { return false }
            }
            return false
        }
    }
    //--------------------------------
    //サーチデータと既存のデータを比較
    func hikaku(allData:[String],searchData:[String]) -> [String]{
        var searchdata = searchData
        for hikaku1 in allData {
            for hikaku2 in searchdata {
                if hikaku1 == hikaku2 {
                
                    //要素の場所を検索
                    if let  indexNum = searchdata.firstIndex(of: hikaku2) {
                        searchdata.remove(at: indexNum)
                    }
                }
            }
        }
        return searchdata
    }
    
    @IBAction func searchConditionButton(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(identifier: "SearchConditions") as! SearchCoditions
        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
        present(nav,animated: true,completion: nil)
    }
    
    
    //--------------collectionview----------------
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            if self.reloadBool == false {
                return 6
            }else{
                return setUserDataArray.count
            }
        }
    }
    
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let SearchConCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchConCollectionViewCell", for: indexPath) as! SearchConCollectionViewCell
            SearchConCollectionViewCell.button.addTarget(self, action:#selector(self.pushButton(_:forEvent:)), for:.touchUpInside)
            if self.reloadBool == false {
                SearchConCollectionViewCell.isHidden = true
            }else{
                SearchConCollectionViewCell.isHidden = false
            }
            return SearchConCollectionViewCell
        }else{
            let SearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
            if setUserDataArray != [] {
                SearchCell.setData(setUserDataArray[indexPath.row])
            }
            SearchCell.layer.cornerRadius = SearchCell.frame.size.width * 0.1
            let selectedBGView = UIView(frame: SearchCell.frame)
            selectedBGView.backgroundColor = ColorData.whitesmoke
            SearchCell.selectedBackgroundView = selectedBGView
            SearchCell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            SearchCell.layer.shadowColor = UIColor.black.cgColor
            SearchCell.layer.shadowOpacity = 0.6
            SearchCell.layer.shadowRadius = 2
            return SearchCell
        }
    }
    
    @objc func pushButton(_ sender: UIButton, forEvent event:UIEvent) {
        let view = self.storyboard?.instantiateViewController(identifier: "SearchConditions") as! SearchCoditions
        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
        present(nav,animated: true,completion: nil)
    }
    
    @objc func toGoodBilling(_ sender: UIButton, forEvent event:UIEvent){
        let goodBilling = self.storyboard?.instantiateViewController(identifier: "GoodBilling") as! GoodBilling
        self.navigationController?.pushViewController(goodBilling, animated: true)
    }
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 60)
        }else{
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width  - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 250)
        }
    }
    
    // セルの行間の設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didBecomeActiveBool == false {
            return
        }
        if indexPath.section == 0 {
            return
        }
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.ButtonMode = 1
        Profile.profileData = setUserDataArray[indexPath.row]
        self.present(Profile,animated: true,completion: nil)
    }
    
    
    //検索条件設定時のユーザー検索
    @objc func searchConditionTrue(){
        self.searchCondition = true
        self.reloadBool = false
        self.collectionView.showAnimatedGradientSkeleton()
        self.reloadBool = true
        //初期化処理
        Initialization()
        setUserDataArray = []
        //インジゲーター
        
        //配列準備
        let allDataArray = arrayPrepare()
        searchRef = fromAppDelegate.Ref
        searchRef!.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                self.collectionView.hideSkeleton()
                return
            }
            self.UserArray = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = UserData(document: document)
                return userData
            }
            self.last = querySnapshot?.documents.last
            let num = self.UserArray.count
            if num != 0 {
                for i in 0...num - 1{
                    self.UserIdArray.append(self.UserArray[i].uid)
                }
                self.searchUidData = self.hikaku(allData: allDataArray, searchData: self.UserIdArray)
                //searchUidDataを使ってセルのデータを取得する(ユーザーのドキュメントデータ)
                let num = self.searchUidData.count
                if num != 0 {
                    let num2 = num - 1
                    for i in 0...num2{
                        let ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(self.searchUidData[i])
                        ref.getDocument(){(data,error) in
                        if let error = error {
                            print(error)
                            self.collectionView.hideSkeleton()
                            return
                        }
                        let setData:MyProfileData = MyProfileData(document: data!)
                        self.setUserDataArray.append(setData)
                        if i == num2 {
                            //リフレッシュ終了
                            self.refreshControl.endRefreshing()
                            //リフレッシュ終了
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.collectionView.hideSkeleton()
                                self.collectionView.reloadData()
                            }
                            //PKHUD
                            // TableViewの表示を更新する
                            self.zeroViewAppear()
                        }
                    }
                }
                }else{
                    self.collectionView.hideSkeleton()
                    self.zeroViewAppear()
                }
            }else{
                self.collectionView.hideSkeleton()
                self.zeroViewAppear()
            }
    }
    }
    
    //検索条件設定時のユーザー検索
    func searchConditionTrue2(){
        //初期化
        Initialization()
        //配列準備
        let allDataArray = arrayPrepare()
        
        let Ref = searchRef?.start(afterDocument: last!)
        Ref!.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
                }
                self.last = querySnapshot?.documents.last
                self.UserArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let userData = UserData(document: document)
                    return userData
                }
                let num = self.UserArray.count
                if num != 0 {
                    for i in 0...num - 1{
                        self.UserIdArray.append(self.UserArray[i].uid)
                    }
                    self.searchUidData = self.hikaku(allData: allDataArray, searchData: self.UserIdArray)
                    //searchUidDataを使ってセルのデータを取得する(ユーザーのドキュメントデータ)
                    let num = self.searchUidData.count
                    if num != 0 {
                        let num2 = num - 1
                        for i in 0...num2{
                            let ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(self.searchUidData[i])
                            ref.getDocument(){(data,error) in
                            if let error = error {
                                print(error)
                                return
                            }
                            let setData:MyProfileData = MyProfileData(document: data!)
                            self.setUserDataArray.append(setData)
                            if i == num2 {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

