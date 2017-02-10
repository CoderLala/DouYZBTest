//
//  CollectionNormalCell.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/6.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {
    
    //定义控件属性
    @IBOutlet weak var roomNameLabel: UILabel!
    

    //定义模型属性
    override var anchor : AnchorModel?{
        didSet{
            
            //1. 将属性传递给父类
            super.anchor = anchor
            
            //2.显示房间名称
            roomNameLabel.text = anchor?.room_name
            

        }
    }

}
