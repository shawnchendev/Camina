

////
//
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-07.
//  Copyright © 2017 Shawn Chen. All rights reserved.

import UIKit

class infoController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    fileprivate let headerId = "headerId"
    fileprivate let detailCellId = "detailCell"
    fileprivate let otherCellId = "otherCellId"
    let other = ["Landmarks", "Reviews", ""]
    var trailProperties : Properties?
    var trailLandMark = [Placemark]()
    var dheigth = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex:"ECF0F1")
        self.navigationItem.title = "Trail Details"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go", style: .plain, target: self, action: #selector(goToSession))
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(TrailDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.register(trailDetailDescriptionCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView?.register(otherCell.self, forCellWithReuseIdentifier: otherCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{

        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! trailDetailDescriptionCell
        detailCell.textView.attributedText = descriptionAttributedText()
        return detailCell
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherCellId, for: indexPath) as! otherCell
        cell.name = other[indexPath.item - 1]
        return cell
    }
    

    func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Detail\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor(hex: "00B16A")])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let desc = trailProperties?.CAPTION {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor.black]))
        }
        if let distance = trailProperties?.Distance{
            attributedText.append(NSAttributedString(string: "\n\nDistance: " + String(describing: distance) + " km",  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        if let time = trailProperties?.Stroll{
            attributedText.append(NSAttributedString(string: "\n\nApproximate Time: " + String(describing: time) + " minutes",  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        if let parking = trailProperties?.Parking{
            attributedText.append(NSAttributedString(string: "\n\nParking Lot : " + parking,  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        return attributedText
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0{
            let dummySize = CGSize(width: view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            return CGSize(width: view.frame.width, height: rect.height + 50)
        }
        
        return CGSize(width: view.frame.width, height: 35)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! TrailDetailHeader
        header.trailPropertires = trailProperties
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let height = 10 + 150 + 4 + 2 + 20 + 20 + 5
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 1{
            print(other[0])
        }else if indexPath.item == 2 {
            print(other[1])
        }
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
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
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
    
    let spacingView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "ECF0F1")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    
    
    override func setupViews() {
        super.setupViews()
        addSubview(spacingView)
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(typeLabel)
        addConstraintsWithFormat("H:|[v0]|", views: spacingView)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: imageView)
        addConstraintsWithFormat("H:|-8-[v0]|", views: nameLabel)
        addConstraintsWithFormat("H:|-8-[v0]|", views: typeLabel)
        
        addConstraintsWithFormat("V:|[v0(5)]-10-[v1(150)]-4-[v2]-2-[v3]|", views: spacingView, imageView, nameLabel, typeLabel)
    }
    
}

class trailDetailDescriptionCell: BaseCell {
    
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
    
    override func setupViews() {
        super.setupViews()
        addSubview(spacingView)
        addSubview(textView)
        
        addConstraintsWithFormat("H:|[v0]|", views: spacingView)

        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textView)
        
        addConstraintsWithFormat("V:|-[v0(5)]-5-[v1]|", views: spacingView, textView)
    }
    
}

class otherCell: BaseCell {

    var name: String?{
        didSet{
            if let n = name {
                nameLabel.text = n
            }
        }
    }
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(hex: "00B16A")
        return lbl
    }()
    
    let spacingView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "ECF0F1")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(spacingView)
        addSubview(nameLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: spacingView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: nameLabel)
        
        addConstraintsWithFormat("V:|-[v0(5)]-10-[v1]|", views: spacingView, nameLabel)
    }
    
}


class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}









