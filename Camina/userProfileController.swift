//
//  userProfileController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-08.
//  Copyright © 2017 proximastech.com. All rights reserved.
//


import UIKit
import Firebase

extension userProfileViewController {
    func handleLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        //        let root = UserGuideViewController()
        //        self.present(root, animated: true, completion: nil)
        self.presentRootView()
    }
    
    
    
    
    func fetchUserSessionID(_ completion: @escaping  () -> Void ){
        var userSessionID = [String]()
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("userSession").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for i in dictionary{
                    let id = i.value as? [String: AnyObject]
                    userSessionID.append(id?["SessionID"] as! String)
                }
            }
            self.totalSession = userSessionID.count
            for i in userSessionID{
                Database.database().reference().child("Session").child(i).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let session = userSession(dictionary: dictionary)
                        self.userSessions.append(session)
                        self.totalTime += dictionary["time"] as! Int
                        self.totalDistance += dictionary["distance"] as! Double
                        self.totalSteps += dictionary["steps"] as! Int
                    }
                    
                    completion()
                    
                }, withCancel: nil)
            }
            
            
            
        }, withCancel: nil)
        
        
    }
    
    
    

}
