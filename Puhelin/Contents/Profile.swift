//
//  Profile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import FirebaseUI
import AudioToolbox

class Profile: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var sentenceMessage: UITextView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var weekLabel: UIButton!
    @IBOutlet weak var phoneLabel: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoBackView: UIView!
    @IBOutlet weak var goodView: UIView!
    @IBOutlet weak var goodimage: UIImageView!
    @IBOutlet weak var goodlabel: UILabel!
    @IBOutlet weak var goodlabel2: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var limitGoodNum: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var xmarkView: UIImageView!
    
    //定数
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let goodButton = UIButton(type: .system)
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 4

    //変数
    var ButtonMode:Int?
    var listener: ListenerRegistration!
    var opUserId:String?
    var profileData:MyProfileData?
    var searchUid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewCornerRadius:CGFloat = 20
        //アウトレットの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.layer.cornerRadius = viewCornerRadius
        view3.layer.cornerRadius = viewCornerRadius
        view3.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        view4.layer.cornerRadius = viewCornerRadius
        sentenceMessage.textContainerInset = UIEdgeInsets.zero
        sentenceMessage.textContainer.lineFragmentPadding = 0
        sentenceMessage.backgroundColor = .white
        introTextView.isUserInteractionEnabled = false
        introTextView.backgroundColor = .white
        weekLabel.layer.cornerRadius = weekLabel.frame.size.height / 2
        weekLabel.isEnabled = false
        weekLabel.adjustsImageWhenDisabled = false
        phoneLabel.layer.cornerRadius = phoneLabel.frame.size.height / 2
        phoneLabel.isEnabled = false
        phoneLabel.adjustsImageWhenDisabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = viewCornerRadius
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        collectionView.isUserInteractionEnabled = false
        xmarkView.layer.cornerRadius = xmarkView.frame.size.height / 2
        
        //ボタンの設定
        goodButton.addTarget(self, action: #selector(Button(_:)), for: UIControl.Event.touchUpInside)
        goodButton.layer.cornerRadius = 30
        goodButton.backgroundColor = UIColor.init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        goodButton.setTitleColor(.white, for: .normal)
        goodButton.tintColor = .white
        goodButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        goodButton.layer.shadowColor = UIColor.lightGray.cgColor
        goodButton.layer.shadowOpacity = 0.7
        goodButton.layer.shadowRadius = 6
        self.view.addSubview(goodButton)
        
         let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(self.xmarkAction(gestureRecognizer:)))
        self.xmarkView.addGestureRecognizer(tapGestureRecognizer1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        goodView.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: ColorData.salmon
        ]
        //サーチ画面
        if ButtonMode == 1{
            self.profileSetData()
            goodButton.setTitle("いいね！", for: .normal)
            goodButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            //いいね！ボタンを灰色に
            if userDefaults.integer(forKey: UserDefaultsData.remainGoodNum) == 0 {
                goodButton.backgroundColor = .lightGray
            }
            //いいね済みの場合
            let selectId = fromAppDelegate.selectIdArray
            if selectId.firstIndex(of: (profileData?.uid)!) != nil {
                self.goodButton.setTitle("いいね！済み", for: .normal)
                self.goodButton.backgroundColor = .lightGray
                self.goodButton.isEnabled = false
            }
            //相手のあしあとリストに自分を追加
            let footRef = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document((profileData?.uid)!).collection(Const.FoorPrints).document(userDefaults.string(forKey: "uid")!)
            let footDic = ["uid":userDefaults.string(forKey: "uid")!,"date":Date()] as [String : Any]
            footRef.setData(footDic)
            
            let num = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
            if num <= 0 {
                self.goodButton.setTitle("いいね！がありません", for: .normal)
                self.goodButton.backgroundColor = .lightGray
                self.goodButton.isEnabled = false
            }
            //いいね受信画面
        }else if ButtonMode == 2 {
            goodButton.setTitle("話してみる！", for: .normal)
            //マイページから
        }else if ButtonMode == 3{
            goodButton.setTitle("編集する", for: .normal)
            xmarkView.isHidden = true
            profileSetData()
        }else if ButtonMode == 4 {
            goodButton.setTitle("いいね！", for: .normal)
            goodButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            //いいね！ボタンを灰色に
            if userDefaults.integer(forKey: UserDefaultsData.remainGoodNum) == 0 {
                goodButton.backgroundColor = .lightGray
            }
            //いいね済みの場合
            let selectId = fromAppDelegate.selectIdArray
            if selectId.firstIndex(of: (opUserId)!) != nil {
                self.goodButton.setTitle("いいね！済み", for: .normal)
                self.goodButton.backgroundColor = .lightGray
                self.goodButton.isEnabled = false
            }
            let num = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
            if num <= 0 {
                self.goodButton.setTitle("いいね！がありません", for: .normal)
                self.goodButton.backgroundColor = .lightGray
                self.goodButton.isEnabled = false
            }
        }else if ButtonMode == 5 {
            goodButton.isHidden = true
        }
        else{
            profileSetData()
        }
        
        goodButton.frame = CGRect(x: (self.view.frame.width - 300) / 2, y: self.view.frame.height - 100, width: 300, height: 60)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
        if ButtonMode == 3 {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        }
    }
    
    @IBAction func headerViewAction(_ sender: Any) {
        self.modalTransitionStyle = .coverVertical
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func xmarkAction(gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //戻るボタン
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //いいねユーザーを取得する時
    func setData(_ userData: String) {
        //データ入れ
        opUserId = userData
            let Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(opUserId!)
            Ref.getDocument() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
                self.profileData = MyProfileData(document: querySnapshot!)
            //画像設定
            //自分の情報を設定
                if self.profileData?.photoId != "" && self.profileData?.photoId != nil{
                self.photo.contentMode = .scaleAspectFill
                let imageRef = Storage.storage().reference().child(Const.ImagePath).child(self.profileData!.photoId!)
                self.photo.sd_setImage(with: imageRef)
            }else{
                self.photo.contentMode = .scaleAspectFit
                if self.userDefaults.integer(forKey: "gender") == 2 {
                    self.photo.image = UIImage(named: "male")
                }else{
                    self.photo.image = UIImage(named: "female")
                }
                
            }
            //その他情報設定
                var str:String = ""
                if let name = querySnapshot?.get("name") as? String {
                    str += name + "　"
                }
                if let age =  querySnapshot?.get("age") as? Int {
                    str += String(age) + "歳　"
                }
                if let region = querySnapshot?.get("region") as? String {
                    str += region
                }
                self.name.text = str
                if let intro = querySnapshot?.get("intro") {
                    self.introTextView.text = intro as? String
                }
                if let sentenceMes = querySnapshot?.get("sentenceMessage") {
                    self.sentenceMessage.text = sentenceMes as? String
                }
           
                //今週入会かどうか
                if let date:Timestamp = querySnapshot?.get("signupDate") as? Timestamp {
                    let weekAgo = Date(timeIntervalSinceNow: -60*60*24*4)
                    let signupDate: Date = date.dateValue()
                    if signupDate < weekAgo {
                        self.weekLabel.isHidden = true
                    }else{
                        self.weekLabel.isHidden = false
                    }
                }
        
                //通話OKかどうか
                if let identBool:Int = querySnapshot?.get("identification") as? Int {
                    if identBool == 2 {
                        self.phoneLabel.isHidden = false
                    }else{
                        self.phoneLabel.isHidden = true
                    }
                }else{
                    self.phoneLabel.isHidden = true
                }
                self.tableView.reloadData()
                self.collectionView.reloadData()
        }
    }
    
    func profileSetData(){
        //自分の情報を設定
        if self.profileData?.photoId != "" && self.profileData?.photoId != nil{
            self.photo.contentMode = .scaleAspectFill
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(self.profileData!.photoId!)
            self.photo.sd_setImage(with: imageRef)
        }else{
            self.photo.contentMode = .scaleAspectFit
            if self.userDefaults.integer(forKey: "gender") == 2 {
                if ButtonMode == 3 {
                    self.photo.image = UIImage(named: "female")
                }else{
                    self.photo.image = UIImage(named: "male")
                }
            }else{
                if ButtonMode == 3 {
                    self.photo.image = UIImage(named: "male")
                }else{
                    self.photo.image = UIImage(named: "female")
                }
            }
        }
        self.opUserId = profileData?.uid
        if let name = self.profileData?.name
        ,let age = self.profileData?.age
        ,let region = self.profileData?.region
        ,let intro = self.profileData?.intro
            ,let sentenceMes = self.profileData!.sentenceMessage {
            self.name.text = "\(name) " + "\(age)才 " + "\(region)"
            self.introTextView.text = intro
            self.sentenceMessage.text = sentenceMes
        }
        self.tableView.reloadData()
        self.collectionView.reloadData()
        //通話OKかどうか
        if let identBool:Int = profileData?.identification {
            if identBool == 2 {
                self.phoneLabel.isHidden = false
            }else{
                self.phoneLabel.isHidden = true
            }
        }else{
            self.phoneLabel.isHidden = true
        }
        
        //今週入会かどうか
        if let date:Timestamp = profileData?.signupDate{
            let weekAgo = Date(timeIntervalSinceNow: -60*60*24*4)
            let signupDate: Date = date.dateValue()
            if signupDate < weekAgo {
                self.weekLabel.isHidden = true
            }else{
                self.weekLabel.isHidden = false
            }
        }else{
            self.weekLabel.isHidden = true
        }
    }
    
    //イイネボタンの処理
    @objc func Button(_ sender: Any) {
        if ButtonMode == 1{
            self.view.isUserInteractionEnabled = false
            self.scrollView.isScrollEnabled = false
            if userDefaults.integer(forKey: UserDefaultsData.remainGoodNum) == 0{                self.goodView.backgroundColor = ColorData.turquoise
                self.goodView.isHidden = false
                self.goodView.alpha = 1
                self.limitGoodNum.alpha = 1
                self.goodimage.isHidden = true
                self.goodlabel.isHidden = true
                self.goodlabel2.isHidden = true
                
                UIView.animateKeyframes(withDuration: 1.8, delay: 0, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                        self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentInset.top)
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                        AudioServicesPlaySystemSound(1519)
                        self.goodView.alpha = 0
                        self.limitGoodNum.alpha = 0
                    })
                }, completion: { _ in
                    self.goodView.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    self.scrollView.isScrollEnabled = true
                })
                return
            }
            //Hud
            HUD.show(.progress)
            //相手のいいねリストに自分を追加
            let Ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(opUserId!).collection(Const.GoodPath).document(userDefaults.string(forKey: "uid")!)
            let Dic = ["uid": userDefaults.string(forKey: "uid")!
                ,"name":userDefaults.string(forKey: "name")!
                ,"date":Date()] as [String: Any]
                Ref.setData(Dic)
            //自分のセレクトリストに相手を保存
            let selectRef = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!).collection(Const.SelectUsers).document(opUserId!)
            let selectDic = ["uid": opUserId!,"date":Date()] as [String : Any]
            selectRef.setData(selectDic)
            //相手のレシーブリストに入れる
            let opRecRef = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(
                opUserId!).collection(Const.ReceiveData).document(userDefaults.string(forKey: "uid")!)
            let opRecDic = ["uid":userDefaults.string(forKey: "uid")!,"date":Date()] as [String : Any]
            opRecRef.setData(opRecDic)
            //--------ポイント処理-------
            //remaingoodnum
            var remainNum = self.userDefaults.integer(forKey: UserDefaultsData.remainGoodNum)
            remainNum -= 1
            self.userDefaults.set(remainNum, forKey: UserDefaultsData.remainGoodNum)
            //-------------------------
            HUD.hide()
            //いいねアニメーションの追加
            UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                self.goodView.isHidden = false
                self.limitGoodNum.isHidden = true
                self.view.isUserInteractionEnabled = false
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentInset.top)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2, animations: {
                    AudioServicesPlaySystemSound(1519)
                    let angle2 = CGFloat((-30 * .pi) / 180.0)
                    self.goodimage.transform = CGAffineTransform(rotationAngle: angle2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.2, animations: {
                    let angle = CGFloat((5 * .pi) / 180.0)
                    self.goodimage.transform = CGAffineTransform(rotationAngle: angle)
                })
            }, completion: { _ in
                self.view.isUserInteractionEnabled = true
                self.scrollView.isScrollEnabled = true
                self.presentingViewController?.beginAppearanceTransition(true, animated: true)
                self.presentingViewController?.endAppearanceTransition()
                self.dismiss(animated: true, completion: nil)
            })
            
        }else if ButtonMode == 2 {
            //HUD
            HUD.flash(.success,delay: 0.5)
            
            //チャットルーム作成
            let ChatRef = Firestore.firestore().collection(Const.ChatPath).document()
            if UserDefaults.standard.integer(forKey: "gender") == 1 {
                let DIc = ["1": userDefaults.string(forKey: "uid")!
                    ,"2": opUserId!
                    ,"3": false
                    ,"4": false
                    ,"token1": userDefaults.string(forKey: "token")!
                    ,"token2": self.profileData?.token as Any
                    ,"name1": userDefaults.string(forKey: "name")!
                    ,"name2": self.profileData?.name as Any] as [String : Any]
                ChatRef.setData(DIc)
                let MesRef = ChatRef.collection(Const.MessagePath).document()
                let Dic = ["senderId": userDefaults.string(forKey: "uid") as Any
                    ,"displayName": userDefaults.string(forKey: "name") as Any
                    ,"text": "いいねありがとうございます！"
                    ,"sendTime": Date() as Any] as [String:Any]
                MesRef.setData(Dic)
            
            } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
                let DIc = ["2": userDefaults.string(forKey: "uid")!
                    ,"1": opUserId!
                    ,"3": false
                    ,"4": false
                    ,"token2": userDefaults.string(forKey: "token")!
                    ,"token1": self.profileData?.token as Any
                    ,"name2": userDefaults.string(forKey: "name")!
                    ,"name1": self.profileData?.name as Any] as [String : Any]
                ChatRef.setData(DIc)
                let MesRef = ChatRef.collection(Const.MessagePath).document()
                let Dic = ["senderId": userDefaults.string(forKey: "uid") as Any
                    ,"displayName": userDefaults.string(forKey: "name") as Any
                    ,"text": "いいねありがとうございます！"
                    ,"sendTime": Date() as Any] as [String:Any]
                MesRef.setData(Dic)
                
            }
            //自分のマッチングリストに入れる
            let matchRef = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!).collection(Const.MatchingPath).document(opUserId!)
            let matchDic = ["uid":opUserId!,"date":Date()] as [String : Any]
            matchRef.setData(matchDic)
            //相手のマッチングリストに入れる
            let opMatchRef = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(
                opUserId!).collection(Const.MatchingPath).document(userDefaults.string(forKey: "uid")!)
            let opMatchDic = ["uid":userDefaults.string(forKey: "uid")!,"date":Date()] as [String : Any]
            opMatchRef.setData(opMatchDic)
            //GoodUsersからデータを削除
            let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
            ref.delete()
            self.dismiss(animated: true, completion: nil)
        }else {
            let EditProfile = self.storyboard?.instantiateViewController(identifier: "EditProfile") as! EditProfile
            EditProfile.profileData = self.profileData
            self.navigationController?.pushViewController(EditProfile, animated: true)
        }
    }
}

extension Profile : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 4
    }
    
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileHeaderCell
        cell.isUserInteractionEnabled = false
        cell.data = self.profileData
        cell.setData(indexPath.row)
        return cell
    }
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width  - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: collectionView.frame.size.height)
    }
}

extension Profile:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.profileData = profileData
        cell.setUp(indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
}
