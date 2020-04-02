//
//  InformationData.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/30.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class InformationData: NSObject{
    var infoId: String?
    var title:String?
    var content:String?
    var date:Timestamp?
    
    init(document: QueryDocumentSnapshot) {
        self.infoId = document.documentID
        let Dic = document.data()
        self.title = Dic["title"] as? String
        self.content = Dic["content"] as? String
        self.date = Dic["date"] as? Timestamp
    }
}
