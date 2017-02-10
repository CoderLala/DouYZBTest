//
//  RecommendCycleView.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/8.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

private let kCycleCellID = "kCycleCellID"

class RecommendCycleView: UIView {
    
    //定义属性
    var cycleTiemr : Timer?
    var cycleModels : [CycleModel]? {
        didSet {
            
            //1. 刷新collectionView
            collectionView.reloadData()
            
            //2. 设置pageControl的个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            //3. 默认滚动到中间某一个位置
            let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * 1000, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            //4.添加定时器
            removeCycleTimer()
            addCycleTiemr()
        }
    }

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置该控件 不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        
        //注册 cell
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        
        
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    

}


//MARK:- 提供一个快速创建View的方法
extension RecommendCycleView {
    
    class func recommendCycleView() -> RecommendCycleView {
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
    
}

//MARK:- collectionView datasource
extension RecommendCycleView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
        
        cell.cycleModel = cycleModels![(indexPath as NSIndexPath).item % cycleModels!.count]
        
        
        return cell
    }
}

//MARK:- collectionView delegate
extension RecommendCycleView : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //1. 获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        //2. 计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //当用户将要拖拽时 移除监听
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //当用户停止拖拽时 添加监听
        addCycleTiemr()
    }
    
}

//MARK:- 对定时器的操作方法
extension RecommendCycleView {
    
    fileprivate func addCycleTiemr() {
        cycleTiemr = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        
        RunLoop.main.add(cycleTiemr!, forMode: .commonModes)
    }
    
    fileprivate func removeCycleTimer() {
        //从运行循环中移除
        cycleTiemr?.invalidate()
        cycleTiemr = nil
    }
    
    @objc func scrollToNext() {
        
        //1. 获取当前偏移量、 获取下一个滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let nextOffsetX = currentOffsetX + collectionView.bounds.width
        
        //2. 滚动该位置
        collectionView.setContentOffset(CGPoint(x: nextOffsetX, y: 0), animated: true)
    }
}
