//
//  Photo.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CLImageEditor

class Photo: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate,CLImageEditorDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Button.isEnabled = false
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
        if info[.originalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[.originalImage] as! UIImage

            // あとでCLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")
            // CLImageEditorにimageを渡して、加工画面を起動する。
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            picker.present(editor, animated: true, completion: nil)

        }
    }
    // CLImageEditorで加工が終わったときに呼ばれるメソッド
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        // 写真選択画面に戻る
        imageView.image = image
        self.Button.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    // CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Button(_ sender: Any) {
        
        SVProgressHUD.show()
        
        //firebaseに写真をアップロード
        let registImage = imageView.image!.jpegData(compressionQuality: 0.75)
        let uid = Auth.auth().currentUser?.uid
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(uid! + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(registImage!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "設定完了")
            UserDefaults.standard.set(true, forKey: "photoUP")
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            
 
        }
    }
}
