//
//  SearchCell.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SearchCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var sentenceMes: UITextView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var identLabel: UILabel!
    @IBOutlet weak var phoneimage: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var region: UILabel!
    
    let hokkaidou = ["北海道"]
    let touhoku = ["青森県", "岩手県", "宮城県", "秋田県",
    "山形県", "福島県"]
    let kantou = ["茨城県", "栃木県", "群馬県",
    "埼玉県", "千葉県", "東京都", "神奈川県"]
    let chubu = ["新潟県",
    "富山県", "石川県", "福井県", "山梨県", "長野県",
    "岐阜県", "静岡県", "愛知県"]
    let kinki = ["三重県", "滋賀県",
    "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県"]
    let chugoku = ["鳥取県", "島根県", "岡山県", "広島県", "山口県"]
    let shikoku = ["徳島県", "香川県", "愛媛県", "高知県"]
    let kyushu = ["福岡県",
    "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
    "鹿児島県"]
    let okinawa = ["沖縄県"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //アウトレットの設定
        photo.layer.cornerRadius = 10
        photo.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        sentenceMes.textContainerInset = UIEdgeInsets.zero
        sentenceMes.textContainer.lineFragmentPadding = 0
        sentenceMes.isUserInteractionEnabled = false
        dateLabel.backgroundColor = .red
        dateLabel.layer.cornerRadius = 10
        dateLabel.clipsToBounds = true
        dateLabel.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        identLabel.clipsToBounds = true
        identLabel.layer.cornerRadius = 10
        identLabel.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
        identLabel.isHidden = true
        phoneLabel.isHidden = true
        phoneimage.isHidden = true
        view.backgroundColor = ColorData.snow
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        sentenceMes.backgroundColor = ColorData.snow
    }
    
    //データセット
    func setData(_ userid: String) {
        
        //相手の情報を検索
        let ref = Firestore.firestore().collection(UserDefaultsData.init().opDB!).document(userid)
        ref.getDocument() {(data,error) in
            if let error = error {
                print(error)
                return
            }
            let userData = MyProfileData(document: data!)
            // 画像の表示
            //自分の情報を設定
            if userData.photoId != "" && userData.photoId != nil{
                self.photo.contentMode = .scaleAspectFill
                let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userData.photoId!)
                self.photo.sd_setImage(with: imageRef)
            }else{
                self.photo.contentMode = .scaleAspectFit
                if UserDefaults.standard.integer(forKey: "gender") == 2 {
                    self.photo.image = UIImage(named: "male")
                }else{
                    self.photo.image = UIImage(named: "female")
                }
                
            }
            
            //その他データ
            if userData.name != nil {
                self.age.text = "\(userData.name!)"
            }
            if userData.age != nil {
                self.regionLabel.text = "\(userData.age!)" + "歳"
            }
            if let region = userData.region {
                self.region.text = region
            }
            /*if let region = userData.region {
                if self.hokkaidou.contains(region) {
                    self.region.text = "北海道"
                }
                if self.touhoku.contains(region) {
                    self.region.text = "東北"
                }
                if self.kantou.contains(region) {
                    self.region.text = "関東"
                }
                if self.chubu.contains(region) {
                    self.region.text = "中部"
                }
                if self.kinki.contains(region) {
                    self.region.text = "近畿"
                }
                if self.chugoku.contains(region) {
                    self.region.text = "中国"
                }
                if self.shikoku.contains(region) {
                    self.region.text = "四国"
                }
                if self.kyushu.contains(region) {
                    self.region.text = "九州"
                }
                if self.okinawa.contains(region) {
                    self.region.text = "沖縄"
                }
            }*/
            if userData.sentenceMessage != nil {
                self.sentenceMes.text = userData.sentenceMessage
            }
            
            //本人確認済みかどうか
            if userData.identification == true {
                self.identLabel.isHidden = false
                self.phoneimage.isHidden = false
                self.phoneLabel.isHidden = false
            } else {
                self.identLabel.isHidden = true
                self.phoneimage.isHidden = true
                self.phoneLabel.isHidden = true
            }
            
            //一週間以内かどうか
            if userData.signupDate != nil{
                let weekAgo = Date(timeIntervalSinceNow: -60*60*24*4)
                let signupDate: Date = userData.signupDate!.dateValue()
                if signupDate < weekAgo {
                    self.dateLabel.isHidden = true
                }else{
                    self.dateLabel.isHidden = false
                }
            }else{
                self.dateLabel.isHidden = true
            }
        }
        
        
        
    }

}
