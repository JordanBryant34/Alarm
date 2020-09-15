//
//  AlarmController.swift
//  Alarm
//
//  Created by Jordan Bryant on 9/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: AnyObject {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = alarm.name
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (_) in
            print("User asked to get a local notification")
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController: AlarmScheduler {
    
    static let shared = AlarmController()
    
    var alarms: [Alarm] = []
    
    func addAlarm(alarmName: String, fireDate: Date, enabled: Bool) {
        let newAlarm = Alarm(name: alarmName, enabled: enabled, fireDate: fireDate)
        alarms.append(newAlarm)
        
        if newAlarm.enabled {
            scheduleUserNotifications(for: newAlarm)
        }
        
        saveToPersistentStore()
    }
    
    func update(alarm: Alarm, alarmName: String, enabled: Bool, fireDate: Date) {
        alarm.name = alarmName
        alarm.enabled = enabled
        alarm.fireDate = fireDate
        
        //clear previous notification for this alarm (if there was one)
        cancelUserNotifications(for: alarm)
        
        //if the alarm is enabled, schedule an updated notification
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        }
        
        saveToPersistentStore()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let indexOfAlarm = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: indexOfAlarm)
        
        cancelUserNotifications(for: alarm)
        saveToPersistentStore()
    }
    
    func toggleAlarmEnable(alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        
        saveToPersistentStore()
    }
    
    //Get the url where we are saving our data
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let filename = "alarms.json"
        let fullURL = documentDirectory.appendingPathComponent(filename)

        return fullURL
    }

    //Save the data at that url
    func saveToPersistentStore() {
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch let error {
            print("Error saving entries: \(error.localizedDescription)")
        }
    }

    //Fetch the data from the url
    func loadFromPersistentStore() {
        let decoder = JSONDecoder()

        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            self.alarms = alarms
        } catch let error {
            print("Error loading from storage: \(error.localizedDescription)")
        }
    }
}
