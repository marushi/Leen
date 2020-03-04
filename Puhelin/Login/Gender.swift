//
//  Gender.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SCLAlertView

class Gender: UIViewController{
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var gender:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
    }
    
    @IBAction func segmentedButton(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            gender = 0
        }
        if segmentedControl.selectedSegmentIndex == 1 {
            gender = 1
        }
        if segmentedControl.selectedSegmentIndex == 2 {
            gender = 2
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if gender == 0 {
            SCLAlertView().showInfo("性別を選択してください。", subTitle: "")
            return false
        }
        UserDefaults.standard.set(gender, forKey: "gender")
        return true
    }
    
}
