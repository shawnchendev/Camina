//
//  loginViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-07.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase

class forgetPasswordViewController: UIViewController {
    

    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let warningTextLabel : UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 150, width: 300, height: 30))
        
        lbl.text = ""
        lbl.textColor = .red
        return lbl
    }()

    
    
    
    
    lazy var sendLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: "00B16A")
        button.layer.cornerRadius = 5
        button.setTitle("Send link to Email ", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSendLink), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        navigationItem.title = "Reset Password"

        self.navigationController?.navigationBar.backgroundColor = UIColor(white: 0.95, alpha: 0)
        view.backgroundColor = UIColor(hex:"ECF0F1")
        view.addSubview(inputsContainerView)
        view.addSubview(sendLinkButton)
        view.addSubview(warningTextLabel)
        setupInputview()
        setupLoginButton()
        
    }
    
    func setupInputview(){
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        
        inputsContainerView.addSubview(emailTextField)
   
        
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -8).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor).isActive = true
        
    }
    
    func setupLoginButton() {
        //need x, y, width, height constraints
        sendLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendLinkButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 20).isActive = true
        sendLinkButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        sendLinkButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
          }
    

        
}
