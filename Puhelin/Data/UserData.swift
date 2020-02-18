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
    
    init(document: QueryDocumentSnapshot) {
        self.uid = document.documentID
        let Dic = document.data()
        self.name = Dic["name"] as? String
        self.intro = Dic["intro"] as? String
        self.age = Dic ["age"] as? Int
        self.region = Dic["region"] as? String
    }
}
