//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by 阿拉斯加的狗 on 2017/8/25.
//  Copyright © 2017年 阿拉斯加的🐶. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    //遍历构造参数
    convenience init(imageNmae:String, highImageName:String = "",size: CGSize = CGSize.zero, target: Any, action: Selector){
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageNmae), for: .normal)
        
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        if size == CGSize.zero {
            
            btn.sizeToFit()
        }else {
        
            btn.frame = CGRect(origin:CGPoint.zero, size: size)
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        
        self.init(customView:btn)
    }
}
