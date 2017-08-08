//
//  CustomTabBarController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-07-05.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase

extension CustomTabBarController {
        func handleLogOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        self.presentRootView()
    }
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = defaultUser(dictionary: dictionary)
                    self.userProfileController.user = user
                }
                
            }, withCancel: nil)
        }
    }
    

}

