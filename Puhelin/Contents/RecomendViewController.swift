
import UIKit
import Firebase
import AudioToolbox
import SCLAlertView
import SkeletonView

class RecomendViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //0の時
    /*@IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button0: UIButton!*/

    //変数設定
    var UserArray: [UserData] = []  // 検索したドキュメントのmapデータ
    var UserIdArray: [String] = []  //検索したデータのUidだけの文字列
    var searchUidData:[String] = [] //新しい人が入ってる検索用データ
    var setUserDataArray:[MyProfileData] = []
    var regionArray:[String] = []
    var searchQuery:searchQueryData?
    var refreshControl = UIRefreshControl()
    var didBecomeActiveBool:Bool?
    var orderType:Int?
    var last:DocumentSnapshot? = nil
    var setUp2Bool:Bool? = false
    var limitNum:Int?
    var searchRef:Query?
    var min:Int?
    var max:Int?
    //レイアウト設定
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 2
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let hokkaidou = ["北海道"]
    let touhoku = ["青森県", "岩手県", "宮城県", "秋田県",
    "山形県", "福島県"]
    let kantou = ["茨城県", "栃木県", "群馬県",
    "埼玉県", "千葉県", "東京都", "神奈川県"]
    let chubu = ["新潟県",
    "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県"]
    let kinki = ["三重県", "滋賀県",
    "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県"]
    let chugoku = ["鳥取県", "島根県", "岡山県", "広島県", "山口県"]
    let shikoku = ["徳島県", "香川県", "愛媛県", "高知県"]
    let kyushu = ["福岡県",
    "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
    "鹿児島県"]
    let okinawa = ["沖縄県"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
        
        
        //部品の設定
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = ColorData.snow
        
        /*/0の時
        label1.isHidden = true
        label2.isHidden = true
        button0.isHidden = true
        button0.layer.cornerRadius = button0.frame.size.height / 2
        button0.layer.borderColor = UIColor.darkGray.cgColor
        button0.layer.borderWidth = 3*/
        
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
        collectionView.register(UINib(nibName: "searchTopCell", bundle: nil), forCellWithReuseIdentifier: "searchTopCell")
        limitNum = 30
        //検索条件オブジェクト
        searchQuery = searchQueryData()
        //下にスワイプした時に更新処理
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControl
        //初回かどうか
        didBecomeActiveBool = false
    }
    
    //したにスワイプした時の更新処理
    @objc func refreshTable() {
        AudioServicesPlaySystemSound(1520)
        // 更新処理
        self.setUp()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.didBecomeActiveBool == false{
            self.getMyProfileData()
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
        if distanceToBottom < 100 && self.setUp2Bool == false{
            //次の人を取得する
            if self.last != nil {
                self.setUp2Bool = true
                self.setUp2()
            }
        }
    }
    
    func regionSetUp(){
        if let num = fromAppDelegate.myProfileData?.age {
            min = num - 5
            max = num + 5
        }
        if let region = fromAppDelegate.myProfileData?.region {
            if self.hokkaidou.contains(region) {
                self.regionArray = hokkaidou
            }
            if self.touhoku.contains(region) {
                self.regionArray = touhoku
            }
            if self.kantou.contains(region) {
                self.regionArray = kantou
            }
            if self.chubu.contains(region) {
                self.regionArray = chubu
            }
            if self.kinki.contains(region) {
                self.regionArray = kinki
            }
            if self.chugoku.contains(region) {
                self.regionArray = chugoku
            }
            if self.shikoku.contains(region) {
                self.regionArray = shikoku
            }
            if self.kyushu.contains(region) {
                self.regionArray = kyushu
            }
            if self.okinawa.contains(region) {
                self.regionArray = okinawa
            }
        }
    }
    
    func getMyProfileData(){
        var listener:ListenerRegistration!
        if listener == nil {
            let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(self.userDefaults.string(forKey: "uid")!)
            listener = ref.addSnapshotListener(){(querySnapshot,error) in
                if let error = error {
                    print(error)
                    return
                }
                self.fromAppDelegate.myProfileData = MyProfileData(document: querySnapshot!)
            }
        }
    }

    //ユーザーを画面に表示する
    func setUp(){
        
        self.collectionView.showAnimatedGradientSkeleton()
        //配列準備
        let allDataArray = arrayPrepare()
        Initialization()
        setUserDataArray = []
        
        regionSetUp()
        
        var Ref:Query!
        Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).limit(to: limitNum!).whereField("searchPermis", isEqualTo: true).whereField("region", in: self.regionArray).whereField("age", isGreaterThanOrEqualTo: min!).whereField("age", isLessThanOrEqualTo: max!)
        Ref.getDocuments() { (querySnapshot, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            self.collectionView.hideSkeleton()
            self.refreshControl.endRefreshing()
            return
            }
            self.last = querySnapshot?.documents.last
            self.setUp2Bool = false
            self.UserArray = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = UserData(document: document)
                return userData
            }
            
            let num = self.UserArray.count
            if num != 0 {
                for i in 0...num - 1{
                    if self.UserIdArray.contains(self.UserArray[i].uid) == false {
                        self.UserIdArray.append(self.UserArray[i].uid)
                    }
                }
                //比較する　値が合致する要素を番号取得　そこをUserIdArrayから削除する　それをセルに渡して、そのuidからセル側で検索する
               
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
                                self.refreshControl.endRefreshing()
                                return
                            }
                            let setData:MyProfileData = MyProfileData(document: data!)
                            self.setUserDataArray.append(setData)
                            if num == self.setUserDataArray.count {
                                self.refreshControl.endRefreshing()
                                //リフレッシュ終了
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    self.collectionView.hideSkeleton()
                                    self.collectionView.reloadData()
                                }
                                // TableViewの表示を更新する
                                self.zeroViewAppear()
                            }
                        }
                    }
                }else{
                    // TableViewの表示を更新する
                    self.refreshControl.endRefreshing()
                    self.collectionView.hideSkeleton()
                    self.zeroViewAppear()
                }
            }else{
                self.refreshControl.endRefreshing()
                self.collectionView.hideSkeleton()
            }
        }
    }
    
    func setUp2(){
        self.collectionView.showAnimatedGradientSkeleton()
        //初期化
        Initialization()
        //配列準備
        let allDataArray = arrayPrepare()
        //並び替え分岐
        var Ref:Query?
        Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).limit(to: limitNum!).whereField("searchPermis", isEqualTo: true).whereField("region", in: self.regionArray).whereField("age", isGreaterThanOrEqualTo: min!).whereField("age", isLessThanOrEqualTo: max!).start(afterDocument: last!)
        Ref!.getDocuments() { (querySnapshot, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            self.collectionView.hideSkeleton()
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
                    if self.UserIdArray.contains(self.UserArray[i].uid) == false {
                        self.UserIdArray.append(self.UserArray[i].uid)
                    }
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
                                self.setUp2Bool = false
                                //リフレッシュ終了
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    self.collectionView.hideSkeleton()
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    }
                }else{
                    self.collectionView.hideSkeleton()
                }
            }else{
                self.collectionView.hideSkeleton()
            }
        }
    }
    
    func zeroViewAppear(){
        /*if self.setUserDataArray != [] {
            //0の時
            self.label1.isHidden = true
            self.label2.isHidden = true
            self.button0.isHidden = true
        }else{
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
        }*/
        
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
            if self.didBecomeActiveBool == false {
                return 6
            }
            return setUserDataArray.count
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
            if setUserDataArray != [] {
                SearchCell.setData(setUserDataArray[indexPath.row])
            }
            if didBecomeActiveBool == false {
                SearchCell.dateLabel.isHidden = true
            }
            SearchCell.layer.cornerRadius = SearchCell.frame.size.width * 0.1
            let selectedBGView = UIView(frame: SearchCell.frame)
            selectedBGView.backgroundColor = ColorData.snow
            SearchCell.selectedBackgroundView = selectedBGView
            SearchCell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            SearchCell.layer.shadowColor = UIColor.black.cgColor
            SearchCell.layer.shadowOpacity = 0.6
            SearchCell.layer.shadowRadius = 2
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
            UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
                    cell.checkView.alpha = 1.0
                    
            }, completion: nil)
        }else{
        }
    }
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if userDefaults.integer(forKey: UserDefaultsData.remainGoodNum) == 0 && setUserDataArray != [] {
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
}
