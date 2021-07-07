//
//  PushNotification.swift
//  Puzzle Game
//
//  Created by Oliver Karlsson on 2018-11-30.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import UserNotifications

class PushNotification {
    let content = UNMutableNotificationContent()
    
    init(title: String, body: String) {
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
    }
    //MARK: - Play instantly
    func playNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "NotificationIdentifier", content: self.content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //MARK: - Schedule time to play Notification
    func playAtDate(hour: Int, 	minute: Int){
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "NotificationIdentifier", content: self.content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
}
