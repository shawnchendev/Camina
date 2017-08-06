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
    
    var ref : DatabaseReference!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addReviewButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose , target: self, action: #selector(addReview))
        navigationItem.rightBarButtonItem = addReviewButton
        
        fetchFirebase()
        self.navigationItem.title = "Reviews"
        tableView.register(reviewCell.self, forCellReuseIdentifier: cellid)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! reviewCell
        cell.trailNameLabel.text = reviews[indexPath.item].title
        cell.trailTypeLabel.text = reviews[indexPath.item].review
        cell.starViews.rating = reviews[indexPath.item].rating!
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func fetchFirebase() {
        let ref = Database.database().reference()
        
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
//            print(self.reviews)
//            self.tableView.reloadData()
            
        })
        
  
    }
    
    func addReview(){
        let review = reviewAlertView(userID: (Auth.auth().currentUser?.uid)!, trailID: trailId)
        review.show(animated: true)
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
    
    let starViews = starView(frame:CGRect(x: 0 , y: 12, width: 150, height: 30))
    
    
    let trailNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let trailTypeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 11)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(hex: "95989A")
        return lbl
    }()

    
    func setupView(){
        backgroundColor = .white
        addSubview(starViews)
        addSubview(trailNameLabel)
        addSubview(trailTypeLabel)
        
        
        starViews.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        starViews.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        starViews.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
        starViews.heightAnchor.constraint(equalToConstant:150).isActive = true
        
        trailNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        trailNameLabel.bottomAnchor.constraint(equalTo: starViews.topAnchor, constant:2).isActive = true
        trailNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        trailTypeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        trailTypeLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant:-15).isActive = true
        trailTypeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        
    }
    


    
}
