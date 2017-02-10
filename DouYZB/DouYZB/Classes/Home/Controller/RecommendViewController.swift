//
//  RecommendViewController.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/4.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kItemW = (kScreenWidth - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3
private let kHeaderViewH : CGFloat = 50

private let kCycleViewH = kScreenWidth * 3 / 8
private let kGameViewH : CGFloat = 90

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"

class RecommendViewController: UIViewController {
    
    //MARK:- 懒加载属性
    fileprivate lazy var recommendVM = RecommendViewModel()
    
    fileprivate lazy var cycleView : RecommendCycleView = {
        
       let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH - kGameViewH, width: kScreenWidth, height: kCycleViewH)
        
        return cycleView
    }()
    fileprivate lazy var gameView : RecommendGameView = {
       
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenWidth, height: kGameViewH)
        
        return gameView
        
    }()
    
    fileprivate lazy var collectionView : UICollectionView = {[unowned self] in
        //1.创建布局
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin, 0, kItemMargin)
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: kHeaderViewH)
        
        //2.创建UICollectionVi
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        
        collectionView.register(UINib(nibName: "HomeCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        
        return collectionView
    }()
    
    //MARK:- 系统回调函数
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1. 设置UI界面
        setupUI()
        
        //2. 请求数据
        loadData()
        
    }
    

}

//MARK:- 请求数据
extension RecommendViewController {
    fileprivate func loadData() {
        
        //请求推荐数据
        recommendVM.requestData { 
            self.collectionView.reloadData()
            
            //将数据传递给gameView
            self.gameView.groups = self.recommendVM.anchorGroups
        }
        
        //请求轮播数据
        recommendVM.requestCycleData {
            self.cycleView.cycleModels = self.recommendVM.cycleModel
        }
    }
}

//MARK:- 设置UI界面
extension RecommendViewController {
    
    fileprivate func setupUI(){
        view.addSubview(collectionView)
        
        collectionView.addSubview(cycleView)
        collectionView.addSubview(gameView)
        
        //设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsetsMake(kCycleViewH + kGameViewH, 0, 0, 0)
    }
    
    
    
}

//MARK:- 遵守UICollectionViewDataSource

extension RecommendViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let group = recommendVM.anchorGroups[section]
        
        return group.anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //0. 取出模型
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchors = group.anchors[indexPath.item]
        
        //1. 定义cell
        var cell : CollectionBaseCell!
        
        //2. 取出cell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
        }
        else {
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        }
        
        //3. 将模型赋值给cell
        cell.anchor = anchors
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1. 取出sectionHeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! HomeCollectionHeaderView
        
        //2. 取出模型
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        
        
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kItemW, height: kNormalItemH)
    }
    
}

