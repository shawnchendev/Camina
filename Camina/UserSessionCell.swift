//
//  UserSessionCell.swift
//  Camina
//
//  Created by Shawn Chen on 2017-08-15.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import MapboxStatic
import UIKit
import Mapbox


class userSessionCell: BaseCell{
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    let mapSnapShot : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    override func setupViews() {
        super.setupViews()
    
        
    

        addSubview(mapSnapShot)
        addSubview(nameLabel)
        
        mapSnapShot.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mapSnapShot.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        mapSnapShot.widthAnchor.constraint(equalTo: widthAnchor, constant: -16).isActive = true
        mapSnapShot.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: mapSnapShot.bottomAnchor, constant: 8).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
    }
    
}
