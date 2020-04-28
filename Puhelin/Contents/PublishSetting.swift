//
//  PublishSetting.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/26.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class PublishSetting: UIViewController {
    
    @IBOutlet weak var switchButton: UISwitch!

    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let Ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!)
        Ref.getDocument() { (document, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            return
            }
            if let searchPermis:Bool = document?.get("searchPermis") as? Bool {
                if searchPermis == true {
                    self.switchButton.isOn = true
                }else{
                    self.switchButton.isOn = false
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func modoru(_ sender: Any) {
        let ref = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(userDefaults.string(forKey: "uid")!)
        if switchButton.isOn == true {
            ref.setData(["searchPermis": true] , merge: true)
        }else{
            ref.setData(["searchPermis": false] , merge: true)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
