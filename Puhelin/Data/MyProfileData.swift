//
//  UserData.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class MyProfileData: NSObject {
    var uid: String
    var name: String?
    var intro: String?
    var age: Int?
    var region: String?
    var photoId: String?
    var sentenceMessage: String?
    var identification: Bool?
    var signupDate: Date?
    var tall: Int?
    var bodyType: String?
    var purpose: String?
    var talk: String?
    var tabako: String?
    var alchoal: String?
    var job: String?
    var income: String?
    var personality: String?
    var hobby: String?
    var token:String?
    
    init(document: DocumentSnapshot) {
        self.uid = document.documentID
        self.name = document.get("name") as? String
        self.intro = document.get("intro") as? String
        self.age = document.get("age") as? Int
        self.region = document.get("region") as? String
        self.photoId = document.get("photoId") as? String
        self.sentenceMessage = document.get("sentenceMessage") as? String
        self.identification = document.get("identification") as? Bool
        self.signupDate = document.get("signupDate") as? Date
        self.tall = document.get("tall") as? Int
        self.bodyType = document.get("bodyType") as? String
        self.purpose = document.get("purpose") as? String
        self.talk = document.get("talk") as? String
        self.tabako = document.get("tabako") as? String
        self.alchoal = document.get("alchoal") as? String
        self.job = document.get("job") as? String
        self.income = document.get("income") as? String
        self.personality = document.get("personality") as? String
        self.hobby = document.get("hobby") as? String
        self.token = document.get("token") as? String
    }
}

