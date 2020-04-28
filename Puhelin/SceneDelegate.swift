//
//  SceneDelegate.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let userDefaults = UserDefaults.standard

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        //通知をゼロにする
        for (key, value) in UserDefaults.standard.dictionaryRepresentation().sorted(by: { $0.0 < $1.0 }) {
            print("- \(key) => \(value)")
        }
        if UserDefaults.standard.integer(forKey: "gender") == 1 || UserDefaults.standard.integer(forKey: "gender") == 2 {
            UIApplication.shared.applicationIconBadgeNumber = 0
            let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(UserDefaults.standard.string(forKey: "uid")!)
            ref.getDocument(){(data,error) in
                if let error = error {
                    print(error)
                    return
                }
                //もしも同じ端末で２つのアカウントを使い分ける場合に必要
                if data?.get("LoginDate") == nil {
                    self.userDefaults.set(15, forKey: UserDefaultsData.remainGoodNum)
                }else{
                let lastlogin:Timestamp = data?.get("LoginDate") as! Timestamp
                let loginDate: Date = lastlogin.dateValue()
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY年MM月dd日"
                let lastLoginDate = "\(formatter.string(from: loginDate))"
                let Today = "\(formatter.string(from: date))"
                //違うなら回復
                if lastLoginDate != Today {
                    let num = self.userDefaults.integer(forKey: "goodLimit")
                    if num == 0{
                        self.userDefaults.set(5, forKey: UserDefaultsData.remainGoodNum)
                    }else if num == 1 {
                        self.userDefaults.set(10, forKey: UserDefaultsData.remainGoodNum)
                    }else if num == 2 {
                        self.userDefaults.set(15, forKey: UserDefaultsData.remainGoodNum)
                    }else if num == 3 {
                        self.userDefaults.set(20, forKey: UserDefaultsData.remainGoodNum)
                    }
                }
                }
                ref.setData(["newMesNum":0
                ,"LoginDate":Date()], merge: true)
            }
            
        }
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

