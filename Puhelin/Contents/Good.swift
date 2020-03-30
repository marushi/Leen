//
//  Good.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class Good: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //いいねがない時の部品
    @IBOutlet weak var ButtonTopLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var nonHeartText: UITextView!
    @IBOutlet weak var myProfileButton: UIButton!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var heartBackimage: UIImageView!
    
    
    var UserArray: [UserData] = []
    var listener: ListenerRegistration!
    var DB = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //tableviewの設定
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.tableFooterView = UIView(frame: .zero)
        myProfileButton.layer.cornerRadius = myProfileButton.frame.size.height / 2
        myProfileButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myProfileButton.layer.shadowColor = UIColor.black.cgColor
        myProfileButton.layer.shadowOpacity = 0.6
        myProfileButton.layer.shadowRadius = 1
        headLabel.clipsToBounds = true
        headLabel.layer.cornerRadius = headLabel.frame.size.height / 2
        //セルの登録
        let nib = UINib(nibName: "GoodCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GoodCell")
        
        //データベースの設定
        if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        } else if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(DB).document(Auth.auth().currentUser!.uid).collection(Const.GoodPath)
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
                let tabItem = self.tabBarController?.tabBar.items![1]
                tabItem?.badgeValue = "\(self.UserArray.count)"
                if self.UserArray.count == 0 || self.UserArray == []{
                    tabItem?.badgeValue = nil
                }
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
            
        }
        //いいねがゼロの場合の画面表示
        if self.UserArray.count == 0 {
            self.tableView.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
            self.setUp()
        } else {
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.tableView.isHidden = false
            self.heartImage.isHidden = true
            self.nonHeartText.isHidden = true
            self.myProfileButton.isHidden = true
            self.headLabel.isHidden = true
            self.ButtonTopLabel.isHidden = true
            self.heartBackimage.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    //スクロールで隠す
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func setUp(){

        //三つを表示
        heartImage.isHidden = false
        nonHeartText.isHidden = false
        myProfileButton.isHidden = false
        self.headLabel.isHidden = false
        self.ButtonTopLabel.isHidden = false
        self.heartBackimage.isHidden = false
    }
    
    @IBAction func moveToProfile(_ sender: Any) {
        let profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        profile.profileSetData()
        self.navigationController!.pushViewController(profile,animated: true)
        
    }
    
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserArray.count + 1
    }
    
    //セルの中身の設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let GoodCell = tableView.dequeueReusableCell(withIdentifier: "GoodCell", for: indexPath) as! GoodCell
        let TopCell = tableView.dequeueReusableCell(withIdentifier: "TopCell") as! cell
        if indexPath.row == 0 {
            tableView.rowHeight = 30
            TopCell.selectionStyle = .none
            TopCell.isUserInteractionEnabled = false
            TopCell.titleLabel.text = String(self.UserArray.count) + "人からいいねが来ています！"
            return TopCell
        }else{
            tableView.rowHeight = 240
            GoodCell.setData(UserArray[indexPath.row - 1])
            GoodCell.selectionStyle = UITableViewCell.SelectionStyle.none
            return GoodCell
        }
    }
    
    //セルをタップした時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.setData(UserArray[indexPath.row - 1].uid)
        Profile.ButtonMode = 2
        present(Profile,animated: true,completion: nil)
    }
    
    //スワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //データベースから削除
            let ref = Firestore.firestore()
            let userDefaults = UserDefaults.standard
            if userDefaults.integer(forKey: "gender") == 1 {
                let Ref = ref.collection(Const.MalePath).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(UserArray[indexPath.row - 1].uid)
                Ref.delete(completion: nil)
            }else{
                let Ref = ref.collection(Const.FemalePath).document(userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).document(UserArray[indexPath.row - 1].uid)
                Ref.delete(completion: nil)
            }
            UserArray.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

    


