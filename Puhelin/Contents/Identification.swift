
import UIKit
import PKHUD
import RSKImageCropper

class Identification: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
        //textView
        textView.font = UIFont.systemFont(ofSize: 14)
        button1.layer.cornerRadius = button1.frame.size.height / 2
        button1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button1.layer.shadowColor = UIColor.darkGray.cgColor
        button1.layer.shadowOpacity = 0.6
        button1.layer.shadowRadius = 2
        button2.layer.cornerRadius = button2.frame.size.height / 2
        button2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button2.layer.shadowColor = UIColor.darkGray.cgColor
        button2.layer.shadowOpacity = 0.6
        button2.layer.shadowRadius = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let num = userDefaults.integer(forKey: UserDefaultsData.identification)
        if num == 3 || num == 4 || num == 5 {
            let IdentificationPhotoUp = self.storyboard?.instantiateViewController(identifier: "IdentificationPhotoUp") as! IdentificationPhotoUp
            let navigationController = UINavigationController(rootViewController: IdentificationPhotoUp)
            self.present(navigationController,animated: true,completion: nil)
        }
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
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

extension Identification: RSKImageCropViewControllerDelegate {
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

