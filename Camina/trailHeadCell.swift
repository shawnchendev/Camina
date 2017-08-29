//
//  trailHeadCell.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-19.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation
import UIKit

class trailHeadsCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    let spacingView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "ECF0F1")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    lazy var trailPreviewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    

    let trailNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let trailTypeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(hex: "95989A")
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    var trail: Head? {
        didSet {
            if let trailName = trail?.properties?.Name {
                trailNameLabel.text = trailName
            }
            if let trailType = trail?.properties?.Type{
                trailTypeLabel.text = trailType
            }
            if let imageUrl = trail?.properties?.URL {
                trailPreviewImage.loadImageUsingCacheWithUrlString(imageUrl)
            }
        }
    }
    let starViews = starView(frame:CGRect(x: 200, y: 150 + 15 + 5, width: 100, height: 20))

    func setupView(){

        backgroundColor = .white
        addSubview(spacingView)
        addSubview(trailPreviewImage)
        addSubview(trailNameLabel)
        addSubview(trailTypeLabel)
        addSubview(starViews)
        
        spacingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spacingView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        spacingView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        spacingView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        trailPreviewImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        trailPreviewImage.topAnchor.constraint(equalTo: spacingView.bottomAnchor, constant: 8).isActive = true
        trailPreviewImage.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
        trailPreviewImage.heightAnchor.constraint(equalToConstant:150).isActive = true
        
        trailNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        trailNameLabel.bottomAnchor.constraint(equalTo: trailTypeLabel.topAnchor, constant:2).isActive = true
        trailNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        trailTypeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        trailTypeLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant:-15).isActive = true
        trailTypeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        
        
        
    }
}

