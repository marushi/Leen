//
//  Billing.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/02.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import GoogleMobileAds

class Billing: UIViewController,GADRewardedAdDelegate {
    
    @IBOutlet weak var promoButton: UIButton!
    var rewardedAd: GADRewardedAd?
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        promoButton.layer.cornerRadius = promoButton.frame.size.height / 2
        promoButton.layer.borderColor = ColorData.salmon.cgColor
        promoButton.layer.borderWidth = 1
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    @IBAction func rewordPromotion(_ sender: Any) {
        if rewardedAd?.isReady == true {
           rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }
    

  
}
