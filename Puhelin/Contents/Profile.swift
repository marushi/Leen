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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var weekLabel: UIButton!
    @IBOutlet weak var phoneLabel: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var downTriangle: UIImageView!
    @IBOutlet weak var photoBackView: UIView!
    
    
    //定数
    let goodButton = UIButton(type: .system)
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 4

    //変数
    var ButtonMode:Int?
    var listener: ListenerRegistration!
    var opUserId:String?
    var Users:String?
    var profileData:MyProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewCornerRadius:CGFloat = 20
        //アウトレットの設定
        photo.layer.cornerRadius = (self.view.frame.size.width - 80) / 2
        photo.layer.borderColor = ColorData.turquoise.cgColor
        photo.layer.borderWidth = 5
        photoBackView.backgroundColor = ColorData.profileback
        view3.layer.cornerRadius = viewCornerRadius
        view3.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        view4.layer.cornerRadius = viewCornerRadius
        headerView.isHidden = true
        headerView.addBorder(width: 1, color: .lightGray, position: .bottom)
        let angle = 180 * CGFloat.pi / 180
        let transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
        downTriangle.transform = transRotate
        sentenceMessage.textContainerInset = UIEdgeInsets.zero
        sentenceMessage.textContainer.lineFragmentPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = viewCornerRadius
        tableView.rowHeight = 40
        introTextView.isUserInteractionEnabled = false
        weekLabel.layer.cornerRadius = weekLabel.frame.size.height / 2
        weekLabel.isEnabled = false
        weekLabel.adjustsImageWhenDisabled = false
        phoneLabel.layer.cornerRadius = phoneLabel.frame.size.height / 2
        phoneLabel.isEnabled = false
        phoneLabel.adjustsImageWhenDisabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addBorder(width: 1, color: .lightGray, position: .top)
        collectionView.layer.cornerRadius = viewCornerRadius
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        collectionView.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if ButtonMode == 1{
            goodButton.setTitle("いいね！", for: .normal)
            goodButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            headerView.isHidden = false
        }else if ButtonMode == 2 {
            goodButton.setTitle("話してみる！", for: .normal)
            headerView.isHidden = false
        }else if ButtonMode == 3{
            goodButton.setTitle("編集する", for: .normal)
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
            //self.navigationController?.navigationBar.barTintColor = photoBackView.backgroundColor
            
        }
        //ボタンの設定
        goodButton.addTarget(self, action: #selector(Button(_:)), for: UIControl.Event.touchUpInside)
        goodButton.layer.cornerRadius = 30
        goodButton.backgroundColor = UIColor.init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        goodButton.setTitleColor(.white, for: .normal)
        goodButton.tintColor = .white
        goodButton.frame = CGRect(x: (self.view.frame.width - 300) / 2, y: self.view.frame.height - 100, width: 300, height: 60)
        self.view.addSubview(goodButton)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if ButtonMode == 3 {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController!.navigationBar.shadowImage = nil
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        }
    }
    
    //スクロールで隠す
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @IBAction func headerViewAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //戻るボタン
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //いいねユーザーを取得する時
    func setData(_ userData: String) {
        
        //性別毎に相手のuidを取得
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            opUserId = userData
            Users = "Female_Users"
        }else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            opUserId = userData
            Users = "Male_Users"
        }
        
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Users!).document(opUserId!)
            listener = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
                self.profileData = MyProfileData(document: querySnapshot!)
            //画像設定
            self.photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(querySnapshot?.get("photoId") as! String)
            self.photo.sd_setImage(with: imageRef)
            //その他情報設定
            let name = querySnapshot?.get("name")
            let age =  querySnapshot?.get("age")
            let region = querySnapshot?.get("region")
            let intro = querySnapshot?.get("intro")
            let sentenceMes = querySnapshot?.get("sentenceMessage")
            self.name.text = "\(name!) " + "\(age!)才 " + "\(region!)"
            self.introTextView.text = intro! as? String
            self.sentenceMessage.text = sentenceMes! as? String
            //今週入会かどうか
            let weekAgo = Date(timeIntervalSinceNow: -60*60*24*4)
            let date:Timestamp = querySnapshot?.get("signupDate") as! Timestamp
            let signupDate: Date = date.dateValue()
            if signupDate < weekAgo {
                self.weekLabel.isHidden = true
            }else{
                self.weekLabel.isHidden = false
            }
            //通話OKかどうか
                let identBool:Bool? = querySnapshot?.get("identification") as? Bool
                if identBool == true {
                    self.phoneLabel.isHidden = false
                }else{
                    self.phoneLabel.isHidden = true
                }
            self.tableView.reloadData()
            }
        }
    }
    
    func profileSetData(){
        
        var DB = ""
        
        //自分の性別を入れる
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }
        
        let Ref = Firestore.firestore().collection(DB).document(userDefaults.string(forKey: "uid")!)
        Ref.getDocument() { (document, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            return
            }
            self.profileData = MyProfileData(document: document!)
            //自分の情報を設定
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(self.profileData!.photoId!)
            self.photo.sd_setImage(with: imageRef)
            
            let name = self.profileData!.name
            let age = self.profileData!.age
            let region = self.profileData!.region
            let intro = self.profileData!.intro
            let sentenceMes = self.profileData!.sentenceMessage
            self.name.text = "\(name!) " + "\(age!)才 " + "\(region!)"
            self.introTextView.text = intro!
            self.sentenceMessage.text = sentenceMes!
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        
        ButtonMode = 3
    }
    
    //イイネボタンの処理
    @objc func Button(_ sender: Any) {
        if ButtonMode == 1{
            //Hud
            HUD.show(.progress)
            //相手のいいねリストに自分を追加
            let Ref = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "DB")!).document(opUserId!).collection(Const.GoodPath).document(userDefaults.string(forKey: "uid")!)
            let Dic = ["uid": userDefaults.string(forKey: "uid")!,"name": userDefaults.string(forKey: "name")!] as [String: Any]
                Ref.setData(Dic)
            //--------ポイント処理-------
            var goodpoint = self.userDefaults.integer(forKey: UserDefaultsData.GoodPoint)
            goodpoint -= 1
            self.userDefaults.set(goodpoint, forKey: UserDefaultsData.GoodPoint)
            //-------------------------
            HUD.hide()
            AudioServicesPlaySystemSound(1519)
                self.dismiss(animated: true, completion: nil)
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
                let Dic = ["senderId": userDefaults.string(forKey: UserDefaultsData.uid) as Any
                    ,"displayName": userDefaults.string(forKey: UserDefaultsData.name) as Any
                    ,"text": "いいねありがとうございます！"
                    ,"sendTime": Date() as Any] as [String:Any]
                MesRef.setData(Dic)
                
                let ref = Firestore.firestore().collection(Const.MalePath).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
                ref.delete()
            
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
                let Dic = ["senderId": userDefaults.string(forKey: UserDefaultsData.uid) as Any
                    ,"displayName": userDefaults.string(forKey: UserDefaultsData.name) as Any
                    ,"text": "いいねありがとうございます！"
                    ,"sendTime": Date() as Any] as [String:Any]
                MesRef.setData(Dic)
                
                let ref = Firestore.firestore().collection(Const.FemalePath).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(opUserId!)
                ref.delete()
            }
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
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.profileData = profileData
        cell.setUp(indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
}
