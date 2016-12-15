//
//  PageTitleView.swift
//  DYZBTV
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 Peter. All rights reserved.
//

import UIKit


/// 代理
protocol PageTitleViewDelegate : class {
    func pageTitleView(_ titleView:PageTitleView, selectIndex index : Int)
}

/// 常量定义
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)

class PageTitleView: UIView {

    fileprivate var currentIndex : Int = 0
    fileprivate var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollview : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.scrollsToTop = false
        scrollview.bounces = false
        return scrollview
    }()
    fileprivate lazy var scrllLine : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.orange
        return line
    }()
    
    
    /// 自定义构造函数
    init(frame: CGRect , titles: [String]) {
        self.titles = titles
        super.init(frame:frame)
        
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI
extension PageTitleView {
    func setupUI() {
        // 添加scrollview
        addSubview(scrollview)
        scrollview.frame = bounds
        // 添加labels
        setupTitleLabels()
        
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels() {
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            label.textAlignment = .center
            
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollview.addSubview(label)
            titleLabels.append(label)
            
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelClick(_:)))
            label.addGestureRecognizer(tap)
        }
    }
    
    private func setupBottomLineAndScrollLine() {
        let line = UIView()
        line.backgroundColor =  UIColor.lightGray
        let lineH : CGFloat = 0.5
        line.frame = CGRect(x: 0, y: frame.height-lineH, width: frame.width, height: lineH)
        addSubview(line)
        
        guard let firstLabel = titleLabels.first else { return }
        
        firstLabel.textColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1)
        
        scrollview.addSubview(scrllLine)
        scrllLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        
    }
    
    @objc private func labelClick(_ tapGes: UIGestureRecognizer) {
        
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        if currentLabel.tag == currentIndex {
            return
        }
        
        let oldLabel = titleLabels[currentIndex]
        
        currentLabel.textColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1)
        
        oldLabel.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        
        currentIndex = currentLabel.tag
        
        let scrollLineX = CGFloat(currentIndex) * scrllLine.frame.width
        
        UIView.animate(withDuration: 0.15) { 
            self.scrllLine.frame.origin.x = scrollLineX
        }
        
        // 通知代理
        delegate?.pageTitleView(self, selectIndex: currentIndex)
    }
    
}


// MARK: - 对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int,targetIndex : Int) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrllLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 去除颜色渐变范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        
        // 变化sourceLabel
        sourceLabel.textColor = UIColor(red: (kSelectColor.0 - colorDelta.0*progress)/255.0, green: (kSelectColor.1 - colorDelta.1*progress)/255.0, blue: (kSelectColor.2 - colorDelta.2*progress)/255.0, alpha: 1.0)
        
        targetLabel.textColor = UIColor(red: (kNormalColor.0 + colorDelta.0*progress)/255.0, green: (kNormalColor.1 + colorDelta.1*progress)/255.0, blue: (kNormalColor.2 + colorDelta.2*progress)/255.0, alpha: 1.0)
        
        currentIndex = targetIndex
    }
    
}


