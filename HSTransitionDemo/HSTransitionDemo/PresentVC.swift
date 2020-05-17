//
//  PresentVC.swift
//  HSTransitionDemo
//
//  Created by Shuai Hui on 2020/5/7.
//  Copyright © 2020 Shuai Hui. All rights reserved.
//

import UIKit
import HSTransition

class PresentVC: UIViewController {

//    @property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
    var aniamtion: HSCoverVerticalTransition!
    
    public init() {
        super.init(nibName:nil, bundle:nil)
        self.aniamtion = HSCoverVerticalTransition.init(present: self, dismiss: true)
        self.transitioningDelegate = self.aniamtion
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.preferredContentSize = CGSize.init(width: self.view.bounds.width, height: 450)
        
        let vv = UIView.init(frame: CGRect.init(x: 0, y: 100, width: self.view.bounds.width, height: 400))
        vv.backgroundColor = .black
        self.view.addSubview(vv)
        

    }
    


}
