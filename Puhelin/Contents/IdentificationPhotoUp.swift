//
//  IdentificationPhotoUp.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/17.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class IdentificationPhotoUp: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let titleTextArray = ["画像が不明瞭です。","書類が対象外の書類です。","生年月日が異なります。"]
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
        titleLabel.layer.borderColor = ColorData.salmon.cgColor
        titleLabel.layer.borderWidth = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let num = userDefaults.integer(forKey: UserDefaultsData.identification)
        setText(num - 3)
    }
    
    func setText(_ num:Int) {
        titleLabel.text = titleTextArray[num]
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
