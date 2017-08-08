//
//  reviewAlertController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import UIKit
import Firebase


extension reviewAlertView : UITextViewDelegate {
    
    func saveInfor(){
        
        let date = Date()
        
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = date.timeIntervalSince1970
        
        // convert to Integer
        let myInt = Int(timeInterval)
        //        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        //        let timestamp = dateFormat.string(from: date)
        
        var reviewText = reviewInput.text
        if reviewText == " Review (optional)" {
            reviewText = ""
        }
        let post : [String: AnyObject] = [ "UserID": userId as AnyObject, "rating" : starRating.rating as AnyObject, "title" : titleInput.text as AnyObject, "review" : reviewText as AnyObject, "trailID" : trailId as AnyObject, "date" : myInt as AnyObject]
        //firebase code
        ref = Database.database().reference()
        
        ref?.child("Review").childByAutoId().setValue(post)
        
        dismiss(animated: true)
    }
    
    func closeView() {
        dismiss(animated: true)
    }
    
    func didTappedOnBackgroundView(){
        //        dismiss(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Review (optional)"
            textView.textColor = UIColor.lightGray
        }
    }

    
}
