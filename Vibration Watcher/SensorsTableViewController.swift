//
//  SensorsTableViewController.swift
//  Vibration Watcher
//
//  Created by Jakk Sut on 11/7/2559 BE.
//  Copyright © 2559 Jakk. All rights reserved.
//

import UIKit
import SwiftSpinner

class SensorsTableViewController: UITableViewController {

    // MARK: Constants
    let listToUsers = "SensorListToUserList"
    let sensorToData = "SensorToData"
    
    // MARK: Properties
    let sensorRef = FIRDatabase.database().reference(withPath: "vibration-data")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var sensors: [Sensor] = [] {
        didSet {
            SwiftSpinner.hide({
                self.tableView.reloadData()
            })
        }
    }
    var user: User!
    var readings: [Reading] = []
    var barButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Sensors...")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        sensorRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let snapshot = item as? FIRDataSnapshot {
                    
                    let newSensor = Sensor(snapshot: snapshot)

                    let keyItem = snapshot.value as! [String: AnyObject]
                    for reading in keyItem {
                        if let total = reading.value["total"] as? String, let ts = reading.value["ts"] as? String, let x = reading.value["x"] as? String, let y = reading.value["y"] as? String, let z = reading.value["z"] as? String {
                            let newReading = Reading(total: total, x: x, y: y, z: z, timestamp: ts)
                            self.readings.append(newReading)
                        }
                    }
                    
                    self.sensors.append(newSensor)
                }
            }
        })
        
        //User Auth Listener
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.barButtonItem.title = snapshot.childrenCount.description
            } else {
                self.barButtonItem.title = "0"
            }
        })
        
        barButtonItem = UIBarButtonItem(title: "1",
                                        style: .plain,
                                        target: self,
                                        action: #selector(userCountButtonDidTouch))
        
        barButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = barButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! SensorTableViewCell
        let sensor = sensors[indexPath.row]
        
        cell.sensorName.text = sensor.keyName
        cell.owner.text = sensor.owner
        cell.location.text = sensor.location
        cell.ref.text = sensor.ref?.description()
        
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Actions
    func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == sensorToData {
            if let destinationVC = segue.destination as? DataViewController {
                destinationVC.readings = readings
            }
        }
    }
}
