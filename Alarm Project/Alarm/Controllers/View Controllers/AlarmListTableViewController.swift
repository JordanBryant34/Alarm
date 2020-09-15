//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Jordan Bryant on 9/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {
    
    let alarmController = AlarmController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmController.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCellId") as! AlarmTableViewCell
        let alarm = alarmController.alarms[indexPath.row]
        
        cell.alarm = alarm
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = alarmController.alarms[indexPath.row]
            alarmController.deleteAlarm(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditAlarm" {
            guard let detailVC = segue.destination as? DetailTableViewController else { return }
            guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
            let alarm = alarmController.alarms[selectedIndex.row]
            
            detailVC.alarm = alarm
        }
    }
}

extension AlarmListTableViewController: AlarmCellDelegate {
    func cellSwitchValueChanged(cell: AlarmTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = alarmController.alarms[indexPath.row]
        
        alarmController.toggleAlarmEnable(alarm: alarm)
    }
}
