//
//  UIBarButtonItem-Extension.swift
//  DouYZB
//
//  Created by 黄金英 on 17/1/26.
//  Copyright © 2017年 黄金英. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
   /*法一： 类方法 通过点语法调用
    class func createBarButtonItem(imageName:String, highImageName:String, btnSize:CGSize) -> UIBarButtonItem
    {
        let itemBtn = UIButton(type: .custom)
        
        itemBtn.setImage(UIImage(named:imageName), for: .normal)
        itemBtn.setImage(UIImage(named:highImageName), for: .highlighted)
        
        if btnSize == CGSize.zero
        {
           itemBtn.sizeToFit()
        }
        else
        {
            itemBtn.frame.size = btnSize
        }
        
        let navItem = UIBarButtonItem(customView: itemBtn)
        
        return navItem
    }
 */
    
    /* 法二： 便利构造函数(没有返回值， 直接创建) 通过（）调用
          1> 必须以 convenience 开头
          2> 在构造函数中必须明确调用一个设计的构造函数(self)
     参数类型后面 可以设置默认值
    */
    convenience init(imageName:String, highImageName:String = "", btnSize:CGSize = CGSize.zero) {
       
        let itemBtn = UIButton(type: .custom)
        
        itemBtn.setImage(UIImage(named: imageName), for: UIControlState())
        if highImageName != "" {
            itemBtn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        if btnSize == CGSize.zero
        {
            itemBtn.sizeToFit()
        }
        else
        {
            itemBtn.frame.size = btnSize
        }
        
        //明确调用一个设计的构造函数 以创建 barbuttonitem
        self.init(customView: itemBtn)
    }
    
    
}
