//
//  CustomCollectionViewCell.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-07-18.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var trailProperties : Properties? = nil
    var trailLandmark = [Placemark]()
    
    var dheight = CGFloat()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        //        cv.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        //       cv.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        cv.isPagingEnabled = true
        return cv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Landmark"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(hex: "00B16A")
        sc.selectedSegmentIndex = 0
        
        return sc
    }()
    
    let spacingView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "ECF0F1")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    fileprivate let detailCellId = "detailCellId"
    fileprivate let landmarkCellId = "landmarkCellId"
    


    
    override func setupViews() {
        super.setupViews()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        segmentedControl.addTarget(self, action: #selector(handleValueChange), for: .valueChanged)
        addSubview(spacingView)
        addSubview(segmentedControl)
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: spacingView)

        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: segmentedControl)
        
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        
        addConstraintsWithFormat("V:|[v0(10)]-[v1(30)]-[v2]|", views: spacingView, segmentedControl, collectionView)
        
        collectionView.register(trailDetailDescriptionCell.self, forCellWithReuseIdentifier: detailCellId)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        segmentedControl.selectedSegmentIndex = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! trailDetailDescriptionCell
        detailCell.textView.attributedText = descriptionAttributedText()
        return detailCell
            
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0{
            let dummySize = CGSize(width: frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            return CGSize(width: frame.width, height: rect.height + 30)
        }
        
        return CGSize(width: frame.width, height: frame.height - 10)
    }
    
    func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "")
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let desc = trailProperties?.CAPTION {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.black]))
        }
        if let distance = trailProperties?.Distance{
            attributedText.append(NSAttributedString(string: "\n\nDistance: " + String(describing: distance) + " km",  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        if let time = trailProperties?.Stroll{
            attributedText.append(NSAttributedString(string: "\n\nApproximate Time: " + String(describing: time) + " minutes",  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        if let parking = trailProperties?.Parking{
            attributedText.append(NSAttributedString(string: "\n\nParking Lot : " + parking,  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        return attributedText
    }
    
    func handleValueChange(sender: UISegmentedControl!) {
        let indexPath = IndexPath(item: sender.selectedSegmentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
}










