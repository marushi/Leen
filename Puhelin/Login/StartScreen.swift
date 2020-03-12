import UIKit
import Firebase

class StartScreen: UIViewController {

    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // ログイン時の処理
            self.userDefaults.set(Auth.auth().currentUser?.uid, forKey: "uid")
            if self.userDefaults.bool(forKey: "FirstLaunch") == false {
                let NavigationController = self.storyboard?.instantiateViewController(identifier: "NavigationController")
                self.present(NavigationController!,animated: true,completion: nil)
            }else {
                let TabBarConrtroller = self.storyboard?.instantiateViewController(identifier: "TabBarConrtroller")
                self.present(TabBarConrtroller!,animated: false,completion: nil)
                
            }
        }else{
            let phoneLogin = self.storyboard?.instantiateViewController(identifier: "phoneLogin")
            self.present(phoneLogin!,animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
