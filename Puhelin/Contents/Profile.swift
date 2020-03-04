//
//  Profile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class Profile: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    var ButtonAppear:Bool = true

    var userInfo: UserData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //設定
        introTextView.isUserInteractionEnabled = false
        view3.layer.cornerRadius = view2.frame.size.width * 0.05
        view3.layer.borderColor = UIColor.black.cgColor
        view3.layer.borderWidth = 1
        
        //ボタンの設定
        let goodButton = UIButton(type: .system)
        goodButton.addTarget(self, action: #selector(Button(_:)), for: UIControl.Event.touchUpInside)
        goodButton.layer.cornerRadius = 10
        goodButton.backgroundColor = UIColor.init(red: 255/255, green: 132/255, blue: 255/255, alpha: 1)
        goodButton.setTitleColor(.white, for: .normal)
        goodButton.setTitle("いいね！", for: .normal)
        goodButton.frame = CGRect(x: (self.view.frame.width - 200) / 2, y: self.view.frame.height - 150, width: 200, height: 40)
        self.view.addSubview(goodButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    //いいねユーザーを取得する時
    func setData(_ userData: UserData) {
        var listener: ListenerRegistration!
        var opUserId:String?
        var Users:String?
        
        //UserInfoにデータを入れる
        self.userInfo = userData
        
        //性別毎に相手のuidを取得
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            opUserId = userData.uid
            Users = "Female_Users"
        }else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            opUserId = userData.uid
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
            //画像設定
            self.photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(querySnapshot?.get("photoId") as! String)
            self.photo.sd_setImage(with: imageRef)
            //その他情報設定
            let name = querySnapshot?.get("name")
            let age =  querySnapshot?.get("age")
            let region = querySnapshot?.get("region")
            let intro = querySnapshot?.get("intro")
            self.name.text = name as? String
            self.age.text = "\(age!)才　" + "\(region!)"
            self.introTextView.text = intro! as? String
            }
        }
    }
    
    //イイネボタンの処理
    @objc func Button(_ sender: Any) {
        //相手のGood_Usersに自分を入れる
        if ButtonAppear == true {
            let Ref = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "DB")!).document(userInfo.uid).collection(Const.GoodPath).document(userInfo.uid)
            let Dic = ["uid": UserDefaults.standard.string(forKey: "uid")] as [String: Any]
                Ref.setData(Dic)
                self.dismiss(animated: true, completion: nil)
        } else if ButtonAppear == false {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
