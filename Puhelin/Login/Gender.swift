//
//  Gender.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class Gender: UIViewController {

    var gender:Int = 0
    @IBOutlet weak var ManButton: UIButton!
    @IBOutlet weak var WomanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Man(_ sender: Any) {
        gender = 1
    }
    
    @IBAction func Woman(_ sender: Any) {
        gender = 2
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if gender == 0 {
            return false
        }
        UserDefaults.standard.set(gender, forKey: "gender")
        return true
    }
    
}
