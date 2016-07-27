//
//  ViewController.swift
//  DxMDTextField
//
//  Created by Miutrip on 16/7/26.
//  Copyright © 2016年 dxc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mobileTextField : MDTextField!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = CGRectGetWidth(self.view.frame)-40;
        
        let nameTextField : MDTextField = MDTextField.init(frame: CGRectMake(20, 86, width, 64));
        nameTextField.placeholder = "UserName";
        self.view.addSubview(nameTextField);
        
        mobileTextField = MDTextField.init(frame: CGRectMake(20, 160, width, 64));
        mobileTextField.placeholder = "Mobile";
        mobileTextField.showMaxInputLength = true;
        mobileTextField.maxInputLength = 18;
        self.view.addSubview(mobileTextField);
        
        
        let passwordTextField : MDTextField = MDTextField.init(frame: CGRectMake(20, 240, width, 64));
        passwordTextField.placeholder = "password";
        passwordTextField.secureTextEntry = true;
        self.view.addSubview(passwordTextField);
        
        let btn = UIButton.init(type: UIButtonType.System);
        btn.frame = CGRectMake(20, 320, width, 40);
        btn.setTitle("OK", forState: UIControlState.Normal);
        btn.addTarget(self, action:#selector(btnPressed), forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(btn);
        
    }

    
    func btnPressed(){
        mobileTextField.setErrorMsg("the mobile phone number is not correct");
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

