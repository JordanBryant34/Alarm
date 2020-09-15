//
//  DetailTableViewController.swift
//  Alarm
//
//  Created by Jordan Bryant on 9/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var enableAlarmButton: UIButton!
    
    //MARK: - Properties
    let alarmController = AlarmController.shared
    var alarmEnabeled = false
    var alarm: Alarm?
    
    //MARK: - Lifecyle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = alarm != nil ? "Edit Alarm" : "New Alarm"
        updateViews()
    }
    
    //MARK: - Updating Views
    private func updateViews() {
        guard let alarm = alarm else { return }
        alarmNameTextField.text = alarm.name
        alarmDatePicker.date = alarm.fireDate
        alarmEnabeled = alarm.enabled
        updateAlarmEnableButton()
    }
    
    private func updateAlarmEnableButton() {
        if alarmEnabeled {
            enableAlarmButton.setTitle("Disable Alarm", for: .normal)
        } else {
            enableAlarmButton.setTitle("Enable Alarm", for: .normal)
        }
        
        enableAlarmButton.tintColor = alarmEnabeled ? .systemRed : .systemBlue
    }
    
    //MARK: - Actions
    @IBAction func alarmEnableTapped(_ sender: Any) {
        alarmEnabeled = !alarmEnabeled
    
        updateAlarmEnableButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = alarmNameTextField.text, !name.isEmpty else { return }
        let fireDate = alarmDatePicker.date
        
        if let alarm = self.alarm {
            alarmController.update(alarm: alarm, alarmName: name, enabled: alarmEnabeled, fireDate: fireDate)
        } else {
            alarmController.addAlarm(alarmName: name, fireDate: fireDate, enabled: alarmEnabeled)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
