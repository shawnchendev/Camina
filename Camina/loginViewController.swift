//
//  loginViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-07.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class loginViewController: UIViewController {
    
        lazy var faecbookSignupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: "557BE2")

        button.layer.cornerRadius = 5
        button.setTitle("Login with Facebook ", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(FacebookLogin), for: .touchUpInside)
        return button
    }()
    
    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = LeftPaddedTextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = LeftPaddedTextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        
        return tf
    }()
    
    
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: "00B16A")
        button.setTitle("Login ", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var forgetpasswordsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forget your password? ", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitleColor(UIColor(hex: "00B16A"), for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleForgetpassword), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        navigationItem.title = "Login"
        self.navigationController?.navigationBar.backgroundColor = UIColor(white: 0.95, alpha: 0)
        view.backgroundColor = UIColor(hex:"ECF0F1")
        view.addSubview(inputsContainerView)
        view.addSubview(loginButton)
        view.addSubview(faecbookSignupButton)
        view.addSubview(forgetpasswordsButton)
        setupInputview()
        setupLoginButton()
        setupforgetpasswordButton()
    }

    func setupInputview(){
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant:80).isActive = true
        
        
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -8).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -8).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    func setupLoginButton() {
        //need x, y, width, height constraints
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 20).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        
        faecbookSignupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faecbookSignupButton.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -8).isActive = true
        faecbookSignupButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        faecbookSignupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupforgetpasswordButton(){
        //need x, y, width, height constraints
        forgetpasswordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgetpasswordsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        forgetpasswordsButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        forgetpasswordsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
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


class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
}
