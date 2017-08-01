//
//  sessionManagement.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-19.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit
import Firebase
import Mapbox

extension mapViewController {
    
    //session functions
    func setupSession(){
        startTimer()
        startPedometer()
        self.userPathLayer?.isVisible = true
        locationManager.distanceFilter = 10

        date = Date()
        //trailID = head.properties?.ParkID
        //pastCheckPoint = head.properties?.ParkID
        activeSession = true
        
    }
    
    func finishSession(){
        self.userPathLayer?.isVisible = false
        //Stop the pedometer
        pedometer.stopUpdates()
        activeSession = false
        //save the data
        save()
        reset()
        
    }
    
    func reset(){
        stopTimer()
        stopActivePlacemarks()
        time = ""
        distance = 0
        steps = 0
        pastCheckPoint = ""
        trailID = ""
        allCoordinates = []
        locationManager.distanceFilter = 80
    }
    
    
    //MARK: - timer functions
    func startTimer(){
        if timer.isValid { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self,selector: #selector(timerAction(timer:)) ,userInfo: nil,repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
        displayPedometerData()
        timeElapsed = 0
    }
    
    func timerAction(timer:Timer){
        displayPedometerData()
    }
    //start the pedometer
    func startPedometer() {
        //Start the pedometer
        pedometer = CMPedometer()
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData{
                self.steps = Int(pedData.numberOfSteps)
                //self.stepsLabel.text = "Steps:\(pedData.numberOfSteps)"
                if let distance = pedData.distance{
                    self.distance = Double(distance)
                }
                //                if let averageActivePace = pedData.averageActivePace {
                //                    self.averagePace = Double(averageActivePace)
                //                }
                //                if let currentPace = pedData.currentPace {
                //                    self.pace = Double(currentPace)
                //                }
            } else {
                //self.steps = nil
            }
        })
        
    }
    // display the updated data
    func displayPedometerData(){
        timeElapsed += 1.0
        time = timeIntervalFormat(interval: timeElapsed)

        totalSteps.text = String(format:"%i",steps)
 
        travelTime.text = time

        travelDistance.text = String(format:"%02.02f m",distance)
        
        trailName.text = " \(String(describing: trailID!)) - \(String(describing: pastCheckPoint!)) "
        
        //        //average pace
        //        if let averagePace = self.averagePace{
        //            avgPaceLabel.text = paceString(title: "Avg Pace", pace: averagePace)
        //        } else {
        //            avgPaceLabel.text =  paceString(title: "Avg Comp Pace", pace: computedAvgPace())
        //        }
        //
        //        //pace
        //        if let pace = self.pace {
        //            print(pace)
        //            paceLabel.text = paceString(title: "Pace:", pace: pace)
        //        } else {
        //            paceLabel.text = "Pace: N/A "
        //            paceLabel.text =  paceString(title: "Avg Comp Pace", pace: computedAvgPace())
        //        }
    }
    
    //MARK: - Display and time format functions
    
    // convert seconds to hh:mm:ss as a string
    func timeIntervalFormat(interval:TimeInterval)-> String{
        var seconds = Int(interval + 0.5) //round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    // convert a pace in meters per second to a string with
    // the metric m/s and the Imperial minutes per mile
    func paceString(title:String,pace:Double) -> String{
        var minPerMile = 0.0
        let factor = 26.8224 //conversion factor
        if pace != 0 {
            minPerMile = factor / pace
        }
        let minutes = Int(minPerMile)
        let seconds = Int(minPerMile * 60) % 60
        return String(format: "%@: %02.2f m/s \n\t\t %02i:%02i min/mi",title,pace,minutes,seconds)
    }
    
    //    func computedAvgPace()-> Double {
    //        if let distance = self.distance{
    //            pace = distance / timeElapsed
    //            return pace
    //        } else {
    //            return 0.0
    //        }
    //    }
    
    func miles(meters:Double)-> Double{
        let mile = 0.000621371192
        return meters * mile
    }
    
    func save() {
        
        //Database.database().isPersistenceEnabled = true
        if allCoordinates.count > 0 {
            for coord in allCoordinates {
                let c = ["lat": coord.latitude, "long": coord.longitude]
                tempCoordArray.append(c)
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        let dateObj = dateFormatter.string(from: date!)
        var userUID : String?
        if Auth.auth().currentUser != nil{
            userUID = Auth.auth().currentUser?.uid
            let sessionUuid = UUID().uuidString

            let post : [String: AnyObject] = [ "UserID": userUID as AnyObject, "date" : dateObj as String as AnyObject, "distance" : distance as AnyObject, "pastCheckpoint" : pastCheckPoint as AnyObject, "steps" : steps as AnyObject, "time" : timeElapsed as AnyObject, "trailID" : trailID as AnyObject, "path" : tempCoordArray as AnyObject]
            //firebase code
            ref = Database.database().reference()
            
            ref?.child("Session").child(sessionUuid).setValue(post)
            
            let userSessionRef = Database.database().reference()
            let session : [String:AnyObject] = ["SessionID": sessionUuid as AnyObject]
            userSessionRef.child("userSession").child(userUID!).childByAutoId().setValue(session)
         
        }
        
 
        
        //if activeSession{
        //return
        //}
        
        //guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        //        return
        //}
        
        // 1
        //let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        //let entity = NSEntityDescription.entity(forEntityName: "Session", in: managedContext)!
        
        //let session = Session(entity: entity,
        //                      insertInto: managedContext)
        
        // 3
        //session.date = date
        //session.distance = distance as NSNumber
        //session.pastCheckpoint = pastCheckPoint
        //session.steps = steps as NSNumber
        //session.time = time
        //session.trailID = trailID
   
        //session.path = tempCoordArray as NSArray
    
        
        // 4
        //do {
            //try managedContext.save()
        //} catch let error as NSError {
        //    print("Could not save. \(error), \(error.userInfo)")
        //}
    }
    
}
