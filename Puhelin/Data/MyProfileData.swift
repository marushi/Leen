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
    var personality0: [String]?
    var personality1: [String]?
    var personality2: [String]?
    
    init(document: DocumentSnapshot) {
        self.uid = document.documentID
        self.name = document.get("name") as? String
        self.intro = document.get("intro") as? String
        self.age = document.get("age") as? Int
        self.region = document.get("region") as? String
        self.photoId = document.get("photoId") as? String
        self.sentenceMessage = document.get("sentenceMessage") as? String
        self.personality0 = document.get("Personality.0") as? [String]
        self.personality1 = document.get("Personality.1") as? [String]
        self.personality2 = document.get("Personality.2") as? [String]
        
        
    }
}

