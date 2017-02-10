//
//  PageContentView.swift
//  DouYZB
//
//  Created by 黄金英 on 17/1/26.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(_ contentView: PageContentView, progress : CGFloat, sourceIndex: Int, targetIndex: Int)
}

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    //MARK:- 定义属性
    fileprivate var childVCs : [UIViewController]
    fileprivate weak var parentViewController : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidScrollDelegate = false
    
    weak var delegate : PageContentViewDelegate?
    
    //MARK:- 懒加载属性
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in//swift 中 避免闭包循环引用 使用weakSelf 的写法：在闭包前写上 [weak self] in
      
        //1. 创建layout
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = (self?.bounds.size)!
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = .horizontal
        
        //1. 创建 collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        //注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    

    //MARK:- 自定义构造函数
    init(frame: CGRect, childVCs: [UIViewController], parentViewController: UIViewController?) {
        self.childVCs = childVCs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

//MARK:- 设置UI界面
extension PageContentView{
    
    fileprivate func setupUI(){
        //1. 将我们的所有子控制器 添加到父控制器中
        for childVc in childVCs{
            parentViewController?.addChildViewController(childVc)
        }
        
        //2. 添加UICollectionView 用于在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//MARK:- UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //1. 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        //2. 给cell 设置内容
        for view in cell.contentView.subviews {//防止循环引用时多次添加 所以将子控件view移除
            view.removeFromSuperview()
        }
        
        let childVc = childVCs[(indexPath as NSIndexPath).item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
        
    }
}

//MARK:- UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0. 判断是否是点击事件
        if isForbidScrollDelegate {return}
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK:- 对外暴露的方法
extension PageContentView {
    func setCurrentIndex(_ currentIndex: Int) {
//        print("setCurrentIndex")
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
