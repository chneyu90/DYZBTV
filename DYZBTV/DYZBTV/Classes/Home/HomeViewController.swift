//
//  HomeViewController.swift
//  DYZBTV
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 Peter. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    fileprivate lazy var pageTitleView:PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0.0, y: 64.0, width: UIScreen.main.bounds.width, height: 40.0)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        return titleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
}


extension HomeViewController {
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageTitleView)
    }
}
