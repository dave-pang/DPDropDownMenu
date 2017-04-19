//
//  ViewController.swift
//  DPDropDownMenu
//
//  Created by yainoma00@gmail.com on 04/18/2017.
//  Copyright (c) 2017 yainoma00@gmail.com. All rights reserved.
//

import UIKit
import DPDropDownMenu

class ViewController: UIViewController {
    
    @IBOutlet weak var menu1: DPDropDownMenu!
    @IBOutlet weak var menu2: DPDropDownMenu!
    @IBOutlet weak var menu3: DPDropDownMenu!
    @IBOutlet weak var menu4: DPDropDownMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    
    fileprivate func setup() {
        setupMenu1()
        setupMenu2()
        setupMenu3()
        setupMenu4()
    }
    
    private func setupMenu1() {
        menu1.items = [DPItem(image: UIImage(named:"favourite"), title: "item0"),
                       DPItem(image: UIImage(named:"cart"), title: "item1"),
                       DPItem(image: UIImage(named:"mouse"), title: "item2"),
                       DPItem(image: UIImage(named:"search"), title: "item3"),
                       DPItem(title: "item3"),
                       DPItem(title: "item4"),
                       DPItem(title: "item5")]
        
        menu1.didSelectedItemIndex = { index in
            print("did selected index: \(index)")
        }
    }
    
    private func setupMenu2() {
        menu2.items = [DPItem(title: "item0"),
                       DPItem(title: "item1"),
                       DPItem(title: "item2")]
        
        menu2.didSelectedItemIndex = { index in
            print("did selected index: \(index)")
        }
    }
    
    private func setupMenu3() {
        menu3.items = [DPItem(title: "item0"),
                       DPItem(title: "item1"),
                       DPItem(title: "item2"),
                       DPItem(title: "item3"),
                       DPItem(title: "item4"),
                       DPItem(title: "item5"),
                       DPItem(title: "item6")]
        
        menu3.didSelectedItemIndex = { index in
            print("did selected index: \(index)")
        }
    }
    
    private func setupMenu4() {
        menu4.items = [DPItem(title: "item0"),
                       DPItem(title: "item1"),
                       DPItem(title: "item2"),
                       DPItem(title: "item3"),
                       DPItem(title: "item4"),
                       DPItem(title: "item5"),
                       DPItem(title: "item6")]
        
        menu4.didSelectedItemIndex = { index in
            print("did selected index: \(index)")
        }
    }
}

