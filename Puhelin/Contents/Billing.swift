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
        var goodpoint = UserDefaults.standard.integer(forKey: UserDefaultsData.GoodPoint)
            goodpoint += 1
            UserDefaults.standard.set(goodpoint, forKey: UserDefaultsData.GoodPoint)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        promoButton.layer.cornerRadius = promoButton.frame.size.height / 2
        promoButton.layer.borderColor = ColorData.salmon.cgColor
        promoButton.layer.borderWidth = 1
        
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAd?.load(GADRequest()) { error in
          if let error = error {
            // Handle ad failed to load case.
          } else {
            // Ad successfully loaded.
          }
        }
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
