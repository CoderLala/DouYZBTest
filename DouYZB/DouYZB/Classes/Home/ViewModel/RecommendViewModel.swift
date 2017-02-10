//
//  RecommendViewModel.swift
//  DouYZB
//
//  Created by 黄金英 on 17/2/7.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

class RecommendViewModel {
    
    //MARK:- 懒加载属性
    
    //0  1  2-12组数据
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    lazy var cycleModel : [CycleModel] = [CycleModel]()
    fileprivate lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    fileprivate lazy var prettyGroup : AnchorGroup = AnchorGroup()
}

//MARK:- 发送网络请求
extension RecommendViewModel {
    func requestData(_ finishCallback : @escaping () -> ()) {
        //定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : Date.getCurrentTime()]
        //0. 创建多线程组Group
        let disptchGroup = DispatchGroup()
        
        //1. 请求第一部分 推荐数据
        disptchGroup.enter()
        NetworkTools.requestData(.get, urlString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : Date.getCurrentTime()]) { (result) in
            
            //1. 将 result 转成字典类型
            guard let resultDict = result as? [String : NSObject] else{
                return
            }
            
            //2. 根据data 的key 获取数组
            guard let dataArray = resultDict["data"] as?[[String : NSObject]] else{
                return
            }
            
            //3. 遍历数组， 获取字典，并且将字典转成模型对象
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            
            disptchGroup.leave()
        }
        
        //2. 请求第二部分 颜值数据
        disptchGroup.enter()
        NetworkTools.requestData(.get, urlString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            
            //1. 将 result 转成字典类型
            guard let resultDict = result as? [String : NSObject] else{
                return
            }
            
            //2. 根据data 的key 获取数组
            guard let dataArray = resultDict["data"] as?[[String : NSObject]] else{
                return
            }
            
            //3. 遍历数组， 获取字典，并且将字典转成模型对象
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
            }
            
            disptchGroup.leave()
            
        }
        
        
        //3. 请求第2-12部分 后面部分的游戏数据
        disptchGroup.enter()
        
        NetworkTools.requestData(.get, urlString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            //1. 将 result 转成字典类型 
            guard let resultDict = result as? [String : NSObject] else{
                return
            }
            
            //2. 根据data 的key 获取数组
            guard let dataArray = resultDict["data"] as?[[String : NSObject]] else{
                return
            }
            
            //3. 遍历数组， 获取字典，并且将字典转成模型对象
            for dict in dataArray{
                let group = AnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }
        
            disptchGroup.leave()
        }
        
        disptchGroup.notify(queue: DispatchQueue.main) { 
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishCallback()
        }
    }
    
    func requestCycleData(_ finishCallback : @escaping () -> ())  {
        NetworkTools.requestData(.get, urlString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.300"]) { (result) in
            
            guard let resultDict = result as? [String : NSObject] else{ return }
            
            guard let dictArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            for dict in dictArray {
                self.cycleModel.append(CycleModel(dict: dict))
            }
            
            finishCallback()
        }
    }
}
