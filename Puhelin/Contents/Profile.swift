//
//  Profile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class Profile: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var introTextView: UITextView!
    
    var ButtonAppear:Bool = true
    

    var userInfo: UserData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        introTextView.isEditable = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userInfo.uid + ".jpg")
        photo.sd_setImage(with: imageRef)
        
        name.text = userInfo.name
        age.text = "\(userInfo.age!)" + "才　" + "\(userInfo.region!)"
        
        if ButtonAppear == false {
            Button.setTitle("話してみる！", for: .normal)
            let image = UIImage(named: "Button_3")
            Button.setBackgroundImage(image, for: .normal)
        }
    }
    
    @IBAction func Button(_ sender: Any) {
        //相手のGood_Usersに自分を入れる
        if ButtonAppear == true {
            let Ref = Firestore.firestore().collection(UserDefaults.standard.string(forKey: "DB")!).document(userInfo.uid).collection(Const.GoodPath).document()
            let Dic = ["uid": UserDefaults.standard.string(forKey: "uid")] as [String: Any]
                Ref.setData(Dic)
                self.dismiss(animated: true, completion: nil)
        } else if ButtonAppear == false {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
