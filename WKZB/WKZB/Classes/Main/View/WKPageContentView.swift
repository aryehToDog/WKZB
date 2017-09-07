//
//  WKPageContentView.swift
//  WKZB
//
//  Created by 阿拉斯加的狗 on 2017/9/7.
//  Copyright © 2017年 阿拉斯加的🐶. All rights reserved.
//

import UIKit

protocol WKPageContentViewDelegate: class {
    
    func pageContentViewScrollToIndex(PageContentView:WKPageContentView, index:Int)
    
    func contentView(_ contentView : WKPageContentView, targetIndex : Int, progress : CGFloat)
}

fileprivate let kPageContentReuseIdentifier = "kPageContentReuseIdentifier"

class WKPageContentView: UIView {
    
    fileprivate var isForbidScrollDelegate: Bool = false
    
    weak var delegate: WKPageContentViewDelegate?
    
    fileprivate var contentOffest: CGFloat = 0
    
    fileprivate var childs: [UIViewController]
    fileprivate var parent: UIViewController
    fileprivate var style: WKPageStyle
    
    //懒加载collerctionView
    fileprivate lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kPageContentReuseIdentifier)
        return collectionView
        
    }()
    
    
    init(frame: CGRect, childs: [UIViewController], parent: UIViewController, style: WKPageStyle) {
        
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


// MARK: - setupUI
extension WKPageContentView {
    
    fileprivate func setupUI() {
        
        //添加控制器到父控制器中
        for child in childs {
            parent.addChildViewController(child)
        }
        
        //添加collectionView
        addSubview(collectionView)
        
    }
    
}


// MARK: - UICollectionViewDataSource
extension WKPageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPageContentReuseIdentifier, for: indexPath)
        
        let childVc = childs[indexPath.item]
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        childVc.view.frame = cell.contentView.bounds
        
        childVc.view.backgroundColor = UIColor.randomColor()
        
        cell.contentView.addSubview(childVc.view)
        
        return cell
        
        
    }
    
}


// MARK: - UICollectionViewDelegate
extension WKPageContentView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        contentOffest = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scorollViewToIndexLalbe()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        scorollViewToIndexLalbe()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x == contentOffest || isForbidScrollDelegate { return }
        
        // 1.定义目标的index、进度
        var targetIndex : Int = 0
        var progress : CGFloat = 0
        
        // 2.判断用户是左滑还是右滑
        if scrollView.contentOffset.x > contentOffest { // 左滑
            targetIndex = Int(contentOffest / scrollView.bounds.width) + 1
            if targetIndex >= childs.count {
                targetIndex = childs.count - 1
            }
            progress = (scrollView.contentOffset.x - contentOffest) / scrollView.bounds.width
        } else { // 右滑
            targetIndex = Int(contentOffest / scrollView.bounds.width) - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (contentOffest - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        // 3.将数据传递给titleView
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
    }
    
    private func scorollViewToIndexLalbe() {
        
        let index = Int(collectionView.contentOffset.x / self.bounds.size.width)
        
        //通知代理进行滚动
        self.delegate?.pageContentViewScrollToIndex(PageContentView: self, index: index)
    }
    
}







// MARK: - WKPageTitleViewDelegate
extension WKPageContentView: WKPageTitleViewDelegate {
    
    func pageTitleView(pageTitleView: WKPageTitleView, index: Int) {
        
        self.isForbidScrollDelegate = true
        
        let indexPath = IndexPath(item: index, section: 0)
        
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
}
