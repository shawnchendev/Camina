//
//  reviewAlert.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-07-31.
//  Copyright © 2017 proximastech.com. All rights reserved.
//
import Foundation
import UIKit
import Firebase

import UIKit
class reviewAlertView: UIView, Modal, UITextViewDelegate{
    
    var backgroundView = UIView()
    var dialogView = UIView()
    
    var userId: String! = ""
    var trailId: String! = ""
    
    var starRating : ratingControl!
    var titleInput : UITextField!
    var reviewInput : UITextView!
    
    //firebase vars
    var ref: DatabaseReference?
    
    convenience init(userID:String, trailID:String) {
        self.init(frame: UIScreen.main.bounds)
        observeKeyboardNotifications()

        userId = userID
        trailId = trailID
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.8
        addSubview(backgroundView)
        
        
        
        let dialogViewWidth = frame.width-64
        
        let infoLayerFrame = CGRect(x: 0, y : 0, width: dialogViewWidth, height: 60 )
        let infoLayer = UIView(frame: infoLayerFrame)
        infoLayer.backgroundColor = UIColor(hex: "00B16A")
        dialogView.backgroundColor  = UIColor(hex: "00B16A")
        dialogView.addSubview(infoLayer)
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 30))
        titleLabel.text = "Share your adventure"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(20)
        
        dialogView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel(frame: CGRect(x:0, y: titleLabel.frame.height + 8, width: dialogViewWidth-16, height: 20))
        subtitleLabel.text = "Write a review"
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = subtitleLabel.font.withSize(15)
        dialogView.addSubview(subtitleLabel)
        
        // let separatorLineView = UIView()
        // separatorLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 8)
        // separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        // separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        // dialogView.addSubview(separatorLineView)
        
        
        
        starRating = ratingControl(frame:CGRect(x: dialogViewWidth / 2 - 75 , y: titleLabel.frame.height + subtitleLabel.frame.height + 16, width: 150, height: 30))
        dialogView.addSubview(starRating)
        
        let subLabel = UILabel(frame: CGRect(x:0, y: titleLabel.frame.height + subtitleLabel.frame.height + 50, width: dialogViewWidth-16, height: 20))
        subLabel.text = "Tap a star to rate"
        subLabel.textColor = .lightGray
        subLabel.textAlignment = .center
        subLabel.font = subtitleLabel.font.withSize(15)
        dialogView.addSubview(subLabel)
        
        let separatorLineView2 = UIView()
        separatorLineView2.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + subtitleLabel.frame.height + 50 + 20)
        separatorLineView2.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView2.backgroundColor = UIColor(hex: "00B16A")
        dialogView.addSubview(separatorLineView2)
        
        titleInput = UITextField(frame:CGRect(x: 0 , y: titleLabel.frame.height + subtitleLabel.frame.height + 50 + 20 + 5, width: dialogViewWidth-16, height: 30))
        titleInput.placeholder = " Title"
        titleInput.font = titleInput.font?.withSize(13)
        dialogView.addSubview(titleInput)
        
        let separatorLineView3 = UIView()
        separatorLineView3.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + subtitleLabel.frame.height + 50 + 40 + 20)
        separatorLineView3.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView3.backgroundColor = UIColor(hex: "00B16A")
        dialogView.addSubview(separatorLineView3)
        
        reviewInput = UITextView(frame:CGRect(x: 0 , y: titleLabel.frame.height + subtitleLabel.frame.height + 50 + 40 + 20 + 5, width: dialogViewWidth-16, height: 100))
        reviewInput.text = " Review (optional)"
        reviewInput.font = titleInput.font?.withSize(13)
        reviewInput.textColor = .lightGray
        reviewInput.delegate = self
        dialogView.addSubview(reviewInput)
        
        let separatorLineView4 = UIView()
        separatorLineView4.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + subtitleLabel.frame.height + 50 + 40 + 20 + 105)
        separatorLineView4.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView4.backgroundColor = UIColor(hex: "00B16A")
        dialogView.addSubview(separatorLineView4)
        
        let closeButton = UIButton(frame: CGRect(x: 0 , y: titleLabel.frame.height + subtitleLabel.frame.height + 50 + 40 + 20 + 105, width: dialogViewWidth/2, height: 40))
        //closeButton.titleLabel?.text = "Cancel"
        closeButton.setTitle("Cancel", for: .normal)
        closeButton.setTitleColor(UIColor(hex: "00B16A"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        dialogView.addSubview(closeButton)
        
        let saveButton : UIButton = UIButton(frame: CGRect(x: dialogViewWidth/2 , y: titleLabel.frame.height + subtitleLabel.frame.height + 50 + 40 + 20 + 105, width: dialogViewWidth/2, height: 40))
        //saveButton.text = "Send"
        saveButton.setTitle("Send", for: .normal)
        saveButton.setTitleColor(UIColor(hex: "00B16A"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveInfor), for: .touchUpInside)
        dialogView.addSubview(saveButton)
        

        dialogView.frame.origin = CGPoint(x: 100, y:100)
        dialogView.frame.size = CGSize(width: frame.width-64, height: 300)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = true
        addSubview(dialogView)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func saveInfor(){
        
        //        let date = Date()
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
        self.endEditing(true)
        //        dismiss(animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
        }, completion: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame = CGRect(x: 0, y: -120, width: self.frame.width, height: self.frame.height)
            
        }, completion: nil)
    }
    
    
}
