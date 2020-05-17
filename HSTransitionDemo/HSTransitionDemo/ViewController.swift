//
//  ViewController.swift
//  HSTransitionDemo
//
//  Created by Shuai Hui on 2020/5/7.
//  Copyright © 2020 Shuai Hui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let vv = UIView.init(frame: CGRect.init(x: 0, y: 100, width: self.view.bounds.width, height: 200))
        vv.backgroundColor = .red
        self.view.addSubview(vv)
        
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: vv.frame.maxY, width: 200, height: 60))
        btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
        btn.backgroundColor = .green
        view.addSubview(btn)
        
    }
    
    @objc func tap(){
        let vc = PresentVC.init()
//        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
   
}

