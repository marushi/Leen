//
//  NGView.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/09.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SCLAlertView

class NGView: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var modoru: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var vview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.backgroundColor = .init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        button.layer.cornerRadius = button.frame.size.height / 2
        modoru.backgroundColor = .init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        modoru.layer.cornerRadius = modoru.frame.size.height / 2
        textView.isEditable = false
        textView.backgroundColor = .white
        vview.layer.cornerRadius = 10
    }
    
    @IBAction func Button(_ sender: Any) {
        if UserDefaults.standard.integer(forKey: UserDefaultsData.identification) == 1 {
            SCLAlertView().showInfo("現在承認中です。", subTitle: "承認には1〜2日かかる場合があります。")
        }else{
            let identification = self.storyboard?.instantiateViewController(identifier: "Identification") as! Identification
            let nav = UINavigationController(rootViewController: identification)
            present(nav,animated: true,completion: nil)
        }
    }
    
    @IBAction func `return`(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
