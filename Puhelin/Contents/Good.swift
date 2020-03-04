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
    @IBOutlet weak var topLabel: UILabel!
    
    var UserArray: [UserData] = []
    var listener: ListenerRegistration!
    var DB = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.delegate = self
        tableView.dataSource  = self

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
            // TableViewの表示を更新する
            self.tableView.reloadData()
            
            }
        }
        
        //いいねがゼロの場合の画面表示
        if UserArray.count == 0 {
            tableView.isHidden = true
            topLabel.isHidden = true
            setUp()
        } else {
            tableView.isHidden = false
            topLabel.isHidden = false
        }
    }
    
    func setUp(){
        // UILabelの設定
        let titleLabel = UILabel() // ラベルの生成
        titleLabel.frame = CGRect(x: (self.view.frame.width - 187)/2, y: 60, width: 187, height: 30) // 位置とサイズの指定
        titleLabel.textAlignment = NSTextAlignment.center // 横揃えの設定
        titleLabel.text = "いいね！がありません" // テキストの設定
        titleLabel.textColor = UIColor.white // テキストカラーの設定
        titleLabel.font = UIFont(name: "System", size: 15) // フォントの設定
        titleLabel.backgroundColor = .lightGray
        titleLabel.layer.cornerRadius = 10
        titleLabel.clipsToBounds = true
        self.view.addSubview(titleLabel) // ラベルの追加
        
        //UIlabelテキストの設定
        let textLabel = UILabel()
        textLabel.frame = CGRect(x: 0, y: self.view.frame.height/2 - 90, width: self.view.frame.width, height: 44)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.text = "プロフィールを充実させていいね！をもらおう！"
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont(name: "System", size: 14)
        self.view.addSubview(textLabel)
        
        //UIButtonの設定
        let profilebutton = UIButton(type: .system)
        profilebutton.frame = CGRect(x: 30, y: self.view.frame.height/2 - 44, width: self.view.frame.width - 60, height: 44)
        profilebutton.layer.cornerRadius = 10
        profilebutton.setTitle("プロフィールを編集する", for: .normal)
        profilebutton.backgroundColor = .systemPink
        profilebutton.setTitleColor(.white, for: .normal)
        self.view.addSubview(profilebutton)
    }
    
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserArray.count + 1
    }
    
    //セルの中身の設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let GoodCell = tableView.dequeueReusableCell(withIdentifier: "GoodCell", for: indexPath) as! GoodCell
        let TopCell = tableView.dequeueReusableCell(withIdentifier: "TopCell")
        if indexPath.row == 0 {
            tableView.rowHeight = 50
            TopCell?.selectionStyle = .none
            TopCell?.isUserInteractionEnabled = false
            return TopCell!
        }else{
            tableView.rowHeight = 240
            GoodCell.setData(UserArray[indexPath.row - 1])
            return GoodCell
        }
    }
    
    //セルをタップした時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.setData(UserArray[indexPath.row - 1])
        Profile.ButtonAppear = false
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

    


