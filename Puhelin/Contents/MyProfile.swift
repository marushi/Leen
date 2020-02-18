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
    
    @IBOutlet weak var tableView0: UITableView!
    @IBOutlet weak var tableView1: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //テーブルビューの設定
        tableView0.delegate = self
        tableView0.dataSource = self
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView0.isScrollEnabled = false
        tableView1.isScrollEnabled = false
        tableView0.rowHeight = 50
        tableView0.allowsSelection = false
        
        //セルの登録
        let nib_1 = UINib(nibName: "MyProfileCell_2", bundle: nil)
        tableView1.register(nib_1, forCellReuseIdentifier: "MyProfileCell_2")
        
        
        //背景色
        self.view.backgroundColor = .brown
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView0.reloadData()
        
        // 画像の表示
               
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(UserDefaults.standard.string(forKey: "uid")! + ".jpg")
        photo.sd_setImage(with: imageRef)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num:Int = 0
        if tableView.tag == 0 {
            num = 3
        }else if tableView.tag == 1 {
            num = 5
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MyProfileCell_1 = tableView0.dequeueReusableCell(withIdentifier: "MyProfileCell_1", for: indexPath) as! dayCell
        let MyProfileCell_2 = tableView1.dequeueReusableCell(withIdentifier: "MyProfileCell_2", for: indexPath)
        var cell:UITableViewCell = MyProfileCell_1
        
        if tableView.tag == 0 {
            let day = UserDefaults.standard.string(forKey: "callday_\(indexPath.row)")
            if day == nil {
                MyProfileCell_1.dayLabel.text = "設定なし"
            }
            MyProfileCell_1.dayLabel.text = day
            // セル内のボタンのアクションをソースコードで設定する
            MyProfileCell_1.button.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
            cell = MyProfileCell_1
        }else if tableView.tag == 1 {
            cell = MyProfileCell_2
        }
        
        
        
        return cell
    }
    
   @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {

   // タップされたセルのインデックスを求める
   let touch = event.allTouches?.first
   let point = touch!.location(in: self.tableView0)
   let indexPath = tableView0.indexPathForRow(at: point)
    
    let datePicker = self.storyboard?.instantiateViewController(identifier: "DatePicker") as! DatePicker
    datePicker.num = indexPath!.row
    present(datePicker,animated: true,completion: nil)
    
    }
}
