//
//  MainViewController.swift
//  DYZBTV
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 Peter. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChiledVc(sbName: "Home")
        addChiledVc(sbName: "Live")
        addChiledVc(sbName: "Follow")
        addChiledVc(sbName: "Profile")
        
    }
    
    func addChiledVc(sbName:String){
        
        let vc = UIStoryboard(name: sbName, bundle: nil).instantiateInitialViewController()!
        
        self.addChildViewController(vc)
        
    }

}
