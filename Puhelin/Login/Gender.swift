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
    @IBOutlet weak var titleLabel: UILabel!
    
    var gender:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 1
        
    }
    
    @IBAction func segmentedButton(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            gender = 1
        }
        if segmentedControl.selectedSegmentIndex == 1 {
            gender = 2
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if gender != 1 && gender != 2 {
            SCLAlertView().showInfo("性別を選択してください。", subTitle: "")
            return false
        }
        UserDefaults.standard.set(gender, forKey: "gender")
        return true
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
