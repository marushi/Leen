//
//  MyProfile.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import FirebaseUI

class MyProfile: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    
    
    var DB = ""
    var ProfileData:MyProfileData?
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //異性の相手をビューに表示
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        } else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            DB = Const.FemalePath
        }

        //テーブルビューの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        
        //ラベルの設定
        menuLabel.backgroundColor = .init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        //button設定
        button1.backgroundColor = .white
        button1.layer.cornerRadius = 25
        button1.layer.borderColor = ColorData.darkturquoise.cgColor
        button1.layer.borderWidth = 1
        
        //セルの登録
        let nib_1 = UINib(nibName: "MyProfileCell", bundle: nil)
        tableView.register(nib_1, forCellReuseIdentifier: "MyProfileCell")
        
        //画像を丸くする
        photo.layer.cornerRadius = photo.frame.size.width * 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        // 画像の表示
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(UserDefaults.standard.string(forKey: "photoId")!)
        photo.sd_setImage(with: imageRef)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }

    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell", for: indexPath) as! MyProfileCell
        cell.selectionStyle = .none
        cell.setData(indexPath.row)
        return cell
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let Identification = self.storyboard?.instantiateViewController(identifier: "Identification") as! Identification
            self.present(Identification,animated: true,completion: nil)
        case 1:
            let Usage = self.storyboard?.instantiateViewController(identifier: "Usage") as! Usage
            self.present(Usage,animated: true,completion: nil)
        case 2:
            let Information = self.storyboard?.instantiateViewController(identifier: "Information") as! Information
            self.present(Information,animated: true,completion: nil)
        case 3:
            let Billing = self.storyboard?.instantiateViewController(identifier: "Billing") as! Billing
            self.present(Billing,animated: true,completion: nil)
        default:
            return
        }
    }
    
    //プロフィールを表示
    @IBAction func myprofile(_ sender: Any) {
        let profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        HUD.show(.progress)
        profile.profileSetData()
        HUD.hide { _ in
            self.navigationController?.pushViewController(profile, animated: true)
        }
    }
}
