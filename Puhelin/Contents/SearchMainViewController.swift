//
//  SearchMainViewController.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/05/06.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit

class SearchMainViewController:UIViewController {

    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let titleArray = ["おすすめ","ログイン順","新ユーザー"]
    let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0 , right: 0)
    let itemsPerRow: CGFloat = 15
    
    var pageViewController:UIPageViewController!
    var controllers:[UIViewController] = []
    var pageTabItemsWidth:CGFloat! = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageViewController()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        //コレクションセルを登録
        collectionView.register(UINib(nibName: "BarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BarCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func initPageViewController() {
       
        // 背景画像定義
        let view1 = self.storyboard?.instantiateViewController(identifier: "Recomend") as! RecomendViewController
        let view2 = self.storyboard?.instantiateViewController(identifier: "Login") as! LoginOrderViewController
        let view3 = self.storyboard?.instantiateViewController(identifier: "New") as! NewMemberViewController
        self.controllers = [view1,view2,view3]
        // ③ UIPageViewController設定
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        // ④既存ViewControllerに追加
        self.addChild(self.pageViewController)
        self.pageView.insertSubview(self.pageViewController.view!, at: 0)
    }
}

extension SearchMainViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    /// ページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }
    /// 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
           return nextViewController(viewController: viewController, isAfter: true)
       }

    /// 右にスワイプ （戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
           return nextViewController(viewController: viewController, isAfter: false)
       }
    private func nextViewController(viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        guard var index = self.controllers.firstIndex(of: viewController) else { return nil }
        index = isAfter ? (index + 1) : (index - 1)

        if index < 0 {
            index = self.controllers.count - 1
        } else if index == self.controllers.count {
            index = 0
        }
        if index >= 0 && index < self.controllers.count {
            return self.controllers[index]
        }
        return nil
    }
}

extension SearchMainViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count * 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarCollectionViewCell", for: indexPath) as! BarCollectionViewCell
        let num = indexPath.row % titleArray.count
        cell.setTitle(self.titleArray[num])
        return cell
    }
    // Screenサイズに応じたセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 30)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if pageTabItemsWidth == 0.0 {
            pageTabItemsWidth = floor(scrollView.contentSize.width / 5.0) // 表示したい要素群のwidthを計算
        }

        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > pageTabItemsWidth * 2.0) { // スクロールした位置がしきい値を超えたら中央に戻す
            scrollView.contentOffset.x = pageTabItemsWidth
        }
    }
}
