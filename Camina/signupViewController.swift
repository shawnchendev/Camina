//
//  signupViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-13.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class signupViewController: UIViewController {
    let userProfileController = userProfileViewController()
    let DATABASE_URL = "https://caminatrail.firebaseio.com/"
    
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
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cpasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return tf
    }()
    
    lazy var orButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Or", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false
        return button
    }()
    
    let warningText: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.textColor = .red
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.backgroundColor = UIColor(hex:"ECF0F1")
        return textView
    }()

    
    
    lazy var facebooksignupButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hex: "557BE2")
        button.setTitle("Sign Up with Facebook ", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(FacebookLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex:"ECF0F1")
        view.addSubview(inputsContainerView)
            setupInputsContainerView()
        setNavigationItem()
        view.addSubview(orButton)
        setupOr()
        
        view.addSubview(facebooksignupButton)
        setupFacebookButton()
        
        view.addSubview(warningText)
        setupWarningText()

    }
    
    func setNavigationItem(){
        navigationItem.title = "Sign up"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        navigationItem.rightBarButtonItem?.isEnabled = false
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
                    self.warningText.text = error.localizedDescription
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
                    self.warningText.text = error.localizedDescription
                    return
                }
                guard let uid = user?.uid else{ return }
                if authProviders.count > 0{
                      self.dismiss(animated: true, completion: nil)
                
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
            self.warningText.text = "password must be match"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if let error = error {
                self.warningText.text = error.localizedDescription
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
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var cpasswordTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant:72).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(cpasswordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
        //need x, y, width, height constraints

        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        cpasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        cpasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        
        cpasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        cpasswordTextFieldHeightAnchor = cpasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        cpasswordTextFieldHeightAnchor?.isActive = true
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
    
    
    func setupOr(){
        orButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        orButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        orButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        orButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupFacebookButton(){
        facebooksignupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebooksignupButton.topAnchor.constraint(equalTo: orButton.bottomAnchor, constant: 12).isActive = true
        facebooksignupButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        facebooksignupButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupWarningText(){
        warningText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningText.topAnchor.constraint(equalTo: facebooksignupButton.bottomAnchor, constant: 24).isActive = true
        warningText.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        warningText.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}


