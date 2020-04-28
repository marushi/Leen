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
import SCLAlertView

class Search: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sliderImage: UIButton!
    @IBOutlet weak var remainGood: UILabel!
    
    //0の時
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button0: UIButton!

    //変数設定
    var UserArray: [UserData] = []  // 検索したドキュメントのmapデータ
    var UserIdArray: [String] = []  //検索したデータのUidだけの文字列
    var searchUidData:[String] = [] //新しい人が入ってる検索用データ
    var searchCondition:Bool!
    var searchQuery:searchQueryData?
    var refreshControl = UIRefreshControl()
    var didBecomeActiveBool:Bool?
    var orderType:Int?
    var last:DocumentSnapshot? = nil
    var limitNum:Int?
    var searchRef:Query?
    //レイアウト設定
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 2
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.delegate = self
        //部品の設定
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = ColorData.snow
        conditionButton.layer.cornerRadius = 15
        searchCondition = false
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.6
        headerView.layer.shadowRadius = 1
        
        //0の時
        label1.isHidden = true
        label2.isHidden = true
        button0.isHidden = true
        button0.layer.cornerRadius = button0.frame.size.height / 2
        button0.layer.borderColor = UIColor.darkGray.cgColor
        button0.layer.borderWidth = 2
        
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        collectionView.register(UINib(nibName: "searchTopCell", bundle: nil), forCellWithReuseIdentifier: "searchTopCell")
        limitNum = 5
        //検索条件オブジェクト
        searchQuery = searchQueryData()
        //下にスワイプした時に更新処理
        refreshControl.addTarget(self, action: Selector(("refreshTable")), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControl
        //初回かどうか
        didBecomeActiveBool = false
    }
    
    //したにスワイプした時の更新処理
    @objc func refreshTable() {
         // 更新処理
        if searchCondition == false {
            self.setUp()
        }else{
            self.searchConditionTrue()
        }
     }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        remainGood.text = String(userDefaults.integer(forKey: UserDefaultsData.remainGoodNum))
        /*/配列比較
        let selectData = fromAppDelegate.selectIdArray
        let downData = fromAppDelegate.downIdArray
        let goodData = fromAppDelegate.goodIdArray
        let receiveData = fromAppDelegate.receiveIdArray
        let allDataArray = selectData + downData + goodData + receiveData
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
        }*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.didBecomeActiveBool == false{
            self.setUp()
            didBecomeActiveBool = true
        }
    }
    
    //スクロールで隠す
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        if distanceToBottom < 100 && self.last != nil{
            //次の人を取得する
            if self.searchCondition == false{
                self.setUp2()
            }
            if self.searchCondition == true {
                self.searchConditionTrue2()
            }
        }
    }

    //ユーザーを画面に表示する
    func setUp(){
        self.collectionView.alpha = 0
        //初期化処理
        UserArray = []
        UserIdArray = []
        searchUidData = []
        //インジゲーター
        HUD.show(.progress)
        
        //配列準備
        let selectData = fromAppDelegate.selectIdArray
        let downData = fromAppDelegate.downIdArray
        let goodData = fromAppDelegate.goodIdArray
        let receiveData = fromAppDelegate.receiveIdArray
        let allDataArray = selectData + downData + goodData + receiveData
        //並び替え分岐
        var Ref:Query!
        Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).limit(to: limitNum!).whereField("searchPermis", isEqualTo: true)
        Ref.getDocuments() { (querySnapshot, error) in
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
            if self.orderType == 1 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.LoginDate!.dateValue() > $1.LoginDate!.dateValue() }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            if self.orderType == 2 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.signupDate!.dateValue() > $1.signupDate!.dateValue() }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            /*if self.orderType == 3 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.age! > $1.age! }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            */
            
            
            let num = self.UserArray.count
            if num != 0 {
                for i in 0...num - 1{
                    if self.UserIdArray.contains(self.UserArray[i].uid) == false {
                        self.UserIdArray.append(self.UserArray[i].uid)
                    }
                }
                //比較する　値が合致する要素を番号取得　そこをUserIdArrayから削除する　それをセルに渡して、そのuidからセル側で検索する
                self.searchUidData = self.hikaku(allData: allDataArray, searchData: self.UserIdArray)
                self.collectionView.reloadData()
                //リフレッシュ終了
                self.refreshControl.endRefreshing()
                //PKHUD
                HUD.hide()
                UIView.animate(withDuration: 1.5, animations: {
                    self.collectionView.alpha = 1
                })
            }
            
            // TableViewの表示を更新する
            if self.searchUidData != [] {
                //0の時
                self.label1.isHidden = true
                self.label2.isHidden = true
                self.button0.isHidden = true
            }
            if self.searchUidData == [] {
                //0の時
                self.label1.isHidden = false
                self.label2.isHidden = false
                self.button0.isHidden = false
                self.label1.alpha = 0
                self.label2.alpha = 0
                self.button0.alpha = 0
                UIView.animate(withDuration: 1.5, animations: {
                    self.label1.alpha = 1
                    self.label2.alpha = 1
                    self.button0.alpha = 1
                })
            }
        }
    }
    
    func setUp2(){
        //配列準備
        let selectData = fromAppDelegate.selectIdArray
        let downData = fromAppDelegate.downIdArray
        let goodData = fromAppDelegate.goodIdArray
        let receiveData = fromAppDelegate.receiveIdArray
        let allDataArray = selectData + downData + goodData + receiveData
        //並び替え分岐
        var Ref:Query!
        Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).limit(to: limitNum!).whereField("searchPermis", isEqualTo: true).start(afterDocument: last!)
        Ref.getDocuments() { (querySnapshot, error) in
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
            if self.orderType == 1 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.LoginDate!.dateValue() > $1.LoginDate!.dateValue() }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            if self.orderType == 2 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.signupDate!.dateValue() > $1.signupDate!.dateValue() }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            /*if self.orderType == 3 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.age! > $1.age! }
                self.UserArray.sort(by: sortedByReleaseDate)
            }*/
            
            
            
            let num = self.UserArray.count
            if num != 0 {
                for i in 0...num - 1{
                    if self.UserIdArray.contains(self.UserArray[i].uid) == false {
                        self.UserIdArray.append(self.UserArray[i].uid)
                    }
                }
                //比較する　値が合致する要素を番号取得　そこをUserIdArrayから削除する　それをセルに渡して、そのuidからセル川で検索する
                self.searchUidData = self.hikaku(allData: allDataArray, searchData: self.UserIdArray)
                self.collectionView.reloadData()
            }
        }
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
    @IBAction func searchCon(_ sender: Any) {
        let searchCon = self.storyboard?.instantiateViewController(identifier: "SearchConditions") as! SearchCoditions
        searchCon.searchQuery = self.searchQuery
        self.navigationController?.pushViewController(searchCon, animated: true)
    }
    
    @IBAction func orderButton(_ sender: Any) {
        let order = self.storyboard?.instantiateViewController(identifier: "OrderController") as! OrderController
        self.tabBarController?.tabBar.isHidden = true
        order.selectNum = self.orderType
        present(order,animated: true,completion: nil)
    }
    
    @IBAction func button(_ sender: Any) {
        let searchCon = self.storyboard?.instantiateViewController(identifier: "SearchConditions") as! SearchCoditions
        searchCon.searchQuery = self.searchQuery
        self.navigationController?.pushViewController(searchCon, animated: true)
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
            return searchUidData.count
        }
    }
    
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let searchTopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchTopCell", for: indexPath) as! searchTopCell
            searchTopCell.isUserInteractionEnabled = false
            searchTopCell.setData()
            searchTopCell.checkButton.addTarget(self, action:#selector(toGoodBilling(_:forEvent:)), for:.touchUpInside)
            return searchTopCell
        }else{
            let SearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
            if searchUidData != [] {
                SearchCell.setData(searchUidData[indexPath.row])
            }
            SearchCell.layer.cornerRadius = SearchCell.frame.size.width * 0.1
            let selectedBGView = UIView(frame: SearchCell.frame)
            selectedBGView.backgroundColor = ColorData.whitesmoke
            SearchCell.selectedBackgroundView = selectedBGView
            SearchCell.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            SearchCell.layer.shadowColor = UIColor.darkGray.cgColor
            SearchCell.layer.shadowOpacity = 0.6
            SearchCell.layer.shadowRadius = 1
            return SearchCell
        }
    }
    
    @objc func toGoodBilling(_ sender: UIButton, forEvent event:UIEvent){
        let goodBilling = self.storyboard?.instantiateViewController(identifier: "GoodBilling") as! GoodBilling
        self.navigationController?.pushViewController(goodBilling, animated: true)
    }
    
    
    
    //セルが視界に入る直前
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = cell as! searchTopCell
            
            if self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum) > 0 {
                //----------表示処理----------
                cell.checkView.isHidden = true
                cell.nonimage.isHidden = true
                cell.nonlabel.isHidden = true
                cell.multipnon.isHidden = true
                cell.thumpsImage.isHidden = false
                cell.goodNum.isHidden = false
                cell.textLabel.isHidden = false
                cell.multipImage.isHidden = false
                //----------アニメーション------------
                UIView.animateKeyframes(withDuration: 2, delay: 0, options: .repeat, animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.08, animations: {
                    let angle2 = CGFloat((-30 * .pi) / 180.0)
                    cell.thumpsImage.transform = CGAffineTransform(rotationAngle: angle2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.15, animations: {
                    let angle = CGFloat((5 * .pi) / 180.0)
                    cell.thumpsImage.transform = CGAffineTransform(rotationAngle: angle)
                })

            }, completion: nil)
            }else{
                //非表示
                cell.thumpsImage.isHidden = true
                cell.goodNum.isHidden = true
                cell.textLabel.isHidden = true
                cell.multipImage.isHidden = true
                //表示
                cell.isUserInteractionEnabled = true
                cell.checkView.isHidden = false
                cell.checkView.alpha = 0.0
                cell.nonimage.isHidden = false
                cell.nonlabel.isHidden = false
                cell.multipnon.isHidden = false
                //viewをふわっと
                UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseIn], animations: {
                    cell.checkView.alpha = 1.0
                    
                }, completion: nil)
                
                
            }
        }
    }
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if userDefaults.integer(forKey: UserDefaultsData.remainGoodNum) == 0 && searchUidData != [] {
                return CGSize(width: collectionView.frame.width, height: 60)
            }else{
                return CGSize(width: collectionView.frame.width, height: 0)
            }
        }else{
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width  - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 250)
        }
    }
    
    // セルの行間の設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.ButtonMode = 1
        Profile.searchUid = searchUidData[indexPath.row]
        self.navigationController?.pushViewController(Profile, animated: true)
        
        
    }
    
    
    //検索条件設定時のユーザー検索
    func searchConditionTrue(){
        //初期化処理
        UserArray = []
        UserIdArray = []
        searchUidData = []
        //インジゲーター
        HUD.show(.progress)
        
        //配列準備
        let selectData = fromAppDelegate.selectIdArray
        let downData = fromAppDelegate.downIdArray
        let goodData = fromAppDelegate.goodIdArray
        let receiveData = fromAppDelegate.receiveIdArray
        let allDataArray = selectData + downData + goodData + receiveData
        var Ref:Query?
        Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).limit(to: limitNum!).whereField("searchPermis", isEqualTo: true)
        let num:Int = searchQuery!.prefecturs!.count - 1
        if num >= 0 {
            Ref = Ref!.whereField("region", in: searchQuery!.prefecturs!)
        }
        if searchQuery?.bodyType != nil && searchQuery?.bodyType != "こだわらない" {
            Ref = Ref!.whereField("bodyType", isEqualTo: searchQuery?.bodyType as Any)
        }
        if searchQuery?.talk != nil && searchQuery?.talk != "こだわらない"{
            Ref = Ref!.whereField("talk", isEqualTo: searchQuery?.talk as Any)
        }
        if searchQuery?.purpose  != nil && searchQuery?.purpose != "こだわらない" {
            Ref = Ref!.whereField("purpose", isEqualTo: searchQuery?.purpose as Any)
        }
        if searchQuery?.job  != nil && searchQuery?.job != "こだわらない"{
            Ref = Ref!.whereField("job", isEqualTo: searchQuery?.job as Any)
        }
        if searchQuery?.income  != nil && searchQuery?.income != "こだわらない" {
            Ref = Ref!.whereField("income", isEqualTo: searchQuery?.income as Any)
        }
        if searchQuery?.personality  != nil && searchQuery?.personality != "こだわらない" {
            Ref = Ref!.whereField("personality", isEqualTo: searchQuery?.personality as Any)
        }
        if searchQuery?.alchoal  != nil && searchQuery?.alchoal != "こだわらない" {
            Ref = Ref!.whereField("alchoal", isEqualTo: searchQuery?.alchoal as Any)
        }
        if searchQuery?.tabakoClass != nil && searchQuery?.tabakoClass != "こだわらない" {
            Ref = Ref!.whereField("tabakoClass", isEqualTo: searchQuery?.tabakoClass as Any)
        }
        if searchQuery?.tallClass != nil && searchQuery?.tallClass != "こだわらない" {
            Ref = Ref!.whereField("tallClass", isEqualTo: searchQuery?.tallClass as Any)
        }
        if searchQuery?.minAge != nil{
            Ref = Ref!.whereField("age", isGreaterThanOrEqualTo: searchQuery?.minAge as Any )
        }
        if searchQuery?.maxAge != nil{
            Ref = Ref!.whereField("age", isLessThanOrEqualTo: searchQuery?.maxAge as Any )
        }
        searchRef = Ref
        Ref!.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
                }
                self.UserArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let userData = UserData(document: document)
                    return userData
                }
            self.last = querySnapshot?.documents.last
            if self.orderType == 1 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.LoginDate!.dateValue() > $1.LoginDate!.dateValue() }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            if self.orderType == 2 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.signupDate!.dateValue() > $1.signupDate!.dateValue() }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            /*if self.orderType == 3 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.age! > $1.age! }
                self.UserArray.sort(by: sortedByReleaseDate)
            }*/
                let num = self.UserArray.count
                if num != 0 {
                    for i in 0...num - 1{
                        self.UserIdArray.append(self.UserArray[i].uid)
                    }
                    self.searchUidData = self.hikaku(allData: allDataArray, searchData: self.UserIdArray)
                }
                
            // TableViewの表示を更新する
            if self.searchUidData != [] {
                //0の時
                self.label1.isHidden = true
                self.label2.isHidden = true
                self.button0.isHidden = true
            }
            self.collectionView.reloadData()
            if self.searchUidData == [] {
                //0の時
                self.label1.isHidden = false
                self.label2.isHidden = false
                self.button0.isHidden = false
                self.label1.alpha = 0
                self.label2.alpha = 0
                self.button0.alpha = 0
                UIView.animate(withDuration: 1.5, animations: {
                    self.label1.alpha = 1
                    self.label2.alpha = 1
                    self.button0.alpha = 1
                })
            }
            //リフレッシュ終了
            self.refreshControl.endRefreshing()
            //PKHUD
            HUD.hide()
        }
    }
    
    //検索条件設定時のユーザー検索
    func searchConditionTrue2(){
        //配列準備
        let selectData = fromAppDelegate.selectIdArray
        let downData = fromAppDelegate.downIdArray
        let goodData = fromAppDelegate.goodIdArray
        let receiveData = fromAppDelegate.receiveIdArray
        let allDataArray = selectData + downData + goodData + receiveData
        let Ref = searchRef?.start(afterDocument: last!)
        Ref!.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
                }
                self.UserArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let userData = UserData(document: document)
                    return userData
                }
            if self.orderType == 1 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.LoginDate!.dateValue() > $1.LoginDate!.dateValue() }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            if self.orderType == 2 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.signupDate!.dateValue() > $1.signupDate!.dateValue() }
                self.UserArray.sort(by: sortedByReleaseDate)
            }
            /*if self.orderType == 3 {
                let sortedByReleaseDate: SortDescriptor<UserData> = { $0.age! > $1.age! }
                self.UserArray.sort(by: sortedByReleaseDate)
            }*/
                let num = self.UserArray.count
                if num != 0 {
                    for i in 0...num - 1{
                        self.UserIdArray.append(self.UserArray[i].uid)
                    }
                    self.searchUidData = self.hikaku(allData: allDataArray, searchData: self.UserIdArray)
                }
                
            // TableViewの表示を更新する
            if self.searchUidData != [] {
                //0の時
                self.label1.isHidden = true
                self.label2.isHidden = true
                self.button0.isHidden = true
            }
            self.collectionView.reloadData()
            if self.searchUidData == [] {
                //0の時
                self.label1.isHidden = false
                self.label2.isHidden = false
                self.button0.isHidden = false
                self.label1.alpha = 0
                self.label2.alpha = 0
                self.button0.alpha = 0
                UIView.animate(withDuration: 1.5, animations: {
                    self.label1.alpha = 1
                    self.label2.alpha = 1
                    self.button0.alpha = 1
                })
            }
            //リフレッシュ終了
            self.refreshControl.endRefreshing()
            //PKHUD
            HUD.hide()
        }
    }
}

extension Search:searchConResultDelegate{
    func searchConResultFunction(query: searchQueryData?, type: Int) {
        if type == 1 {
            self.searchQuery = query
            self.searchConditionTrue()
            self.searchCondition = true
            self.conditionButton.backgroundColor = ColorData.profileback
            self.conditionButton.tintColor = ColorData.salmon
            self.conditionButton.setTitle("絞り込み中...", for: .normal)
            self.conditionButton.setTitleColor(ColorData.salmon, for: .normal)
        }else if type == 2 {
            self.searchCondition = false
            self.conditionButton.setTitle("検索条件を設定する", for: .normal)
            self.conditionButton.setTitleColor(.darkGray, for: .normal)
            self.conditionButton.backgroundColor = ColorData.searchBarBackground
            self.conditionButton.tintColor = .darkGray
        }else if type == 3{
            self.searchCondition = false
            self.searchQuery = query
            self.setUp()
            self.conditionButton.setTitle("検索条件を設定する", for: .normal)
            self.conditionButton.setTitleColor(.darkGray, for: .normal)
            self.conditionButton.backgroundColor = ColorData.searchBarBackground
            self.conditionButton.tintColor = .darkGray
        }
        
        
    }
}

extension Search:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        /*if viewController.children.first is Search {
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentInset.top)
            })
            return true
        }*/
        return true
    }
}

extension Search:orderdelegate{
    func orderFunc(Type: Int) {
        self.tabBarController?.tabBar.isHidden = false
        if Type == 0 {
            return
        }
        self.orderType = Type
        //検索条件を設定しているかどうか分岐
        if self.searchCondition == true {
            self.searchConditionTrue()
        }else if self.searchCondition == false{
            self.setUp()
        }
        if Type == 3 {
            sliderImage.tintColor = .darkGray
        }else{
            sliderImage.tintColor = ColorData.salmon
        }
    }
}
