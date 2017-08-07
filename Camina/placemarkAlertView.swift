//
//  placemarkAlertView.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import UIKit

class placemarkAlertView: UIView, Modal{

    var backgroundView = UIView()
    var dialogView = UIView()

    convenience init(placemarkName:String, description:String) {
        self.init(frame: UIScreen.main.bounds)
        
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)

        
        let dialogViewWidth = frame.width-64
        
        let infoLayerFrame = CGRect(x: 0, y : 0, width: dialogViewWidth, height: 60 )
        let infoLayer = UIView(frame: infoLayerFrame)
        infoLayer.backgroundColor = UIColor(hex: "00B16A")
        dialogView.backgroundColor  = UIColor(hex: "00B16A")
        dialogView.addSubview(infoLayer)
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 30))
        titleLabel.text = placemarkName
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(20)
        dialogView.addSubview(titleLabel)
        
        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = UIColor(hex: "00B16A")
        dialogView.addSubview(separatorLineView)
        
        let infoInput = UITextView(frame:CGRect(x: 0 , y: infoLayer.frame.height + 15 , width: dialogViewWidth-16, height: 200))
        infoInput.text = description
        infoInput.font = infoInput.font?.withSize(13)
        infoInput.textColor = .black
        dialogView.addSubview(infoInput)
        
        let separatorLineView2 = UIView()
        separatorLineView2.frame.origin = CGPoint(x: 0, y: infoLayer.frame.height + infoInput.frame.height + 10)
        separatorLineView2.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView2.backgroundColor = UIColor(hex: "00B16A")
        dialogView.addSubview(separatorLineView2)
        
        
        let closeButton = UIButton(frame: CGRect(x: 0 , y: infoLayer.frame.height + infoInput.frame.height + 15, width: dialogViewWidth-16, height: 40))
        closeButton.setTitle("Ok", for: .normal)
        closeButton.setTitleColor(UIColor(hex: "00B16A"), for: .normal)
        closeButton.addTarget(self, action: #selector(didTappedOnBackgroundView), for: .touchUpInside)
        dialogView.addSubview(closeButton)
        
        let dialogViewHeight = infoLayer.frame.height + infoInput.frame.height + 20 + closeButton.frame.height
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = true
        addSubview(dialogView)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
