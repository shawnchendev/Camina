//
//  File.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-19.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//
import UIKit

extension UIViewController{
    
    func presentRootView(){
//        let rootView = rootViewController()
        let rootView = UserGuideViewController()
        let nav = UINavigationController()
        nav.navigationBar.tintColor = UIColor(hex: "00B16A")
//        nav.setNavigationBarHidden(true, animated: true)
        nav.viewControllers.append(rootView)
        self.present(nav, animated: true, completion: nil)
    }
    
    func presentMainView(){
        let mainView  = CustomTabBarController()
        self.present(mainView, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
