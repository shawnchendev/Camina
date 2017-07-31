//
//  userProfileViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-07.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase


class userProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var user : defaultUser?
    var totolSteps = 0
    var totalTime = 0
    var totalSession = 0
    var totalDistance = 0.0
    var userSessionID = [String]()
    let cellid = "cellid "
    
    let titleLabel = ["time", "#ofcomplete", "distance"]
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var profileCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CapeSpearNight")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        return lbl
    }()
    
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex:"ECF0F1")
        setupNavigationController()
        self.profileImageView.loadImageUsingCacheWithUrlString((user?.profileImageURL)!)
        userNameLabel.text = user?.name
        view.addSubview(profileCoverImageView)
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        fetchUserSessionID()
        setupProfileImageView()
        setupProfileCoverImageView()
    }
    
    func setupNavigationController(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4).isActive = true
        
    }
    
    func setupProfileCoverImageView() {
        //need x, y, width, height constraints
        profileCoverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileCoverImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileCoverImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        profileCoverImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    
    func handleLogOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        self.presentRootView()
    }
    
    

    
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUserSessionID(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("userSession").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for i in dictionary{
                   let id = i.value as? [String: AnyObject]
                    self.userSessionID.append(id?["SessionID"] as! String)
                }
                
                for i in self.userSessionID{
                    Database.database().reference().child("Session").child(i).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            self.totalTime += dictionary["time"] as! Int
                            self.totalSession = self.userSessionID.count
                            self.totalDistance += dictionary["distance"] as! Double
                            self.totolSteps += dictionary["steps"] as! Int

                        }
                        print(self.totalTime)
                        print(self.totalSession)
                        print(self.totalDistance)
                        print(self.totolSteps)
                    }, withCancel: nil)
                }
                

            }
            
        }, withCancel: nil)
        
      
}

}


