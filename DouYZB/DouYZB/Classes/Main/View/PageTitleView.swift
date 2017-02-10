//
//  PageTitleView.swift
//  DouYZB
//
//  Created by 黄金英 on 17/1/26.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class {
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
}

// MARK:- 颜色定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    
    //MARK:- 定义属性
    fileprivate var currentIndex : Int = 0
    fileprivate var titles: [String]
    weak var delegate : PageTitleViewDelegate?
    
    
    //MARK:- 懒加载
    fileprivate var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
       
        let scrollView = UIScrollView()
        
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    fileprivate lazy var scrollLine : UIView = {
        
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        
        return scrollLine
    }()
    

    //MARK:- 自定义构造函数
    //(重写 或者 自定义构造函数 的话 需要重写方法： required init?(coder aDecoder: NSCoder)
    init(frame: CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:- PageTitleView 的初始界面布局
extension PageTitleView{
    
    fileprivate func setupUI(){
        //1. 添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2. 添加title 对应的label
        setupTitleLabels()
        
        //3. 设置底线 和 底部滚动条
        setupBottoLineAndScrollLine()
    }
    
    //2. 添加title 对应的label
    fileprivate func setupTitleLabels(){
        
        // 0.确定label的一些frame的值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated(){
            //1. 创建UILabel
            let label = UILabel()
            
            //2. 设置UILabel 的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //3. 设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //4. 将label 添加到 scrollView
            scrollView.addSubview(label)
            
            titleLabels.append(label)
            
            //5. 添加手势
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGesture)

        }
    }
    
    //3. 设置底线 和 底部滚动条
    fileprivate func setupBottoLineAndScrollLine(){
        
        //3.1 设置底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        
        let lineHeight : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineHeight, width: frame.width, height: lineHeight)
     
        addSubview(bottomLine)
    
        //3.2 底部滚动条
        //3.2.1 获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        
    }
    
}

//MARK:- 监听 title label 的点击
extension PageTitleView {
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
//        print("监听 title label 的点击")
        //0. 取到当前点击的 label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        //1. 如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        //2. 取到 之前 的label
        let oldLabel = titleLabels[currentIndex]
        
        //3. 将 选中的 label的 下标 置换到 currentIndex
        currentIndex = currentLabel.tag
        
        //4. 切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15, animations: {
            self.scrollLine.frame.origin.x = scrollLineX
        })
        
        
        //6. 通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}

// MARK:- 对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        //1. 取出sourceLabel 、targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2. 处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3. 处理颜色渐变
        //3.1 取出颜色变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        //3.2 变化 sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        //3.3 变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //3.4 记录最新的index
        currentIndex = targetIndex
    }
}
