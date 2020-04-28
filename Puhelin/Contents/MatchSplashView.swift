//
//  MatchSplashView.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/28.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class MatchSplashView: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        label.alpha = 0
        UIView.animateKeyframes(withDuration: 2, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.9, animations: {
                self.label.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                self.dismiss(animated: true, completion: nil)
            })
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
}
