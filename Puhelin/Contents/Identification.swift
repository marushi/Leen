//
//  Identification.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/02.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class Identification: UIViewController{
    
    @IBOutlet weak var selectButton1: UIButton!
    @IBOutlet weak var selectButton2: UIButton!
    @IBOutlet weak var selectButton3: UIButton!
    @IBOutlet weak var selectButton4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton1.layer.cornerRadius = selectButton1.frame.height / 2
        selectButton2.layer.cornerRadius = selectButton2.frame.height / 2
        selectButton3.layer.cornerRadius = selectButton3.frame.height / 2
        selectButton4.layer.cornerRadius = selectButton4.frame.height / 2
        
        let buttonWidth = self.view.frame.size.width - 120
        selectButton1.contentHorizontalAlignment = .left
        selectButton1.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: buttonWidth - 40, bottom: 0, right: 0)
        selectButton1.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: (buttonWidth / 2) - 55, bottom: 0, right: 0)
        selectButton2.contentHorizontalAlignment = .left
        selectButton2.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: buttonWidth - 40, bottom: 0, right: 0)
        selectButton2.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: (buttonWidth / 2) - 55, bottom: 0, right: 0)
        selectButton3.contentHorizontalAlignment = .left
        selectButton3.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: buttonWidth - 40, bottom: 0, right: 0)
        selectButton3.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: (buttonWidth / 2) - 55, bottom: 0, right: 0)
        selectButton4.contentHorizontalAlignment = .left
        selectButton4.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: buttonWidth - 40, bottom: 0, right: 0)
        selectButton4.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: (buttonWidth / 2) - 55, bottom: 0, right: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @IBAction func movetophoto(_ sender: Any) {
        let up = self.storyboard?.instantiateViewController(identifier: "IdentificationPhotoUp") as! IdentificationPhotoUp
        self.navigationController?.pushViewController(up, animated: true)
    }
    
    
    @IBAction func modoru(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
}
