//
//  Alarm.swift
//  Alarm
//
//  Created by Jordan Bryant on 9/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var name: String
    var enabled: Bool
    var fireDate: Date
    
    let uuid: String = UUID().uuidString
    var fireDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL dd, h:mm a"
        return dateFormatter.string(from: fireDate)
    }
    
    init(name: String, enabled: Bool, fireDate: Date) {
        self.name = name
        self.enabled = enabled
        self.fireDate = fireDate
    }
}

extension Alarm: Equatable {}

func == (lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.name == rhs.name && lhs.fireDate == rhs.fireDate && lhs.uuid == rhs.uuid
}
