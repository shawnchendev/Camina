//
//  signupController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

extension signupViewController {
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
                
                if providers != nil{
                    authProviders = providers!
                }else{
                    authProviders = []
                }
            })
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let uid = user?.uid else{ return }
                if authProviders.count > 0{
                    self.presentMainView()
                }else{
                    self.gotoCreateprofile(email: email, userUuid: uid,name: name,profileUrl: url)
                }
            }
        }
    }
    
    
    
    func handleNext(){
        guard let email = emailTextField.text else { return }
        
        guard let password = passwordTextField.text, let cpassword = cpasswordTextField.text else{ return }
        
        if (password != cpassword) {
            warningTextLabel.text = "password must be match"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if let error = error {
                self.warningTextLabel.text = error.localizedDescription
                return
            }
            guard let uid = user?.uid else{ return }
            
            self.gotoCreateprofile(email: email, userUuid: uid)
        })
        
    }
    
    
    // preapare all necessary infomation for create profile view controller
    
    func gotoCreateprofile(email:String, userUuid: String, name:String? = "", profileUrl:String? = ""){
        let inputProfileview = inputProfileViewController()
        inputProfileview.email = email
        inputProfileview.userUuid = userUuid
        inputProfileview.profileUrl = profileUrl!
        inputProfileview.name = name!
        self.navigationController?.pushViewController(inputProfileview, animated: true)
        
    }
    
    
    
    func textFieldDidChange(){
        if !(emailTextField.text?.isEmpty)! && isValidEmail(testStr: emailTextField.text!) {
            if !(passwordTextField.text?.isEmpty)! && !((cpasswordTextField.text?.isEmpty)!) {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
    }
   
    
    func returnLogin(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
