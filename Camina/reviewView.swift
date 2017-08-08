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
        tableView.tableFooterView = UIView()  // it's just 1 line, awesome!

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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
    
    let starViews = starView(frame:CGRect(x:16 , y: 8, width: 150, height: 30))
    
    
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
        return lbl
    }()

    
    func setupView(){
        backgroundColor = .white
        addSubview(starViews)
        addSubview(trailNameLabel)
        addSubview(trailTypeLabel)
        
     
        trailNameLabel.leftAnchor.constraint(equalTo: starViews.leftAnchor, constant: 8).isActive = true
        trailNameLabel.topAnchor.constraint(equalTo: starViews.bottomAnchor, constant:2).isActive = true
        trailNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        trailTypeLabel.leftAnchor.constraint(equalTo: starViews.leftAnchor, constant: 8).isActive = true
        trailTypeLabel.topAnchor.constraint(equalTo: trailNameLabel.bottomAnchor, constant:4).isActive = true
        trailTypeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        
    }
    


    
}
