


import UIKit
import PKHUD
import Firebase
import FirebaseUI
import SCLAlertView
import RSKImageCropper

class EditProfile: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    @IBOutlet weak var photochange: UIImageView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var MessageButton: UIButton!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    //定数
    let userDefaults = UserDefaults.standard
    
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
        MessageButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: MessageButton.frame.width * 3 / 4, bottom: 0, right: 0)
        MessageButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        introTextView.isEditable = false
        
        //tableViewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //更新ボタン
    @IBAction func registButton(_ sender: Any) {
        
        HUD.show(.progress)
        
        let userDefaults = UserDefaults.standard
        let ref = Firestore.firestore()
        var DB = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        } else {
            DB = Const.FemalePath
        }
        
        let userRef = ref.collection(DB).document(userDefaults.string(forKey: "uid")!)
        let Dic = ["Personality":
            ["0":["どちらでも",personality0]
            ,"1":["どちらでも",personality1]
            ,"2":["どちらでも",personality2]]]
        userRef.updateData(Dic)
        
        HUD.hide()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //戻るボタン
    @IBAction func modoru(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("マイページへ") {
            //探す画面に戻る
            self.navigationController?.popViewController(animated: true)
        }
        alertView.addButton("戻る",backgroundColor: .lightGray,textColor: .black) {
            return
        }
        alertView.showSuccess("入力情報は保存されません。よろしいですか？", subTitle: "")
    }
    
    @IBAction func photoButton(_ sender: Any) {
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
    
    //セットアップ
    func setUp(){
        //データセット
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(profileData!.photoId!)
        photo.sd_setImage(with: imageRef)
        MessageButton.setTitle(profileData?.sentenceMessage, for: .normal)
        introTextView.text = profileData?.intro
    }
    
    @objc func pushButton(_ sender: UIButton, forEvent event:UIEvent){
        let row = sender.tag
        let Personality2 = self.storyboard?.instantiateViewController(identifier: "Personality2") as! Personality2
        Personality2.setUp(row)
        self.present(Personality2,animated: false, completion: nil)
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
  }
    
}

extension EditProfile: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
    
    
}
