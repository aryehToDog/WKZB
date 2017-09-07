//
//  WKPageTitleView.swift
//  WKZB
//
//  Created by 阿拉斯加的狗 on 2017/9/7.
//  Copyright © 2017年 阿拉斯加的🐶. All rights reserved.
//

import UIKit

protocol WKPageTitleViewDelegate: class {
    
    func pageTitleView(pageTitleView: WKPageTitleView, index: Int)
}

private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class WKPageTitleView: UIView {
    
    weak var delegate: WKPageTitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style: WKPageStyle
    fileprivate var lables = [UILabel]()
    
    fileprivate var currentIndex: Int = 0
    
    fileprivate lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    
    init(frame: CGRect, titles: [String], style: WKPageStyle) {
        
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension WKPageTitleView {
    
    fileprivate func setupUI() {
        
        //添加scrollview
        addSubview(scrollView)
        
        //添加title对应的lable
        setupTitleLables()
        
        //设置lable的frame
        setupTitleFrame()
    }
    
    private func setupTitleLables() {
        
        for (i,title) in titles.enumerated() {
            
            let lable = UILabel()
            lable.tag = i
            lable.text = title
            lable.font = style.titleLableFont
            lable.textAlignment = .center
            
            if i == 0 {
                
                lable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
            }else {
                
                lable.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            }
            
            
            //添加到scrollView中
            scrollView.addSubview(lable)
            
            //保存lable
            lables.append(lable)
            
            //添加手势
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(clickTapLable(_:)))
            
            lable.addGestureRecognizer(tapGest)
            lable.isUserInteractionEnabled = true
        }
    }
    
    private func setupTitleFrame() {
        
        var titleLableX: CGFloat = 0
        let titleLableY: CGFloat = 0
        var titleLableW: CGFloat = 0
        let titleLableH: CGFloat = self.bounds.height
        
        for (i,lable) in lables.enumerated() {
            
            if !style.isScrollEnable {
                
                titleLableW = self.bounds.size.width / CGFloat(lables.count)
                titleLableX = CGFloat(i) * titleLableW
                
            }else {
                
                let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
                
                
                titleLableW = (titles[i] as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.titleLableFont], context: nil).width
                
                if i == 0 {
                    titleLableX = style.titleLableMargin * 0.5
                }else {
                    
                    let preLable = lables[i-1]
                    titleLableX = preLable.frame.maxX + style.titleLableMargin
                }
                
            }
            
            lable.frame = CGRect(x: titleLableX, y: titleLableY, width: titleLableW, height: titleLableH)
            
        }
        
        if style.isScrollEnable {
            scrollView.contentSize.width = (lables.last?.frame.maxX)! + style.titleLableMargin * 0.5
        }
        
    }
    
    
    
    
}


extension WKPageTitleView {
    
    @objc fileprivate func clickTapLable(_ tapGest: UITapGestureRecognizer) {
        
        //获取到当前lable
        guard let currentLable = tapGest.view as? UILabel else {
            return
        }
        
        if tapGest.view?.tag == currentIndex {
            return
        }
        
        currentLable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        //获取以前的lable
        let oldLable = lables[currentIndex]
        oldLable.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        currentIndex = currentLable.tag
        
        //调整lable位置
        adjustLableScrollViewLocation(newLable: currentLable)
        
        //通知代理
        self.delegate?.pageTitleView(pageTitleView: self, index: currentIndex)
        
    }
    
    fileprivate func adjustLableScrollViewLocation(newLable: UILabel) {
        
        if style.isScrollEnable == false{
            return
        }
        
        //处理最左边的按钮被居中
        var offestX = newLable.center.x - scrollView.frame.size.width * 0.5
        
        if offestX < 0 {
            offestX = 0
        }
        
        //处理最右边的按钮被居中
        let maxOffestX = scrollView.contentSize.width - bounds.width
        if offestX > maxOffestX {
            offestX = maxOffestX
        }
        
        scrollView.setContentOffset(CGPoint(x: offestX, y: 0), animated: true)
        
    }
    
    
}


extension WKPageTitleView: WKPageContentViewDelegate {
    
    func pageContentViewScrollToIndex(PageContentView: WKPageContentView, index: Int) {
        
        let currentLable = lables[index]
        let oldLable = lables[currentIndex]
        
        //防止最右变划过去就没有颜色了
        oldLable.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        currentLable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        currentIndex = index
        
        adjustLableScrollViewLocation(newLable: currentLable)
    }
    
    
    func contentView(_ contentView: WKPageContentView, targetIndex: Int, progress: CGFloat) {
        
        
        
    }
}

