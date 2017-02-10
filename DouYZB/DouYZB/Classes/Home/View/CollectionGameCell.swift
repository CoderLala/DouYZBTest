//
//  CollectionGameCell.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/9.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class CollectionGameCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- 定义模型属性
    var baseGame : AnchorGroup? {
        didSet {
            titleLabel.text = baseGame?.tag_name
//            let iconUrl = URL(string: (baseGame?.icon_url ?? ""))
//            iconImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "home_more_btn"))
            if let iconURL = URL(string: baseGame?.icon_url ?? "") {
                iconImageView.kf.setImage(with: iconURL)
            } else {
                iconImageView.image = UIImage(named: "home_more_btn")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
