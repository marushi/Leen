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
    
    var UserArray: [UserData] = []
    var listener: ListenerRegistration!
    var DB = ""
    
    let titleLabel = UILabel() // ラベルの生成
    let textLabel = UILabel()
    let profilebutton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //tableviewの設定
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.tableFooterView = UIView(frame: .zero)
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
            }
        }
        // TableViewの表示を更新する
        self.tableView.reloadData()
        //いいねがゼロの場合の画面表示
        if self.UserArray.count == 0 {
            self.tableView.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
            self.setUp()
        } else {
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.tableView.isHidden = false
            self.titleLabel.isHidden = true
            self.textLabel.isHidden = true
            self.profilebutton.isHidden = true
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
        titleLabel.isHidden = false
        textLabel.isHidden = false
        profilebutton.isHidden = false
        
        // UILabelの設定
        titleLabel.frame = CGRect(x: (self.view.frame.width - 187)/2, y: 30, width: 180, height: 30) // 位置とサイズの指定
        titleLabel.textAlignment = NSTextAlignment.center // 横揃えの設定
        titleLabel.text = "いいね！がありません" // テキストの設定
        titleLabel.textColor = UIColor.white // テキストカラーの設定
        titleLabel.font = UIFont.systemFont(ofSize: 15)// フォントの設定
        titleLabel.backgroundColor = .lightGray
        titleLabel.layer.cornerRadius = 10
        titleLabel.clipsToBounds = true
        self.view.addSubview(titleLabel) // ラベルの追加
        
        //UIlabelテキストの設定
        textLabel.frame = CGRect(x: 0, y: self.view.frame.height/2 - 90, width: self.view.frame.width, height: 44)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.text = "プロフィールを充実させていいね！をもらおう！"
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(textLabel)
        
        //UIButtonの設定
        profilebutton.addTarget(self, action: #selector(moovToProfile(_:)), for: UIControl.Event.touchUpInside)
        profilebutton.frame = CGRect(x: 30, y: self.view.frame.height/2 - 44, width: self.view.frame.width - 60, height: 60)
        profilebutton.layer.cornerRadius = profilebutton.frame.size.height / 2
        profilebutton.setTitle("マイプロフィールを確認する", for: .normal)
        profilebutton.backgroundColor = ColorData.salmon
        profilebutton.setTitleColor(.white, for: .normal)
        self.view.addSubview(profilebutton)
    }
    
    //プロフィールへ移動
    @objc func moovToProfile(_ sender: UIButton){
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
            }
            UserArray.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

    


