//
//  WKPageView.swift
//  WKZB
//
//  Created by 阿拉斯加的狗 on 2017/9/7.
//  Copyright © 2017年 阿拉斯加的🐶. All rights reserved.
//

import UIKit

class WKPageView: UIView {

    fileprivate var titles: [String]
    fileprivate var childs: [UIViewController]
    fileprivate var parent: UIViewController
    fileprivate var style: WKPageStyle
    
    init(frame: CGRect, titles: [String], childs: [UIViewController], parent: UIViewController, style: WKPageStyle) {
        
        self.titles = titles
        self.childs = childs
        self.parent = parent
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension WKPageView {

    fileprivate func setupUI() {
    
        //添加titleView
        let pageTitleframe = CGRect(x: 0, y: 0, width: WKWidth, height: style.titleViewHeight)
        let pageTitleView = WKPageTitleView(frame: pageTitleframe, titles: titles, style: style)
        addSubview(pageTitleView)
        
        //添加contentViewFrame
        let contentViewFrame = CGRect(x: 0, y: pageTitleView.frame.maxY, width: WKWidth, height: self.bounds.height - style.titleViewHeight)
        let contenView = WKPageContentView(frame: contentViewFrame, childs: childs, parent: parent, style: style)
        addSubview(contenView)
        
        
        pageTitleView.delegate = contenView
        contenView.delegate = pageTitleView
    }

}
