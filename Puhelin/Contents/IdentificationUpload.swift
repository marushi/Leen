//
//  IdentificationUpload.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import SCLAlertView

class IdentificationUpload: UIViewController {
    //部品
    @IBOutlet weak var photoimage: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    let userDefaults = UserDefaults.standard
    var profileData:MyProfileData?
    
    //変数
    var identImage:UIImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
        button.layer.cornerRadius = button.frame.size.height / 2
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 2

    }
    
    override func viewWillAppear(_ animated: Bool) {
        photoimage.image = identImage
        //生年月日を取得して表示
        let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!)
        ref.getDocument(){(data,error) in
            if let error = error {
                print(error)
                return
            }
            self.profileData = MyProfileData(document: data!)
        }
    }
    
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //確認書類をアップロード
    @IBAction func uploadButton(_ sender: Any) {
        HUD.show(.progress)
        let date:Date = Date()
        let gender = UserDefaults.standard.integer(forKey: "gender")
        //firebaseに写真をアップロード
        let registImage = photoimage.image!.jpegData(compressionQuality: 0.75)
        let uid:String = userDefaults.string(forKey: "uid")!
        let photoId:String = uid + "\(date)" + ".jpg"
        let imageRef = Storage.storage().reference().child(Const.IdentificationPath).child(photoId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(registImage!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SCLAlertView().showSuccess("通信エラー", subTitle: "通信環境をご確認ください。")
                HUD.hide()
                return
            }
            let ref = Firestore.firestore().collection("Identifications").document(uid)
            let year = self.profileData?.birthYear
            let month = self.profileData?.birthMonth
            let day = self.profileData?.birthDay
            let birthDay = String(year!) + "/" + String(month!) + "/" + String(day!)
            let dic = ["photoId":photoId,"uid":uid as Any,"date":date,"confirm": false,"gender":gender,"birthDay":birthDay] as [String : Any]
            ref.setData(dic as [String : Any])
            //アイデンティフィケイションを申請中（１）に
            let Ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(uid)
            Ref.setData(["identification":1], merge: true)
            UserDefaults.standard.set(1, forKey: UserDefaultsData.identification)
            HUD.hide()
            SCLAlertView().showSuccess("提出完了", subTitle: "承認には1〜2日かかる場合があります。ご了承ください。")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
