//
//  CustomTabBarController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-07-05.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase

class CustomTabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainController = mainViewController()
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.title = "Trail"
        navigationController.tabBarItem.image = UIImage(named: "trail_path")
        navigationController.tabBarItem.selectedImage = UIImage(named: "trail_path_fill")
        navigationController.navigationBar.tintColor = UIColor(hex: "00B16A")
        
        let mapController = mapViewController()
        NotificationCenter.default.addObserver(mapController, selector: #selector(mapController.startSession), name: NSNotification.Name(rawValue: "Start session"), object: nil)
        NotificationCenter.default.addObserver(mapController, selector: #selector(mapController.stopSession), name: NSNotification.Name(rawValue: "Stop session"), object: nil)
        mapController.title = "Map"
        mapController.tabBarItem.image = UIImage(named: "mapNofill")
        mapController.tabBarItem.selectedImage = UIImage(named: "mapFill")
        
        let userProfileController = userProfileViewController()
        let userProfileNavigationController = UINavigationController(rootViewController: userProfileController)
        userProfileNavigationController.title = "Me"
        userProfileNavigationController.tabBarItem.image = UIImage(named: "User")
        
        
        
        
        viewControllers = [navigationController, mapController, userProfileNavigationController]
        
        tabBar.isTranslucent = false

        tabBar.tintColor = UIColor(hex: "00B16A")
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor(r: 229, g: 231, b: 235).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
    }

    

}

