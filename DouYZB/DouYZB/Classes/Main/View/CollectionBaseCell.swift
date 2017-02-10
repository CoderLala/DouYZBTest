//
//  CollectionBaseCell.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/8.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    //定义模型属性
    var anchor : AnchorModel?{
        didSet{
            guard let anchor = anchor else {
                return
            }
            //1. 取出在线人数显示的文字
            var onlineStr : String = ""
            if anchor.online >= 10000{
                onlineStr = "\(Int(anchor.online / 10000))万在线"
            }
            else{
                onlineStr = "\(anchor.online)在线"
            }
            onlineBtn.setTitle(onlineStr, for: .normal)
            
            //2. 显示昵称
            nickNameLabel.text = anchor.nickname
            
            
            //3. 显示封面图片
            guard let iconURL = URL(string: anchor.vertical_src) else { return }
            iconImageView.kf.setImage(with: iconURL)
            
        }
    }
}
