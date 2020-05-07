
import UIKit
import Firebase
import SkeletonView

class Footprint: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var footUsers:[FootUsers] = []
    var profileData:MyProfileData?
    var profileDataArray:[MyProfileData] = []
    var reloadBool = false
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 220
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = ColorData.whitesmoke
        //セルの登録
        let nib = UINib(nibName: "GoodCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GoodCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        tableView.showAnimatedGradientSkeleton()
        let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(UserDefaults.standard.string(forKey: "uid")!).collection(Const.FoorPrints).order(by: "date" , descending: true).limit(to: 7)
        ref.getDocuments() {(document , error) in
            if let error = error {
                print(error)
                self.tableView.hideSkeleton()
                return
            }
            self.footUsers = document!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = FootUsers(document: document)
                return userData
            }
            self.getData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //戻るボタン
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData(){
        let num = footUsers.count
        if num > 0 {
            for i in 0...(num - 1) {
                let ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(self.footUsers[i].uid!)
                ref.getDocument(){(data,error) in
                    if let error = error {
                        print(error)
                        self.tableView.hideSkeleton()
                        return
                    }
                    let data = MyProfileData(document: data!)
                    self.profileDataArray.append(data)
                    if i == 0 {
                        self.tableView.hideSkeleton()
                        self.reloadBool = true
                        self.tableView.reloadData()
                    }
                }
            }
        }else{
            self.reloadBool = true
            self.tableView.hideSkeleton()
            self.tableView.reloadData()
        }
    }
}

//tableViewの設定
extension Footprint:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.reloadBool == false {
            return 6
        }else{
            return profileDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodCell") as! GoodCell
        if self.reloadBool == true {
            if profileDataArray[indexPath.row].photoId == nil || profileDataArray[indexPath.row].photoId == "" {
                cell.photo.contentMode = .scaleAspectFit
                if self.userDefaults.integer(forKey: "gender") ==  1 {
                    cell.photo.image = UIImage(named: "female")
                }else{
                    cell.photo.image = UIImage(named: "male")
                }
            }else{
                cell.photo.contentMode = .scaleAspectFill
                let imageRef = Storage.storage().reference().child(Const.ImagePath).child(profileDataArray[indexPath.row].photoId!)
                cell.photo.sd_setImage(with: imageRef)
            }
        cell.profileData = profileDataArray[indexPath.row]
        cell.selectionStyle = .none
        cell.setFootData(self.footUsers[indexPath.row])
        cell.footBool = true
        }
        return cell
    }
    //セルをタップした時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.setData(footUsers[indexPath.row].uid!)
        Profile.ButtonMode = 4
        present(Profile,animated: true,completion: nil)
    }
    
}


//dataクラス
class FootUsers:NSObject{
    var date:Timestamp?
    var uid:String?
    
    init(document: DocumentSnapshot) {
        self.uid = document.documentID
        self.date = document.get("date") as? Timestamp
    }
}
