//
//  UserDefaultsData.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/22.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsData:NSObject {
    static let remainGoodNum = "remainGoodNum"
    static let callLimit = "callLimit"
    static let goodLimit = "goodLimit"
    static let ticketNum = "recoveryTicket"
    static let matchingNum = "matchingTicket"
    static let identification = "identification"
    var myDB:String?
    var opDB:String?
    
    override init() {
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            self.myDB = Const.MalePath
            self.opDB = Const.FemalePath
        }else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            self.myDB = Const.FemalePath
            self.opDB = Const.MalePath
        }
    }
}
