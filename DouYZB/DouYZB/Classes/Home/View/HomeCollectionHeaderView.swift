//
//  HomeCollectionHeaderView.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/6.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class HomeCollectionHeaderView: UICollectionReusableView {

    //MARK:- 控件属性
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    //MARK:- 定义模型属性
    var group : AnchorGroup? {
        didSet {
            titleLabel.text = group?.tag_name
            iconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
}
