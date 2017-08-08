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
    

}


