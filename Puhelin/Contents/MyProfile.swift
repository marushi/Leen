//
//  MyProfile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import FirebaseUI

class MyProfile: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //テーブルビューの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 65
        
        //セルの登録
        let nib_1 = UINib(nibName: "MyProfileCell", bundle: nil)
        tableView.register(nib_1, forCellReuseIdentifier: "MyProfileCell")
        
        //画像を丸くする
        photo.layer.cornerRadius = photo.frame.size.width * 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(UserDefaults.standard.string(forKey: "photoId")!)
        photo.sd_setImage(with: imageRef)
    }

    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell", for: indexPath) as! MyProfileCell
        cell.setData(indexPath.row)
        return cell
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let personality = self.storyboard?.instantiateViewController(identifier: "Personality") as! Personality
            self.present(personality,animated: true,completion: nil)
        case 1:
            let Identification = self.storyboard?.instantiateViewController(identifier: "Identification") as! Identification
            self.present(Identification,animated: true,completion: nil)
        case 2:
            let Usage = self.storyboard?.instantiateViewController(identifier: "Usage") as! Usage
            self.present(Usage,animated: true,completion: nil)
        case 3:
            let Information = self.storyboard?.instantiateViewController(identifier: "Information") as! Information
            self.present(Information,animated: true,completion: nil)
        case 4:
            let Billing = self.storyboard?.instantiateViewController(identifier: "Billing") as! Billing
            self.present(Billing,animated: true,completion: nil)
        default:
            return
        }
    }
}
