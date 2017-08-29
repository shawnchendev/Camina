//
//  reviewViewController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-01.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import UIKit
import Firebase


class reviewViewController : UITableViewController {
    
    var trailId : String! = ""

    var cellid = "cellid"
    
    var reviews = [Review]()
        
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        tableView.tableFooterView = UIView()  // it's just 1 line, awesome!

        let addReviewButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose , target: self, action: #selector(addReview))
        navigationItem.rightBarButtonItem = addReviewButton
        
        fetchFirebase()
        self.navigationItem.title = "Reviews"
        tableView.register(reviewCell.self, forCellReuseIdentifier: cellid)
    }
    
    
    func reviewAttributedText(review : Review) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: review.title!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor(hex: "00B16A")])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let reviewDescription = review.review {
            attributedText.append(NSAttributedString(string: "\n" + reviewDescription, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor.black]))
        }
  
        return attributedText
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dummySize = CGSize(width: view.frame.width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let rect = reviewAttributedText(review: reviews[indexPath.item]).boundingRect(with: dummySize, options: options, context: nil)
        return rect.height + 50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! reviewCell
        cell.textView.attributedText = reviewAttributedText(review: reviews[indexPath.item])
        cell.starViews.rating = reviews[indexPath.item].rating!
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func fetchFirebase() {
        let ref = FIRDatabase.database().reference()
        
        ref.child("Review").observe(.value, with: { snapshot in
            self.reviews = []
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for review in dictionary {
                    let reviewDict = review.value as! [String : AnyObject]
                    let review = Review(dictionary: reviewDict)
                    if review.trailID == self.trailId {
                        self.reviews.append(review)
                        
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()

                        })
                    }
                }
            }
            
        })
        
  
    }
    
    func addReview(){
        let review = reviewAlertView(userID: (FIRAuth.auth()?.currentUser?.uid)!, trailID: trailId)

        review.show(animated: false)
        self.tableView.reloadData()
    }
}

class reviewCell : UITableViewCell {
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
    
    let starViews = starView(frame:CGRect(x: 8 , y: 8, width: 100, height: 20))

    
    var textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE DESCRIPTION"
        tv.isScrollEnabled = false
        return tv
    }()
    
    func setupView() {
        backgroundColor = .white

        addSubview(starViews)
        addSubview(textView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textView)
        
        addConstraintsWithFormat("V:|-30-[v0]|", views: textView)
    }

    


    
}
