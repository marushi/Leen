//
//  SearchNavigationController.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/05/07.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class SearchNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
    }
}
