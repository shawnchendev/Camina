//
//  ViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-07.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FloatRatingView
class rootViewController: UIViewController, FloatRatingViewDelegate{
    
    var floatRatingView: FloatRatingView = {
        let frv = FloatRatingView()
        frv.emptyImage = UIImage(named: "StarEmpty")
        frv.fullImage = UIImage(named: "StarFull")
        // Optional params
        frv.contentMode = UIViewContentMode.scaleAspectFit
        frv.maxRating = 5
        frv.minRating = 1
        frv.rating = 2.5
        frv.editable = false
        frv.halfRatings = true
        frv.translatesAutoresizingMaskIntoConstraints = false
        return frv
    }()
    
    var backgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cabotTower")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    
    var logoImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_white")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Already have an Account? Log in", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: "00B16A")
        button.layer.cornerRadius = 5
        button.setTitle("Get Started", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handlesignup), for: .touchUpInside)
        return button
    }()
    

    
    var nav = UINavigationController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatRatingView.delegate = self
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        view.addSubview(logoImage)
        view.addSubview(signupButton)
        view.addSubview(loginButton)
        view.addSubview(floatRatingView)
        setupBackgroudImage()
        setupLogoImage()
        setupButton()
        setupRating()
        
        
    }
     func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        print(231231)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    func handleLogin(){
        let lvc = loginViewController()
        self.navigationController?.pushViewController(lvc, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func setupRating(){
        floatRatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        floatRatingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        floatRatingView.widthAnchor.constraint(equalTo: view.widthAnchor, constant:-16).isActive = true
        floatRatingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setupBackgroudImage(){
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    
    func setupLogoImage(){
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant:170).isActive = true
    }
    //signup user with their email
    func handlesignup(){
        let svc = signupViewController()
        self.navigationController?.pushViewController(svc, animated: true)
    }
    
    func setupButton(){
        //login button constraint
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //setup  email signup button constraint
        signupButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant:-30).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
    }
}
    
    
    




