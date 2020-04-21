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
    static let PuhelinPoint = "PuhelinPoint"
    static let GoodPoint = "GoodPoint"
    static let uid = "uid"
    static let name = "name"
    static let gender = "gender"
    static let remainGoodNum = "remainGoodNum"
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
