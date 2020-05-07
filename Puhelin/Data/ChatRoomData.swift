//
//  ChatRoomData.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/19.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomData: NSObject {

    var roomId: String?
    var female: String?
    var male: String?
    var name1:String?
    var name2:String?
    var LastRefreshTime:Timestamp?
    var LastRefreshMessage:String?
    
    
    init(document: QueryDocumentSnapshot) {
        self.roomId = document.documentID
        let Dic = document.data()
        self.female = Dic["2"] as? String
        self.male = Dic["1"] as? String
        self.name1 = Dic["name1"] as? String
        self.name2 = Dic["name2"] as? String
        self.LastRefreshTime = Dic["LastRefreshTime"] as? Timestamp
        self.LastRefreshMessage = Dic["LastRefreshMessage"] as? String
    }
}
