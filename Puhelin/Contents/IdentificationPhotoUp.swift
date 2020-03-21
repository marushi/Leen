//
//  IdentificationPhotoUp.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import RSKImageCropper

class IdentificationPhotoUp: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
    }
    
    @IBAction func Liblary(_ sender: Any) {
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
    
}

extension IdentificationPhotoUp: RSKImageCropViewControllerDelegate {
  //キャンセルを押した時の処理
  func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
    dismiss(animated: true, completion: nil)
  }
  //完了を押した後の処理
  func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
    let upload = self.storyboard?.instantiateViewController(identifier: "IdentificationUpload") as! IdentificationUpload
    upload.identImage = croppedImage
    self.navigationController?.pushViewController(upload, animated: true)
    dismiss(animated: true)
  }
}
