//
//  CycleModel.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/8.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class CycleModel: NSObject {

    var title : String = ""
    
    var pic_url : String = ""
    
    var room : [String : NSObject]? {
        didSet {
            guard let room = room else{ return }
            anchor = AnchorModel(dict: room)
    }
    }
    
    var anchor : AnchorModel?
    
    
    //自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
