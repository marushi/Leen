//
//  AfterVideoCall.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/15.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class AfterVideoCall: UIViewController {
    
    //部品
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var selector: UISegmentedControl!
    @IBOutlet weak var OKbutton: UIButton!
    
    //変数
    var selectorNum = 0
    var topImage: UIImage?
    var roomName:String?
    var opid: String?

    //定数
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.layer.cornerRadius = photo.frame.size.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photo.image = topImage
        let ref = Firestore.firestore().collection(userDefaults.string(forKey: "DB")!).document(opid!)
        ref.getDocument() { (document, error) in
        if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            return
            }
            self.nameLabel.text = document?.get("name") as? String
        }
    }
    
    @IBAction func selectorButton(_ sender: Any) {
        if selector.selectedSegmentIndex == 0 {
            selectorNum = 0
        }
        if selector.selectedSegmentIndex == 1 {
            selectorNum = 1
        }
    }
    
    @IBAction func okButton(_ sender: Any) {
        if selectorNum == 0 {
            let ref = Firestore.firestore().collection(Const.ChatPath).document(self.roomName!)
            let selfData = userDefaults.integer(forKey: "gender") + 2
            let dic = ["\(selfData)": true]
            ref.setData(dic, merge: true)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
