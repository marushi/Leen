//
//  Talk.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/12.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import SCLAlertView
import XLPagerTabStrip

class Talk:ButtonBarPagerTabStripViewController{
    
   
    override func viewDidLoad() {
        //バーの色
        settings.style.buttonBarBackgroundColor = .white
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        //セルの文字色
        settings.style.buttonBarItemTitleColor = .darkGray
        // タブの文字サイズ
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 15)
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = ColorData.darkturquoise
        //バーの高さ
        settings.style.selectedBarHeight = 3
        /*settings.style.buttonBarLeftContentInset = 30
        settings.style.buttonBarRightContentInset = 30
        settings.style.buttonBarMinimumLineSpacing = 60*/
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First") as! talk_before
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second") as! talk_after
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }
}

