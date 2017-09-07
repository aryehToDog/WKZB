//
//  WKLiveViewController.swift
//  WKZB
//
//  Created by 阿拉斯加的狗 on 2017/9/6.
//  Copyright © 2017年 阿拉斯加的🐶. All rights reserved.
//

import UIKit

class WKLiveViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNav()
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
