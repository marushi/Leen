


import UIKit
import Firebase
import FirebaseUI
import SCLAlertView
import RSKImageCropper

class EditProfile: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var photochange: UIImageView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var MessageButton: UIButton!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var savesentenceButton: UIButton!
    //定数
    let userDefaults = UserDefaults.standard
    let uid = UserDefaults.standard.string(forKey: "uid")
    
    //データ
    var profileData:MyProfileData?
    var nickName:String?
    var region:String?
    var tallNum:String?
    var bodyType:String?
    var personality0 = "どちらでも"
    var personality1 = "どちらでも"
    var personality2 = "どちらでも"
    var selectRow0 = 0
    var selectRow1 = 0
    var selectRow2 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //OutLerの設定
        photoView.backgroundColor = ColorData.profileback
        photo.layer.cornerRadius = photo.frame.height * 0.5
        photochange.layer.cornerRadius = photochange.frame.height * 0.5
        photochange.backgroundColor = ColorData.whitesmoke
        MessageButton.backgroundColor = .white
        MessageButton.contentHorizontalAlignment = .left
        MessageButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        MessageButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: self.view.frame.size.width - 30, bottom: 0, right: 0)
        MessageButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        introTextView.isEditable = false
        textField.isHidden = true
        textField.delegate = self
        savesentenceButton.isHidden = true
        savesentenceButton.isEnabled = false
        
        //tableViewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = tableView.frame.height / 13
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        setUp()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    //戻るボタン
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func photoButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func sentenceMes(_ sender: Any) {
        if textField.isHidden == true {
            textField.isHidden = false
            textField.text = profileData?.sentenceMessage
            savesentenceButton.isHidden = false
        }else{
            textField.isHidden = true
            savesentenceButton.isHidden = true
        }
    }
    
    @IBAction func saveSentence(_ sender: Any) {
        textField.isHidden = true
        savesentenceButton.isHidden = true
        //保存先を指定
        var DB = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        }else if userDefaults.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }
        let Ref = Firestore.firestore().collection(DB).document(uid!)
        Ref.setData(["sentenceMessage":self.textField.text as Any], merge: true)
        self.MessageButton.setTitle(textField.text, for: .normal)
        savesentenceButton.isEnabled = false
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textNum = textField.text?.count else {
            return true
        }
        if textNum > 2 && textNum < 20 {
            savesentenceButton.isEnabled = true
            return true
        }else{
            savesentenceButton.isEnabled = false
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.textField.resignFirstResponder()
    }
    
    
    @IBAction func introduction(_ sender: Any) {
        let EditIntroduction = self.storyboard?.instantiateViewController(identifier: "EditIntroduction") as! EditIntroduction
        EditIntroduction.savedtext = self.profileData?.intro
        self.navigationController?.pushViewController(EditIntroduction, animated: true)
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
    
    //セットアップ
    func setUp(){
        //データセット
        if let photoId = self.profileData?.photoId {
            photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(photoId)
            photo.sd_setImage(with: imageRef)
        }
        MessageButton.setTitle(profileData?.sentenceMessage, for: .normal)
        introTextView.text = profileData?.intro
    }
    
    
}

extension EditProfile: RSKImageCropViewControllerDelegate {
  //キャンセルを押した時の処理
  func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
    dismiss(animated: true, completion: nil)
  }
  //完了を押した後の処理
  func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
    dismiss(animated: true)
    photo.image = croppedImage
    //---firebaseに保存---
    let date:Date = Date()
    //firebaseに写真をアップロード
    let registImage = croppedImage.jpegData(compressionQuality: 0.75)
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
        let Ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(uid!)
        let dic = ["photoId": photoId]
        Ref.setData(dic,merge: true)
    }
    //前の画像を削除
    if let photoId = self.profileData?.photoId {
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(photoId)
        imageRef.delete(completion: nil)
    }
    }
}

//
//基本情報
//
extension EditProfile: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let editProfileCell = tableView.dequeueReusableCell(withIdentifier: "editProfileCell",for: indexPath) as! editProfileCell
        editProfileCell.profileData = self.profileData
        editProfileCell.selectionStyle = .none
        editProfileCell.content.tag = indexPath.row
        editProfileCell.setUp(indexPath.row)
        editProfileCell.content.addTarget(self, action:#selector(self.pushButton(_:forEvent:)), for:.touchUpInside)
        return editProfileCell
    }
    
    @objc func pushButton(_ sender: UIButton, forEvent event:UIEvent){
        let row = sender.tag
        if row == 1{
            return
        }else if row == 0 {
            let HobbyInputView = self.storyboard?.instantiateViewController(identifier: "HobbyInputView") as! HobbyInputView
            HobbyInputView.inputMode = 0
            HobbyInputView.nameText = profileData?.name
            HobbyInputView.modalTransitionStyle = .crossDissolve
            present(HobbyInputView,animated: true,completion: nil)
        }else if row == 12{
            let HobbyInputView = self.storyboard?.instantiateViewController(identifier: "HobbyInputView") as! HobbyInputView
            HobbyInputView.inputMode = 1
            HobbyInputView.nameText = profileData?.hobby
            HobbyInputView.modalTransitionStyle = .crossDissolve
            present(HobbyInputView,animated: true,completion: nil)
        }
        else{
        let Personality2 = self.storyboard?.instantiateViewController(identifier: "Personality2") as! Personality2
        Personality2.setUp(row)
        Personality2.modalTransitionStyle = .crossDissolve
        self.present(Personality2,animated: true, completion: nil)
        }
    }
}

//
//値受け
//
extension EditProfile:perToEdit {
    func perToEditText(text: String, row: Int) {
        switch row {
        case 0:
            self.profileData?.region = text
        case 1:
            self.profileData?.bodyType = text
        case 2:
            self.profileData?.job = text
        case 3:
            self.profileData?.income = text
        case 4:
            self.profileData?.personality = text
        case 5:
            self.profileData?.talk = text
        case 6:
            self.profileData?.purpose = text
        case 7:
            self.profileData?.alchoal = text
        case 8:
            self.profileData?.tabako = text
        case 9:
            self.profileData?.name = text
        case 10:
            self.profileData?.hobby = text
        default:
            return
        }
        self.tableView.reloadData()
    }
    func perToEditNum(number: Int, row: Int) {
        self.profileData?.tall = number
        self.tableView.reloadData()
    }
}
    

