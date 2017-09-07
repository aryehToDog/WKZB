//
//  WKLiveViewController.swift
//  WKZB
//
//  Created by 阿拉斯加的狗 on 2017/9/6.
//  Copyright © 2017年 阿拉斯加的🐶. All rights reserved.
//

import UIKit

class WKLiveViewController: UIViewController {
    
    
    
    fileprivate lazy var pageView: WKPageView = {
        
        let pageViewFrame = CGRect(x: 0, y: 64, width: WKWidth, height: self.view.bounds.height - 64)
        let titles = ["推荐", "手游玩法大全", "娱乐手", "游戏游戏", "趣玩", "游戏游戏", "趣玩"]
        
        var childs = [UIViewController]()
        
        for _ in 0..<Int(titles.count) {
            
            let vc = UIViewController()
            childs.append(vc)
        }
        
        let style = WKPageStyle()
        
        style.isScrollEnable = true
        
        let pageView = WKPageView(frame: pageViewFrame, titles: titles, childs: childs, parent: self, style: style)
        
        return pageView
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNav()
        
        setupUI()
        
    }
    
}

extension WKLiveViewController {
    
    fileprivate func setupNav() {
        
        //设置导航栏的内容
        let leftItem = UIBarButtonItem(imageNmae: "title_button_search",target: self, action: #selector(serachClick))
        
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(imageNmae: "title_button_more",target: self, action: #selector(mailhClick))
        
        navigationItem.rightBarButtonItem = rightItem
    }
}


// MARK: - 处理导航栏按钮点击业务逻辑
extension WKLiveViewController {
    
    @objc fileprivate func serachClick() {
        
        
        print("点击了🔍")
    }
    
    @objc fileprivate func mailhClick() {
        
        
        print("点击了邮件")
    }
}

extension WKLiveViewController {
    
    fileprivate func setupUI() {
        
        
        automaticallyAdjustsScrollViewInsets = false
        
        
        
        view.addSubview(pageView)
    }
}
