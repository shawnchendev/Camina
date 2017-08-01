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
    
    struct Review { //starting with a structure to hold user data
        var firebaseKey : String?
        var userID : String?
        var rating : Int?
        var review : String?
        var title : String?
        var trailID : String?
    }
    
    var reviews = [Review]()
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFirebase()
        self.navigationItem.title = "Reviews"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        cell.textLabel?.text = reviews[indexPath.item].title
        return cell
    }
    
    func fetchFirebase() {
        let ref = Database.database().reference()
        
        ref.child("Review").observe(.value, with: { snapshot in
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print("this shit")
            print(postDict)
            
            for child in snapshot.children {
                
                //let postChild = child.value as? [String : AnyObject] ?? [:]
                
                //print(postChild)
            }
            
          //  for child in snapshot.children { //.Value so iterate over nodes
                
          //      var firebaseKey = child.key!
          //      let userID = (child as AnyObject).value["userID"] as! String
          //      var rating = child.value["rating"] as! Int
          //      var review = child.value["review"] as! String
          //      var title = child.value["title"] as! String
          //      var trailID = child.value["trailID"] as! String

                
          //      let u = User(firebaseKey: fbKey, theAge: age, theDistance: distance)
                
          //      userArray.append(u) //add the user struct to the array
          //  }
            
            //the array to contain the filtered users
           // var filteredArray: [User] = []
           // filteredArray = userArray.filter({$0.theDistance < 100}) //Filter it, baby!
            
            //print out the resulting users as a test.
           // for aUser in filteredArray {
                
             //   let k = aUser.firebaseKey
               // let a = aUser.theAge
               // let d = aUser.theDistance
                
              //  print("array: \(k!)  \(a!)  \(d!)")
                
            //}
            
        })
    }
    
    
}
