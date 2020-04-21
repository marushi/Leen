//
//  Goodhistory.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/08.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class Goodhistory: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentButton: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!
    
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let sectionInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 2
    
    var collectionMode:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchCell", bundle: nil), forCellWithReuseIdentifier: "SearchCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.textView.isHidden = true
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentAction(_ sender: Any) {
        if segmentButton.selectedSegmentIndex == 0 {
            self.collectionMode = 0
            self.collectionView.reloadData()
            self.textView.isHidden = true
        }
        if segmentButton.selectedSegmentIndex == 1{
            self.collectionMode = 1
            self.collectionView.reloadData()
            if fromAppDelegate.downIdArray.count == 0 {
                self.textView.isHidden = false
            }
        }
    }
    
    
}

extension Goodhistory:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionMode == 0 {
            return fromAppDelegate.selectIdArray.count
        }else{
            return fromAppDelegate.downIdArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        if collectionMode == 0 {
            cell.setData(fromAppDelegate.selectIdArray[indexPath.row])
        }else{
            cell.setData(fromAppDelegate.downIdArray[indexPath.row])
        }
        cell.layer.cornerRadius = cell.frame.size.width * 0.1
        let selectedBGView = UIView(frame: cell.frame)
        selectedBGView.backgroundColor = ColorData.whitesmoke
        cell.selectedBackgroundView = selectedBGView
        return cell
    }

    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width  - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 250)
        }
        
    // セルの行間の設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
        
    //セルを選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        if self.collectionMode == 0 {
            Profile.setData(fromAppDelegate.selectIdArray[indexPath.row])
        }
        if self.collectionMode == 1 {
            Profile.setData(fromAppDelegate.downIdArray[indexPath.row])
        }
        Profile.ButtonMode = 1
        Profile.modalTransitionStyle = .crossDissolve
        present(Profile,animated: true,completion: nil)
    }
}

    
    
    

