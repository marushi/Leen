//
//  UserData.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class UserData: NSObject {
    var uid: String
    var name: String?
    var intro: String?
    var age: Int?
    var region: String?
    var photoId: String?
    var sentenceMessage: String?
    var tall: Int?
    var bodyType: String?
    var purpose: String?
    var talk: String?
    var identification: Bool?
    var signupDate: Timestamp?
    var LoginDate: Timestamp?
    var tabako: String?
    var alchoal: String?
    var job: String?
    var income: String?
    var personality: String?
    var hobby: String?
    var token: String?
    var tallClass: String?
    var birthYear: Int?
    var birthMonth: Int?
    var birthDay: Int?
    
    init(document: QueryDocumentSnapshot) {
        self.uid = document.documentID
        let Dic = document.data()
        self.name = Dic["name"] as? String
        self.intro = Dic["intro"] as? String
        self.age = Dic ["age"] as? Int
        self.region = Dic["region"] as? String
        self.photoId = Dic["photoId"] as? String
        self.sentenceMessage = Dic["sentenceMessage"] as? String
        self.talk = Dic["talk"] as? String
        self.purpose = Dic["purpose"] as? String
        self.bodyType = Dic["bodyType"] as? String
        self.tall = Dic["tall"] as? Int
        self.identification = Dic["identification"] as? Bool
        self.signupDate = Dic["signupDate"] as? Timestamp
        self.LoginDate = Dic["LoginDate"] as? Timestamp
        self.tabako = Dic["tabako"] as? String
        self.alchoal = Dic["alchoal"] as? String
        self.job = Dic["job"] as? String
        self.income = Dic["income"] as? String
        self.personality = Dic["personality"] as? String
        self.hobby = Dic["hobby"] as? String
        self.token = Dic["token"] as? String
        self.tallClass = Dic["tallClass"] as? String
        self.birthYear = Dic["birthYear"] as? Int
        self.birthMonth = Dic["birthMonth"] as? Int
        self.birthDay = Dic["birthDay"] as? Int
    }
}
