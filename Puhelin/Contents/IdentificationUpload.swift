//
//  IdentificationUpload.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class IdentificationUpload: UIViewController {
    //部品
    @IBOutlet weak var photoimage: UIImageView!
    
    //変数
    var identImage:UIImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        photoimage.image = identImage
    }
    
    //確認書類をアップロード
    @IBAction func uploadButton(_ sender: Any) {
        let date:Date = Date()
        let gender = UserDefaults.standard.integer(forKey: "gender")
        //firebaseに写真をアップロード
        let registImage = photoimage.image!.jpegData(compressionQuality: 0.75)
        let uid = Auth.auth().currentUser?.uid
        let photoId:String = uid! + "\(date)" + ".jpg"
        let imageRef = Storage.storage().reference().child(Const.IdentificationPath).child(photoId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(registImage!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                return
            }
            let ref = Firestore.firestore().collection("Identifications").document(uid!)
            let dic = ["photoId":photoId,"uid":uid as Any,"date":date,"confirm": false,"gender":gender] as [String : Any]
            ref.setData(dic as [String : Any])
            //アイデンティフィケイションを申請中（１）に
            UserDefaults.standard.set(1, forKey: "identification")
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
