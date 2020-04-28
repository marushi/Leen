//
//  Photo.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import RSKImageCropper


class Photo: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Button.isEnabled = false
        imageView.layer.cornerRadius = imageView.frame.size.width * 0.1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 3
        selectButton.layer.cornerRadius = selectButton.frame.size.height / 2
        Button.layer.cornerRadius = Button.frame.size.height / 2
        Button.backgroundColor = UIColor.init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.7
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            imageView.image = UIImage(named: "male")
        }else {
            imageView.image = UIImage(named: "female")
        }
    }
    
    @IBAction func imagetap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func Photo(_ sender: Any) {
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
    
    @IBAction func Button(_ sender: Any) {
        
        let date:Date = Date()
        
        //firebaseに写真をアップロード
        let registImage = imageView.image!.jpegData(compressionQuality: 0.75)
        let uid = Auth.auth().currentUser?.uid
        let photoId:String = uid! + "\(date)" + ".jpg"
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(photoId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(registImage!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                return
            }
            if UserDefaults.standard.integer(forKey: "gender") == 1 {
                let Ref = Firestore.firestore().collection(Const.MalePath).document(uid!)
                let dic = ["photoId": photoId]
                Ref.setData(dic,merge: true)
            }else{
                let Ref = Firestore.firestore().collection(Const.FemalePath).document(uid!)
                let dic = ["photoId": photoId]
                Ref.setData(dic,merge: true)
            }
            
            UserDefaults.standard.set(photoId, forKey: "photoId")
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            
 
        }
    }
    
    @IBAction func skipButton(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            let Ref = Firestore.firestore().collection(Const.MalePath).document(uid!)
            let dic = ["photoId": ""]
            Ref.setData(dic,merge: true)
        }else{
            let Ref = Firestore.firestore().collection(Const.FemalePath).document(uid!)
            let dic = ["photoId": ""]
            Ref.setData(dic,merge: true)
        }
        
        UserDefaults.standard.set("", forKey: "photoId")
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension Photo: RSKImageCropViewControllerDelegate {
  //キャンセルを押した時の処理
  func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
    dismiss(animated: true, completion: nil)
  }
  //完了を押した後の処理
  func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
    dismiss(animated: true)
    imageView.image = croppedImage
    imageView.contentMode = .scaleAspectFill
    imageView.alpha = 1
    Button.isEnabled = true
  }
}

