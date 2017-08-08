////
////  kdtree.swift
////  Camina
////
////  Created by Diego Zuluaga on 2017-08-07.
////  Copyright © 2017 proximastech.com. All rights reserved.
////
//
//import Foundation
//import CoreLocation
//
//struct node {
//    let left : kdtree
//    let right : kdtree
//    let value : CLLocationCoordinate2D
//}
//
//class kdtree : NSObject {
////
////def build_kdtree(points, depth=0):
////n = len(points)
////
////if n <= 0:
////return None
////
////axis = depth % k
////
////sorted_points = sorted(points, key=lambda point: point[axis])
////
////return {
////    'point': sorted_points[n / 2],
////    'left': build_kdtree(sorted_points[:n / 2], depth + 1),
////    'right': build_kdtree(sorted_points[n/2 + 1:], depth + 1)
////}
//    let k = 2
//
//
//    func build_kdtree(points: NSArray, depth: Int) -> NSDictionary{
//        let n : Int = points.count
//    
//        if n <= 0 {
//            let x : [String : AnyObject?] = ["checker" : nil]
//            return x as NSDictionary
//        }
//    
//        let axis = depth % k
//        
//        var sortedPoints: [NSArray] = points.sorted(by: { (($0 as! NSArray).object(at: axis) as! Double) < (($1 as! NSArray).object(at: axis) as! Double)}) as! [NSArray]
//        
//        var node = Dictionary<String, Any>()
//        node.updateValue(sortedPoints[n/2], forKey: "point")
//        //node.updateValue(build_kdtree(points: sortedPoints[0..<(n/2)], depth: depth + 1), forKey: "left")
//        //node.updateValue(build_kdtree(points: sortedPoints[(n/2+1)..<n], depth: depth + 1), forKey: "right")
//    
//    
//    }
//
//
//}


import Foundation

public class coordinates : Comparable {
    let lat : Double
    let long : Double
    
    init(lat:Double, long:Double){
        self.lat = lat
        self.long = long
    }
    
    public static func < (lhc: coordinates, rhc: coordinates) -> Bool {
        if lhc.lat <= rhc.lat {
            return true
        }
        else {
            return lhc.long <= rhc.long
        }
    }
    
    public static func == (lhc: coordinates, rhc: coordinates) -> Bool {
        return (lhc.lat == rhc.lat && lhc.long == rhc.long)
    }
}

public class kdtree <T: Comparable>{
    var key : T?
    var left : kdtree?
    var right: kdtree?
    
    init(){
    }
    
    //add item based on its value
    func addNode(key: T){
        //check for the head node
        if (self.key == nil){
            self.key = key
            return
        }
        
        
        //check for the left side of the tree
        if (key < self.key!){
            if ( self.left != nil) {
                left!.addNode(key: key)
            }
            else {
                //create a new left node
                var leftChild : kdtree = kdtree()
                leftChild.key = key
                self.left = leftChild
            }
        }//end if
        
        if (key > self.key!){
            if ( self.right != nil) {
                right!.addNode(key: key)
            }
            else {
                //create a new left node
                var rightChild : kdtree = kdtree()
                rightChild.key = key
                self.right = rightChild
            }
        }//end if
    }
}

