//
//  EditProfile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/23.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import FirebaseUI

class ProfilePreview: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ageRegion: UILabel!
    @IBOutlet weak var intro: UITextView!
    
    let userDefaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userDefaults.string(forKey: "photoId")!)
        photo.sd_setImage(with: imageRef)
        
        name.text = userDefaults.string(forKey: "name")
        ageRegion.text = "\(userDefaults.integer(forKey: "age"))" + "才　" + "\(userDefaults.string(forKey: "region")!)"
    }
    
    //戻る
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
