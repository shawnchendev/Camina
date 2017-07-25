

////
//
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-07.
//  Copyright © 2017 Shawn Chen. All rights reserved.

import UIKit

class infoController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    fileprivate let headerId = "headerId"
    fileprivate let cellId = "cellId"
    fileprivate let customeCellId = "customeCellId"
    var trailProperties : Properties?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Trail Details"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go", style: .plain, target: self, action: #selector(goToSession))
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(TrailDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: customeCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customeCellId, for: indexPath) as! CustomCollectionViewCell
        cell.trailProperties = trailProperties!
        return cell
        
    }
    
    fileprivate func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Description\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let desc = trailProperties?.CAPTION {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        return attributedText
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 1000)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! TrailDetailHeader
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customeCellId, for: indexPath) as! CustomCollectionViewCell
        header.trailPropertires = trailProperties
        header.customCell = cell
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = 14 + 150 + 8 + 2 + 4 + 4 + 1 + 20 + 15
        return CGSize(width: view.frame.width, height: CGFloat(height))
    }
    
    func goToSession(){
        let sv = sessionView()
        sv.trailProperties = trailProperties
        self.present(sv, animated: true, completion: nil)
    }
}


class TrailDetailHeader: BaseCell {
    var trailPropertires: Properties? {
        didSet {
            if let url = trailPropertires?.URL {
                imageView.loadImageUsingCacheWithUrlString(url)
            }
            
            if let name = trailPropertires?.Name{
                nameLabel.text = name
            }
            
            if let type = trailPropertires?.Type{
                typeLabel.text = type
            }
        }
    }
    
    var customCell : CustomCollectionViewCell?
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(hex: "95989A")
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Favorite", for: UIControlState())
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(typeLabel)
        
        addConstraintsWithFormat("H:|-14-[v0]-14-|", views: imageView)
        addConstraintsWithFormat("H:|-14-[v0]|", views: nameLabel)
        addConstraintsWithFormat("H:|-14-[v0]|", views: typeLabel)
        
        addConstraintsWithFormat("V:|-14-[v0(150)]-8-[v1(20)]-2-[v2(20)]|", views: imageView, nameLabel, typeLabel)
    }
    
    
    
    
}








