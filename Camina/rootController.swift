//
//  rootController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

extension rootViewController {
    
    func handleLogin(){
        let lvc = loginViewController()
        self.navigationController?.pushViewController(lvc, animated: true)
    }
    
    //signup user with their email
    func handlesignup(){
        let svc = signupViewController()
        self.navigationController?.pushViewController(svc, animated: true)
    }

    
}
