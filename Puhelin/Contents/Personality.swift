//
//  Personality.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/03/02.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase

class Personality: UIViewController {

    @IBOutlet weak var segment1: UISegmentedControl!
    @IBOutlet weak var segment2: UISegmentedControl!
    @IBOutlet weak var segment3: UISegmentedControl!
    
    //DB用の変数設定
    var personal1 = 10
    var personal2 = 20
    var personal3 = 30
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let personalArray = userDefaults.array(forKey: "personality") as? [Int]
        if personalArray == nil {
            segment1.selectedSegmentIndex = 10
            segment2.selectedSegmentIndex = 20
            segment3.selectedSegmentIndex = 30
        }else{
            segment1.selectedSegmentIndex = personalArray![0] - 10
            segment2.selectedSegmentIndex = personalArray![1] - 20
            segment3.selectedSegmentIndex = personalArray![2] - 30
            personal1 = personalArray![0]
            personal2 = personalArray![1]
            personal3 = personalArray![2]
        }
    }
    
    //話す時の立ち位置
    @IBAction func segment1(_ sender: Any) {
        if segment1.selectedSegmentIndex == 0{
            self.personal1 = 10
        }
        if segment1.selectedSegmentIndex == 1{
            self.personal1 = 11
        }
        if segment1.selectedSegmentIndex == 2{
            self.personal1 = 12
        }
    }
    
    @IBAction func segment2(_ sender: Any) {
        if segment2.selectedSegmentIndex == 0{
            self.personal2 = 20
        }
        if segment2.selectedSegmentIndex == 1{
            self.personal2 = 21
        }
        if segment2.selectedSegmentIndex == 2{
            self.personal2 = 22
        }
    }
    
    @IBAction func segment3(_ sender: Any) {
        if segment3.selectedSegmentIndex == 0{
            self.personal3 = 30
        }
        if segment3.selectedSegmentIndex == 1{
            self.personal3 = 31
        }
        if segment3.selectedSegmentIndex == 2{
            self.personal3 = 32
        }
    }
    
    @IBAction func registButton(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        let ref = Firestore.firestore()
        var DB = ""
        if userDefaults.integer(forKey: "gender") == 1 {
            DB = Const.MalePath
        } else {
            DB = Const.FemalePath
        }
        
        let userRef = ref.collection(DB).document(userDefaults.string(forKey: "uid")!)
        let dic = ["personality": [personal1,personal2,personal3]]
        userDefaults.set([personal1,personal2,personal3], forKey: "personality")
        userRef.setData(dic,merge: true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
