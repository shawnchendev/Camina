//
//  starView.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-01.
//  Copyright © 2017 proximastech.com. All rights reserved.
//


import UIKit

class starView : UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Properties
    var ratingButtons = [UIImageView]()
    
    var rating = 0 {
        didSet {
            setupViewableButtons()
        }
    }
    
    
    //MARK: Private Methods
    private func setupButtons(){
        
//        // Load Button Images
//        let bundle = Bundle(for: type(of: self))
//        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
//        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
//        
        for _ in 0..<5 {
            
            // Create the button
            let button = UIImageView()
            
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            //button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
}
    
    
    func setupViewableButtons() {
     
        
        for (index, imageView) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            if index < rating {
                imageView.image = #imageLiteral(resourceName: "filledStar")
            } else {
                imageView.image = #imageLiteral(resourceName: "emptyStar")
            }
        }
    }
    
    
}
