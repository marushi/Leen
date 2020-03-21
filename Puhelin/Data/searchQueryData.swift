//
//  searchQueryData.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/21.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class searchQueryData: NSObject {
    var prefecturs:[String]?
    var talk:String?
    var bodyType:String?
    var purpose:String?
    var age:Int?
    var tall:Int?
    
    override init() {
        self.prefecturs = []
        self.talk = "こだわらない"
        self.bodyType = "こだわらない"
        self.purpose = "こだわらない"
    }
}
