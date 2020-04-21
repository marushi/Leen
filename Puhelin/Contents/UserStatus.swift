//
//  UserStatus.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/02.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class UserStatus: UIViewController {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    let userDefaults = UserDefaults.standard
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.layer.cornerRadius = 10
        collectionview.layer.borderWidth = 1
        collectionview.layer.borderColor = UIColor.lightGray.cgColor
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
    
    //通話有料プラン
    @IBAction func callPlan(_ sender: Any) {
        let CallBilling = self.storyboard?.instantiateViewController(identifier: "CallBilling") as! CallBilling
        self.navigationController?.pushViewController(CallBilling, animated: true)
    }
    
    //いいねプラン
    @IBAction func goodPlan(_ sender: Any) {
        let GoodBilling = self.storyboard?.instantiateViewController(identifier: "GoodBilling") as! GoodBilling
        self.navigationController?.pushViewController(GoodBilling, animated: true)
    }
    
    
}

extension UserStatus:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statusCell", for: indexPath) as! StatusCell
        cell.setUp(row: indexPath.row, section: indexPath.section)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = collectionView.frame.width  - paddingSpace
            let widthPerItem = availableWidth / 3
            return CGSize(width: widthPerItem , height: collectionView.frame.height / 3)
        }else{
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = collectionView.frame.width  - paddingSpace
            let widthPerItem = availableWidth * 2 / 3
            return CGSize(width: widthPerItem, height: collectionView.frame.height / 3)
        }
        
    }
    
    
}
