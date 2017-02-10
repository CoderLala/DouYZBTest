//
//  HomeViewController.swift
//  DouYZB
//
//  Created by 黄金英 on 17/1/26.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

private let kTitleViewHeight : CGFloat = 40

class HomeViewController: UIViewController {
    //MARK:- 懒加载属性
    //懒加载格式： var 属性名 ： class = { 定义属性 }()
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kTitleViewHeight)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        
        return titleView
    }()
    
    fileprivate lazy var pageContentView : PageContentView = {[weak self] in
        
        let contentViewFrame = CGRect(x: 0, y: kTitleViewHeight, width: kScreenWidth, height: kScreenHeight - kTitleViewHeight - kNavgationBHeight - kTabBarHeight)
    
        var childVCs = [UIViewController]()
        
        childVCs.append(RecommendViewController())
        
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            
            childVCs.append(vc)
        }
        
        let  contentView = PageContentView(frame: contentViewFrame, childVCs: childVCs, parentViewController: self)
        
        contentView.delegate = self
        
        
        return contentView
    }()
    
    //MARK:- 系统回调函数
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI界面
        setupUI()
    }
    
}

//MARK: - 设置UI界面
extension HomeViewController {
    
    fileprivate func setupUI(){
        
        //0. 不需要调整scrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1. 设置导航栏
        setupNavgationBar()
        
        //2. 添加titleView
        view.addSubview(pageTitleView)
        
        //3. 添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.red
    }
    
    //设置导航栏按钮
    fileprivate func setupNavgationBar()
    {
        //设置左侧item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //设置右侧items
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", btnSize: CGSize(width: 40, height: 40))
        
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", btnSize: CGSize(width: 40, height: 40))
        
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", btnSize: CGSize(width: 40, height: 40))
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem];
    }
    
}

// MARK:- 遵守PageTitleViewDelegate 协议
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
}

// MARK:- 遵守PageContentViewDelegate 协议
extension HomeViewController : PageContentViewDelegate{
    func pageContentView(_ contentView: PageContentView, progress : CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
