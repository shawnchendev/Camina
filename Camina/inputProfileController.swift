//
//  inputProfileController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


extension inputProfileViewController {
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
