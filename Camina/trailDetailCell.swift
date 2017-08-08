//
//  trailDetailCell.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-08.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import UIKit


class trailDetailCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE DESCRIPTION"
        tv.isScrollEnabled = false
        return tv
    }()
    
    let spacingView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "ECF0F1")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    func setupViews() {
        addSubview(spacingView)
        addSubview(textView)
        
        addConstraintsWithFormat("H:|[v0]|", views: spacingView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textView)
        
        addConstraintsWithFormat("V:|-[v0(5)]-5-[v1]|", views: spacingView, textView)
    }
    
}
