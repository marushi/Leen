//
//  NGView.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/09.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class NGView: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var modoru: UIButton!
    @IBOutlet weak var vview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.backgroundColor = .init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        button.layer.cornerRadius = 10
        
        modoru.backgroundColor = .init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        modoru.layer.cornerRadius = 10
        
        vview.layer.cornerRadius = 10
    }
    
    @IBAction func Button(_ sender: Any) {
        let identification = self.storyboard?.instantiateViewController(identifier: "Identification") as! Identification
        present(identification,animated: true,completion: nil)
    }
    
    @IBAction func `return`(_ sender: Any) {
        let nav = self.presentingViewController as! UINavigationController
        nav.popViewController(animated: true)
        nav.dismiss(animated: false, completion: nil)
    }
    
}
