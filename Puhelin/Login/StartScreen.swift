import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class StartScreen: UIViewController,LoginButtonDelegate {

    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        // ログイン済みかチェック
        if let token = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    // ...
                    return
                }
                
                // ログイン時の処理
                self.userDefaults.set(Auth.auth().currentUser?.uid, forKey: "uid")
                if self.userDefaults.string(forKey: "mailaddress") == nil {
                    let NavigationController = self.storyboard?.instantiateViewController(identifier: "NavigationController")
                    self.present(NavigationController!,animated: true,completion: nil)
                }else if self.userDefaults.string(forKey: "mailaddress") != nil && self.userDefaults.bool(forKey: "photoUP") == false {
                    let photo = self.storyboard?.instantiateViewController(identifier: "photo")
                    self.present(photo!,animated: true,completion: nil)
                }else {
                    let TabBarConrtroller = self.storyboard?.instantiateViewController(identifier: "TabBarConrtroller")
                    self.present(TabBarConrtroller!,animated: true,completion: nil)
                
            
                }
                return
        
            }
        // ログインボタン設置
        let fbLoginBtn = FBLoginButton()
        fbLoginBtn.permissions = ["public_profile", "email"]
        fbLoginBtn.center = self.view.center
        fbLoginBtn.delegate = self
        self.view.addSubview(fbLoginBtn)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // login callback
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

        if error != nil {
            print("Error")
            return
        }
        // ログイン時の処理
    }

    @IBAction func logoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    // Logout callback
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
}
