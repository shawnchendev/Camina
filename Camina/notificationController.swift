//
//  notificationController.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-19.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation
import UserNotifications
import AVFoundation

extension mapViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //some other way of handling notifications
        completionHandler([.alert, .sound])
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "playInfo":
            print("playInfo")
            let synth = AVSpeechSynthesizer()
            let myUtterance = AVSpeechUtterance(string: readText)
            myUtterance.rate = 0.5
            myUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(myUtterance)
            
        case "appInfo":
            print("appInfo")
        default:
            print("nothing")
            break
        }
        completionHandler()
    }
    
    //custom notification for trail heads
    func setupTrailHeadNotification( head: Head){
        
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        
        
        let content = UNMutableNotificationContent()
        content.title = "Trail reached"
        //content.subtitle = String(describing: (trailHead.properties?.Distance)!)
        content.body = "You have reached "
        content.body += (head.properties?.Name)!
        content.body += ", You can either play the informative recording or find more information within the app"
        content.badge = 1
        content.categoryIdentifier = "actions"
        content.sound = UNNotificationSound.default()
        
        readText = (head.properties?.Name)!
        readText += (head.properties?.CAPTION)!
        
        
        //let url = Bundle.main.url(forResource: "camina", withExtension: "png")
        
        //if let attachment = try? UNNotificationAttachment(identifier: "actions", url: url!, options: nil){
        //    content.attachments = [attachment]
        //}
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let headIdentifier = "Trail head reached"
        let request = UNNotificationRequest(identifier: headIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    //custom notification for placemarks
    func setupPlacemarkNotification( placemark: Placemark){
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        
    
        let content = UNMutableNotificationContent()
        content.title = "Trail reached"
        //content.subtitle = String(describing: (trailHead.properties?.Distance)!)
        content.body = "You have reached "
        content.body += (placemark.properties?.NAME)!
        content.body += ", You can either play the informative recording or find more information within the app"
        content.badge = 1
        content.categoryIdentifier = "actions"
        content.sound = UNNotificationSound.default()
        
        readText = (placemark.properties?.NAME)!
        
        
        //let url = Bundle.main.url(forResource: "camina", withExtension: "png")
        
        //if let attachment = try? UNNotificationAttachment(identifier: "actions", url: url!, options: nil){
        //    content.attachments = [attachment]
        //}
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let placeIdentifier = "Placemark reached"
        let request = UNNotificationRequest(identifier: placeIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}
