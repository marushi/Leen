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
import SCLAlertView

class AfterVideoCall: UIViewController {
    
    //部品
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var selector: UISegmentedControl!
    @IBOutlet weak var OKbutton: UIButton!
    @IBOutlet weak var remainNum: UILabel!
    
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
        selector.layer.cornerRadius = 20
        OKbutton.layer.cornerRadius = OKbutton.frame.size.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //マッチング券の残り枚数
        let num = userDefaults.integer(forKey: UserDefaultsData.matchingNum)
        remainNum.text = "×" + String(num) + "枚"
        
        photo.image = topImage
        let ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(opid!)
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
        //アラート1
        let appearance1 = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView1 = SCLAlertView(appearance: appearance1)
            alertView1.addButton("申請する") {
                let num = self.userDefaults.integer(forKey: UserDefaultsData.matchingNum)
                if num <= 0 {
                    SCLAlertView().showSuccess("マッチング券がありません。", subTitle: "")
                    return
                }
                //探す画面に戻る
                let ref = Firestore.firestore().collection(Const.ChatPath).document(self.roomName!)
                let selfData = self.userDefaults.integer(forKey: "gender") + 2
                let dic = ["\(selfData)": true]
                ref.setData(dic, merge: true)
                self.dismiss(animated: true, completion: nil)
            }
            alertView1.addButton("戻る",backgroundColor: .lightGray,textColor: .black) {
                return
            }
        //アラート2
        let appearance2 = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView2 = SCLAlertView(appearance: appearance2)
        alertView2.addButton("今回は見送る") {
            //探す画面に戻る
            self.dismiss(animated: true, completion: nil)
        }
        alertView2.addButton("戻る",backgroundColor: .lightGray,textColor: .black) {
            return
        }
        
        //処理
        if selectorNum == 0 {
            alertView1.showSuccess("マッチングを申請します。", subTitle: "マッチングが成立した場合、マッチング券を1枚消費します。よろしいですか？")
        }else{
            alertView2.showSuccess("マッチングを見送ります。", subTitle: "選択し直すにはもう一度通話する必要があります。よろしいですか？")
        }
    }
    
}
