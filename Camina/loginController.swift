//
//  loginController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

extension loginViewController {
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            //error detection
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user:User?, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            self.presentMainView()
        })
    }
    //sign up user with facebook account
    func FacebookLogin(){
        let facebookLoginManager = FBSDKLoginManager()
        if FBSDKAccessToken.current() != nil{
            facebookLoginManager.logOut()
            FBSDKAccessToken.setCurrent(nil)
        }
        facebookLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            self.getProfile()
            
        }
    }
    
    func getProfile(){
        guard let accessToken = FBSDKAccessToken.current() else {
            print("Failed to get access token")
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
        let parameter = ["fields": "email, name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameter).start { (connection,result, error) in
            
            if error != nil{
                print("fail to get profile", error!)
                return
            }
            var authProviders = [String]()
            let values: [String:AnyObject] = result as! [String : AnyObject]
            let name = values["name"] as! String
            let email = values["email"] as! String
            let picture = values["picture"] as! [String : AnyObject]
            let url = picture["data"]?["url"] as! String
            Auth.auth().fetchProviders(forEmail: email, completion: { (providers, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                authProviders = providers!
            })
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let uid = user?.uid else{ return }
                
                if authProviders.count > 0 {
                    self.perform(#selector(self.presentMainView), with: nil, afterDelay: 0)
                }else{
                    self.gotoCreateprofile(email: email, userUuid: uid,name: name,profileUrl: url)
                }
            }
        }
    }
    
    func handleForgetpassword(){
        let forgerPasswordView = forgetPasswordViewController()
        self.navigationController?.pushViewController(forgerPasswordView, animated: true)
    }
    // preapare all necessary infomation for create profile view controller
    func gotoCreateprofile(email:String, userUuid: String, name:String? = "", profileUrl:String? = nil){
        let inputProfileview = inputProfileViewController()
        inputProfileview.email = email
        inputProfileview.userUuid = userUuid
        inputProfileview.profileUrl = profileUrl!
        inputProfileview.name = name!
        self.navigationController?.pushViewController(inputProfileview, animated: true)
        
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
