//
//  reviewController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-08.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import Firebase


extension reviewViewController {
    
    func fetchFirebase() {
        let ref = Database.database().reference()
        
        ref.child("Review").observe(.value, with: { snapshot in
            self.reviews = []
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for review in dictionary {
                    let reviewDict = review.value as! [String : AnyObject]
                    let review = Review(dictionary: reviewDict)
                    if review.trailID == self.trailId {
                        self.reviews.append(review)
                        
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                            
                        })
                    }
                }
            }
            
        })
        
        
    }
    
    func addReview(){
        let review = reviewAlertView(userID: (Auth.auth().currentUser?.uid)!, trailID: trailId)
        review.show(animated: true)
        self.tableView.reloadData()
    }

}
