//
//  LoginTop.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/11.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import PKHUD
import Firebase

class LoginTop: UIViewController {

    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var button: UIButton!
    
    let userDefaults = UserDefaults.standard
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectLis :ListenerRegistration!
    var downLis :ListenerRegistration!
    var goodLis :ListenerRegistration!
    var footLis :ListenerRegistration!
    var recieveLis:ListenerRegistration!
    var userData:MyProfileData?
    var pageViewController:UIPageViewController!
    var controllers: [ UIViewController ] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPageViewController()
        self.setPageController()
        
        //部品
        button.layer.cornerRadius = button.frame.size.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        //ログインしている場合
        if self.userDefaults.string(forKey: "uid") != nil {
            HUD.show(.progress)
            let uid = self.userDefaults.string(forKey: "uid")
            //情報を取ってくる
            //女性かどうか
            let ref = Firestore.firestore().collection(Const.FemalePath).document(uid!)
            ref.getDocument(){(document,error) in
                if let error = error {
                    print(error)
                    return
                }
                self.userData = MyProfileData(document: document!)
                //男性かどうか
                if self.userData?.signupDate == nil {
                    let Ref = Firestore.firestore().collection(Const.MalePath).document(uid!)
                    Ref.getDocument(){(document2,error) in
                        if let error = error{
                            print(error)
                            return
                        }
                        self.userData = MyProfileData(document: document2!)
                        //男性の場合
                        self.userDefaults.set(1, forKey: "gender")
                        self.loginFunction()
                    }
                }else{
                    //女性の場合
                    self.userDefaults.set(2, forKey: "gender")
                    self.loginFunction()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func initPageViewController() {
       
        // 背景画像定義
        let view1 = self.storyboard?.instantiateViewController(identifier: "ViewController1") as! ViewController1
        let view2 = self.storyboard?.instantiateViewController(identifier: "ViewController2") as! ViewController2
        let view3 = self.storyboard?.instantiateViewController(identifier: "ViewController3") as! ViewController3
        self.controllers = [view1,view2,view3]
        // ③ UIPageViewController設定
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.setViewControllers([self.controllers[1]], direction: .forward, animated: true, completion: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        // ④既存ViewControllerに追加
        self.addChild(self.pageViewController)
        self.view.insertSubview(self.pageViewController.view!, at: 0)
    }
    
    func setPageController() {
        self.pageController.numberOfPages = self.controllers.count
        self.pageController.currentPage = 1
    }
    
    func loginFunction(){
        //情報　→ 無し
        if userData?.signupDate == nil {
            let NavigationController = self.storyboard?.instantiateViewController(identifier: "NavigationController")
            HUD.hide()
            self.present(NavigationController!,animated: true,completion: nil)
        
        }else {
            //データがある場合(過去にログイン済みの場合）
            //課金データと本人確認データをuserdefaultsに入れる
            //いいね数
            if let remaingood:Int = self.userData?.remainGoodNum{
                self.userDefaults.set(remaingood, forKey: UserDefaultsData.remainGoodNum)
            }
            //いいね制限
            if let goodLimit:Int = self.userData?.goodLimit{
                self.userDefaults.set(goodLimit, forKey: UserDefaultsData.goodLimit)
            }
            //マッチング券
            if let matchingTicket:Int = self.userData?.matchingTicket{
                self.userDefaults.set(matchingTicket, forKey: UserDefaultsData.matchingNum)
            }
            //回復券
            if let recoveryTicket:Int = self.userData?.recoveryTicket{
                self.userDefaults.set(recoveryTicket, forKey: UserDefaultsData.ticketNum)
            }
            //本人確認
            if let ident:Int = self.userData?.identification{
                self.userDefaults.set(ident, forKey: UserDefaultsData.identification)
            }
            //---データ用のスナップショットを登録する---
            //selectData
            if self.selectLis == nil {
                let selectRef = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(self.userDefaults.string(forKey: "uid")!).collection(Const.SelectUsers).order(by: "date",descending: true)
                self.selectLis = selectRef.addSnapshotListener() {(querysnapshot,error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    self.fromAppDelegate.selectUserData = (querysnapshot?.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let userData = FootUsers(document: document)
                    return userData
                })!
                let num = self.fromAppDelegate.selectUserData.count
                if num != 0 {
                    for i in 0...num - 1{
                    self.fromAppDelegate.selectIdArray.append(self.fromAppDelegate.selectUserData[i].uid!)
                
                    }
                    }
            //downData
            if self.downLis == nil {
                let downRef = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(self.userDefaults.string(forKey: "uid")!).collection(Const.DownUsers).order(by: "date",descending: true)
                self.downLis = downRef.addSnapshotListener() {(querysnapshot,error) in
                if let error = error {
                    print(error)
                    return
                    }
                    self.fromAppDelegate.downUserData = (querysnapshot?.documents.map { document in
                     
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let userData = FootUsers(document: document)
                        return userData
                        }
                        )!
                    let num = self.fromAppDelegate.downUserData.count
                    if num != 0 {
                        for i in 0...num - 1{
                            self.fromAppDelegate.downIdArray.append(self.fromAppDelegate.downUserData[i].uid!)
                        }
                    }
            //goodData
            if self.goodLis == nil {
            
                let goodRef = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(self.userDefaults.string(forKey: "uid")!).collection(Const.GoodPath).order(by: "date",descending: true)
                self.goodLis = goodRef.addSnapshotListener() {(querysnapshot,error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    self.fromAppDelegate.goodUserData = (querysnapshot?.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let userData = goodData(document: document)
                        return userData
                        }
                        )!
                    let num = self.fromAppDelegate.goodUserData.count
                    if num != 0 {
                        for i in 0...num - 1{
                            self.fromAppDelegate.goodIdArray.append(self.fromAppDelegate.goodUserData[i].uid!)
                        }
                    }
            //footData
            if self.footLis == nil {
            
                let footRef = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(self.userDefaults.string(forKey: "uid")!).collection(Const.FoorPrints).order(by: "date",descending: true)
                self.footLis = footRef.addSnapshotListener() {(querysnapshot,error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    self.fromAppDelegate.FootUserData = (querysnapshot?.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let userData = FootUsers(document: document)
                        return userData
                        }
                        )!
                    let num = self.fromAppDelegate.FootUserData.count
                    if num != 0 {
                        for i in 0...num - 1{
                            self.fromAppDelegate.footIdArray.append(self.fromAppDelegate.FootUserData[i].uid!)
                        }
                    }
                    if self.recieveLis == nil {
                    let recieveRef = Firestore.firestore().collection(UserDefaultsData.init().myDB!).document(self.userDefaults.string(forKey: "uid")!).collection(Const.ReceiveData).order(by: "date",descending: true)
                    self.recieveLis = recieveRef.addSnapshotListener() {(querysnapshot,error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        self.fromAppDelegate.receiveData = (querysnapshot?.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let userData = FootUsers(document: document)
                            return userData
                            }
                            )!
                        let num = self.fromAppDelegate.receiveData.count
                        if num != 0 {
                            for i in 0...num - 1{
                                self.fromAppDelegate.receiveIdArray.append(self.fromAppDelegate.FootUserData[i].uid!)
                            }
                        }
            //---^^^---
            //userDefaults保存処理
                    self.userDefaults.set(self.userData?.name, forKey: "name")
            let TabBarConrtroller = self.storyboard?.instantiateViewController(identifier: "TabBarConrtroller")
                    HUD.hide()
            self.present(TabBarConrtroller!,animated: false,completion: nil)
                    
                }
                    }
                }
                    }
                }
                    }
                }
            }
        }
    }
        }
    }
}

extension LoginTop:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    /// ページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }
    /// 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
           if let index = self.controllers.firstIndex(of: viewController),
               index < self.controllers.count - 1 {
               return self.controllers[index + 1]
           } else {
               return nil
           }
       }

    /// 右にスワイプ （戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
           if let index = self.controllers.firstIndex(of: viewController),
               index > 0 {
               return self.controllers[index - 1]
           } else {
               return nil
           }
       }
    // ④ アニメーション終了後処理 追加
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPage = pageViewController.viewControllers![0]
        self.pageController.currentPage = self.controllers.firstIndex(of: currentPage)!
    }
    
    
}
