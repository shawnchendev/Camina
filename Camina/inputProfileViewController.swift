//
//  inputProfileViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-19.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class inputProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let userProfileController = userProfileViewController()

    let DATABASE_URL = "https://caminatrail.firebaseio.com"
    var name: String?
    var email: String?
    var userUuid: String?
    var password: String?
    var profileUrl: String?
    
    let genderData = [" ", "Female", "Male", "Other"]
    let ageData = [" ", "18-24", "25-34", "35-44", "45-54", "55-64", "65+"]
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Age Range"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let ageSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let genderTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Gender"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let agePickerView : UIPickerView = {
       var picker = UIPickerView()
        picker.backgroundColor = .white
        picker.tag = 1
        return picker
    }()
    
    let genderPickerView : UIPickerView = {
        var picker = UIPickerView()
        picker.backgroundColor = .white
        picker.tag = 2
        return picker
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSignup), for:.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if profileUrl != "" {
            profileImageView.loadImageUsingCacheWithUrlString(profileUrl!)
        }
        nameTextField.text = name
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.addSubview(inputsContainerView)
        view.addSubview(profileImageView)
        view.addSubview(signupButton)
        setupInputsContainerView()
        setupProfileImageView()
        setupNavBarItem()
        setupPickerView()
        setupSignupButton()
    }
    
    func setupNavBarItem(){
        self.navigationItem.title = "Create Profile"
        
    }
    
    func setupPickerView(){
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        agePickerView.delegate = self
        agePickerView.dataSource = self
        ageTextField.inputView = agePickerView
        ageTextField.inputAccessoryView = toolBar
        
        genderPickerView.showsSelectionIndicator = true
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderTextField.inputView = genderPickerView
        genderTextField.inputAccessoryView = toolBar
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var ageTextFieldHeightAnchor: NSLayoutConstraint?
    var genderTextFieldHeightAnchor: NSLayoutConstraint?
    

    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(ageTextField)
        inputsContainerView.addSubview(ageSeparatorView)
        inputsContainerView.addSubview(genderTextField)
        
        //need x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        ageTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        
        ageTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        ageTextFieldHeightAnchor = ageTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        
        ageTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        ageSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        ageSeparatorView.topAnchor.constraint(equalTo: ageTextField.bottomAnchor).isActive = true
        ageSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        ageSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        genderTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        genderTextField.topAnchor.constraint(equalTo: ageTextField.bottomAnchor).isActive = true
        
        genderTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        genderTextFieldHeightAnchor = genderTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        genderTextFieldHeightAnchor?.isActive = true
    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupSignupButton(){
        signupButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 24).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    
    
    
    
    func donePicker() {
        ageTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
    }
    
    
    
    func numberOfComponents(in: UIPickerView) -> Int {
        // Column count: use one column.
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == agePickerView{
            return ageData.count
        }else if pickerView == genderPickerView{
            return genderData.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        if pickerView == agePickerView{
            return ageData[row]
        }else if pickerView == genderPickerView{
            return genderData[row]
        }else{
            return ""
    }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == agePickerView{
            ageTextField.text = ageData[row]
        }else if pickerView == genderPickerView{
            genderTextField.text = genderData[row]
            
        }
    }

}


extension inputProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSignup() {
        guard let name = nameTextField.text, let age = ageTextField.text, let gender = genderTextField.text else {
            print("Form is not valid")
            return
        }
    
        //successfully authenticated user
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let values = [ "name": name, "email": self.email, "profileImageUrl": profileImageUrl,  "age":age, "gender":gender]
                    self.registerUserIntoDatabaseWithUID(self.userUuid!, values: values as [String : AnyObject])
                }
            })
        }
        
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference(fromURL: DATABASE_URL)
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            usersReference.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = defaultUser(dictionary: dictionary)
                    self.userProfileController.user = user
                }
                self.dismiss(animated: true, completion: nil)
            }, withCancel: nil)
     })
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
    
}

