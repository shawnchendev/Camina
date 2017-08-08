//
//  forgetPasswordController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-08.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension forgetPasswordViewController {
    func handleSendLink() {
        guard let email = emailTextField.text else{
            //error detection
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            self.sendLinkButton.isEnabled = false
            Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.enableButton), userInfo: nil, repeats: false)
            if let error = error{
                self.warningTextLabel.text = error.localizedDescription
                return
            }
            self.warningTextLabel.textColor = .black
            self.warningTextLabel.text = "Please check your email "
            
        }
    }
    
    func enableButton() {
        sendLinkButton.isEnabled = true
    }
    
    func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }

}
