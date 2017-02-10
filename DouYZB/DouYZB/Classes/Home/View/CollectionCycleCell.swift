//
//  CollectionCycleCell.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/8.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class CollectionCycleCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //定义模型属性
    var cycleModel : CycleModel? {
        didSet{
            titleLabel.text = cycleModel?.title
            
            let iconUrl = URL(string: cycleModel?.pic_url ?? "")!
            
            iconImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "Img_default"))
        }
    }

}
