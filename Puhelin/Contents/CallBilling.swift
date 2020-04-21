//
//  CallBilling.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/07.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class CallBilling: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
