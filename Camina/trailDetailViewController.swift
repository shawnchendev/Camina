//
//  trailDetailViewController.swift
//  Camina
//
//  Created by Shawn Chen on 2017-07-27.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import UIKit
import FloatRatingView

class trailDetailViewController: UITableViewController {
    /**
     Returns the rating value when touch events end
     */
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        print(123123)
    }

    var trailHead: Head?
    var trailPlacemark = [Placemark]()
    let headCellId = "headID"
    let detailCellId = "detailCellID"
    let cellId = "cellId"
    let other = ["Landmark", "Review"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Trail Detail"
        tableView.tableFooterView = UIView()  // it's just 1 line, awesome!
        self.tableView.register(trailHeadsCell.self, forCellReuseIdentifier: headCellId)
        self.tableView.register(trailDetailCell.self, forCellReuseIdentifier: detailCellId)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 200
        }else if indexPath.item == 1{
            let dummySize = CGSize(width: view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            return rect.height + 70
        
        }
        return 35
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let headcell = tableView.dequeueReusableCell(withIdentifier: headCellId, for: indexPath) as! trailHeadsCell
            headcell.trail = trailHead
            headcell.selectionStyle = .none
            headcell.isUserInteractionEnabled = false
            headcell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);

            
            return headcell
        }else if indexPath.item == 1{
            let detailcell = tableView.dequeueReusableCell(withIdentifier: detailCellId, for: indexPath) as! trailDetailCell
            detailcell.textView.attributedText = descriptionAttributedText()
            detailcell.selectionStyle = .none
            detailcell.isUserInteractionEnabled = false
            detailcell.preservesSuperviewLayoutMargins = false
            detailcell.separatorInset = UIEdgeInsets.zero
            detailcell.layoutMargins = UIEdgeInsets.zero
            return detailcell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = other[indexPath.item - 2]
        cell.textLabel?.textColor = UIColor(hex: "00B16A")
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            let landmarkView = landMarkTableViewController()
            landmarkView.tarilPlacemark = trailPlacemark
            self.navigationController?.pushViewController(landmarkView, animated: true)
        }
        if indexPath.item == 3 {
            let reviewView = reviewViewController()
            reviewView.trailId = trailHead?.properties?.ParkID
            self.navigationController?.pushViewController(reviewView, animated: true)
        }
    }
    

    func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Detail\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor(hex: "00B16A")])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let desc = trailHead?.properties?.CAPTION {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName: UIColor.black]))
        }
        if let distance = trailHead?.properties?.Distance{
            attributedText.append(NSAttributedString(string: "\n\nDistance: " + String(describing: distance) + " km",  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        if let time = trailHead?.properties?.Stroll{
            attributedText.append(NSAttributedString(string: "\n\nApproximate Time: " + String(describing: time) + " minutes",  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        if let parking = trailHead?.properties?.Parking{
            attributedText.append(NSAttributedString(string: "\n\nParking Lot : " + parking,  attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        return attributedText
    }
    


}


