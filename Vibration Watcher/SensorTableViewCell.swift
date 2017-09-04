//
//  SensorTableViewCell.swift
//  Vibration Watcher
//
//  Created by Jakk on 11/19/2559 BE.
//  Copyright © 2559 Jakk. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {

    @IBOutlet weak var sensorName: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var ref: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sensorName.textColor = UIColor.white
        owner.textColor = UIColor.white
        ref.textColor = UIColor.gray
        location.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
