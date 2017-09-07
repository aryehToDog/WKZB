//
//  WKTabBarController.swift
//  WKZB
//
//  Created by 阿拉斯加的狗 on 2017/9/6.
//  Copyright © 2017年 阿拉斯加的🐶. All rights reserved.
//

import UIKit

class WKTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addchildsVc(name: "WKLiveViewController")
        addchildsVc(name: "WKRankViewController")
        addchildsVc(name: "WKFindViewController")
        addchildsVc(name: "WKMyViewController")
//        27 210 188
        tabBar.tintColor = UIColor(r: 128, g: 222, b: 202)
        
    }
    
    private func addchildsVc(name: String) {
        
        let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        addChildViewController(vc)
    }
    
}
