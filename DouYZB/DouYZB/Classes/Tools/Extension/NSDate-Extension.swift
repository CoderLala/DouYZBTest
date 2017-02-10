//
//  NSDate-Extension.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/7.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import Foundation

extension Date{
    static func getCurrentTime() -> String {
        
        let nowDate = Date()
        let timeInteval = Int(nowDate.timeIntervalSince1970)
        
        return "\(timeInteval)"
    }
}
