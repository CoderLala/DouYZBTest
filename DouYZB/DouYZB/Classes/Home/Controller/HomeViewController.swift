//
//  HomeViewController.swift
//  DouYZB
//
//  Created by 黄金英 on 17/1/26.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    
    fileprivate func setupUI()
    {
        //1.设置导航栏
        setupNavgationBar()
        
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
