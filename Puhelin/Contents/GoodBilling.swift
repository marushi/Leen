//
//  GoodBilling.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/05.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class GoodBilling: UIViewController {

    //いいねアンリミット
    @IBOutlet weak var titleLabel: UILabel!
    //お手軽プラン
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var standardView: UIView!
    @IBOutlet weak var infinityView: UIView!
    @IBOutlet weak var comingView: UIView!
    @IBOutlet weak var adView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.clipsToBounds = false
        infinityView.layer.cornerRadius = 30
        comingView.layer.cornerRadius = 30
        standardView.layer.cornerRadius = 30
        adView.layer.cornerRadius = 30
        standardView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        standardView.layer.shadowColor = UIColor.black.cgColor
        standardView.layer.shadowOpacity = 0.6
        standardView.layer.shadowRadius = 2
        adView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        adView.layer.shadowColor = UIColor.black.cgColor
        adView.layer.shadowOpacity = 0.6
        adView.layer.shadowRadius = 2
        view1.layer.cornerRadius = 75
        upLabel.layer.cornerRadius = upLabel.frame.size.height / 2
        upLabel.clipsToBounds = true
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
