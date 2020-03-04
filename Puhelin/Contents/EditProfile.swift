//
//  EditProfile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/23.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import FirebaseUI
import RSKImageCropper

extension EditProfile: RSKImageCropViewControllerDelegate {
  //キャンセルを押した時の処理
  func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
    dismiss(animated: true, completion: nil)
  }
  //完了を押した後の処理
  func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
    dismiss(animated: true)
    photo.image = croppedImage
  }
}

extension EditProfile: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prefectures.count
    }
    
    //ドラムロールの各項目
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prefectures[row]
    }
    
    //選択した犬の名前をラベルに設定
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        prefetcure = prefectures[row]
    }


}



class EditProfile: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var intro: UITextView!
    
    let userDefaults = UserDefaults.standard
    
    var prefetcure = "北海道"
    let prefectures = ["北海道", "青森県", "岩手県", "宮城県", "秋田県",
    "山形県", "福島県", "茨城県", "栃木県", "群馬県",
    "埼玉県", "千葉県", "東京都", "神奈川県","新潟県",
    "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県",
    "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
    "鳥取県", "島根県", "岡山県", "広島県", "山口県",
    "徳島県", "香川県", "愛媛県", "高知県", "福岡県",
    "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
    "鹿児島県", "沖縄県"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userDefaults.string(forKey: "photoId")!)
        photo.sd_setImage(with: imageRef)
        
        nameText.text = userDefaults.string(forKey: "name")
    }

    @IBAction func editPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
            
    }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          let image = info[.originalImage] as! UIImage
          self.dismiss(animated: true, completion: nil)
          let imageCropVC = RSKImageCropViewController(image: image, cropMode: .square)
            imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
            imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
            imageCropVC.chooseButton.setTitle("完了", for: .normal)
          imageCropVC.delegate = self as RSKImageCropViewControllerDelegate
          present(imageCropVC, animated: true)
        }
    
    //変更を保存する
    @IBAction func editButton(_ sender: Any) {
        
        if photo.image == nil {
            return
        }
        
        //元の画像を削除
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userDefaults.string(forKey: "photoId")!)
        imageRef.delete(completion: nil)
        
        //firebaseに写真をアップロード
        let registImage = photo.image!.jpegData(compressionQuality: 0.75)
        let date:Date = Date()
        let newPhotoId:String = userDefaults.string(forKey: "uid")! + "\(date)" + ".jpg"
        let newImageRef = Storage.storage().reference().child(Const.ImagePath).child(newPhotoId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        newImageRef.putData(registImage!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                return
            }
            self.userDefaults.set(newPhotoId, forKey: "photoId")
        }
        
        //firebaseのユーザー情報を更新
        if userDefaults.integer(forKey: "gender") == 1 {
            let dataRef = Firestore.firestore().collection(Const.MalePath).document(userDefaults.string(forKey: "uid")!)
            let dic = ["name": nameText.text
                ,"region": prefetcure
                ,"intro": intro.text
                ,"photoId": newPhotoId] as [String: Any]
            dataRef.updateData(dic)
        }else{
            let dataRef = Firestore.firestore().collection(Const.FemalePath).document(userDefaults.string(forKey: "uid")!)
            let dic = ["name": nameText.text
                ,"region": prefetcure
                ,"intro": intro.text
                ,"photoId": newPhotoId] as [String: Any]
            dataRef.updateData(dic)
        }
        
        self.dismiss(animated: true, completion: nil)
         
    }
    
    //キャンセルボタンを押した時の処理
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
