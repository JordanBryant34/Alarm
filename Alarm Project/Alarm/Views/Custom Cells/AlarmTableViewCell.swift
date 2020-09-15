//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by Jordan Bryant on 9/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

protocol AlarmCellDelegate: AnyObject {
    func cellSwitchValueChanged(cell: AlarmTableViewCell)
}

class AlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: AlarmCellDelegate?
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        alarmNameLabel.text = alarm?.name ?? ""
        alarmSwitch.isOn = alarm?.enabled ?? false
        alarmTimeLabel.text = alarm?.fireDateString ?? ""
    }
    
    @IBAction func alarmSwitchToggled(_ sender: Any) {
        guard let delegate = delegate else { return }
        delegate.cellSwitchValueChanged(cell: self)
    }
}
