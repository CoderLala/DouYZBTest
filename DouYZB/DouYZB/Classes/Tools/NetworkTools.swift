//
//  NetworkTools.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/7.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit
import Alamofire

//定义请求方式的枚举
enum MethodType {
    case get
    case post
}

class NetworkTools {
    class func requestData(_ type : MethodType, urlString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(urlString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error)
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }
}
