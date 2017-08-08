//
//  inputProfileExtension.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension inputProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSignup() {
        guard let name = nameTextField.text, let age = ageTextField.text, let gender = genderTextField.text else {
            print("Form is not valid")
            return
        }
        
        //successfully authenticated user
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let values = [ "name": name, "email": self.email, "profileImageUrl": profileImageUrl,  "age":age, "gender":gender]
                    self.registerUserIntoDatabaseWithUID(self.userUuid, values: values as [String : AnyObject])
                }
            })
        }
        
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: DATABASE_URL)
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            self.dismiss(animated: true, completion: nil)
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

