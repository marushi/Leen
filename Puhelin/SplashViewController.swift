//
//  SplashViewController.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/16.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SplashViewController: UIViewController {

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
                if self.userDefaults.string(forKey: "mailaddress") != nil {
                    let NickName = self.storyboard?.instantiateViewController(identifier: "NickName")
                    self.present(NickName!,animated: true,completion: nil)
                }else {
                    let TabBarConrtroller = self.storyboard?.instantiateViewController(identifier: "TabBarConrtroller")
                    self.present(TabBarConrtroller!,animated: true,completion: nil)
                
            
                }
                return
       
            }
            //未ログイン処理
            let NavigationController = self.storyboard?.instantiateViewController(identifier: "NavigationController")
            present(NavigationController!,animated: false)
        
        }
    }
}
