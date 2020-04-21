//
//  TabBarConrtroller.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/13.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class TabBarConrtroller: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = ColorData.darkturquoise
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
