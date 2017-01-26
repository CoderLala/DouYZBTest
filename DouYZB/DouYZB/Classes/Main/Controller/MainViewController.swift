//
//  MainViewController.swift
//  DouYZB
//
//  Created by 黄金英 on 17/1/25.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVC(storyName: "Home")
        addChildVC(storyName: "Live")
        addChildVC(storyName: "Follow")
        addChildVC(storyName: "Profile")
        
    }

    private func addChildVC(storyName:String)
    {
        //通过storyboard 获取子控制器
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        //添加子控制器
        addChildViewController(childVC)
    }

}
