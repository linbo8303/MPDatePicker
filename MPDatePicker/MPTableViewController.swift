//
//  MPTableViewController.swift
//  MPDatePicker
//
//  Created by Bo Lin on 22/10/17.
//  Copyright © 2017 Oasis. All rights reserved.
//

import UIKit

class MPTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private let minimumDate = Date(timeIntervalSinceNow: -1*60*10)
    private let maximumDate = Date(timeIntervalSinceNow: 60*60*24*2)
    private let recommendedDate = Date(timeIntervalSinceNow: 60*30)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            title = ""
            let picker = MPDatePicker.show(selected: recommendedDate, minimumDate: minimumDate, maximumDate: maximumDate, validatdRealTime: true)
            picker.completionHandler = { [weak self] date in
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .medium
                self?.title = formatter.string(from: date)
            }
        case 1:
            title = ""
            let picker = MPDatePicker.show(selected: recommendedDate, minimumDate: minimumDate, maximumDate: maximumDate, validatdRealTime: false)
            picker.recommendedDate = recommendedDate
            picker.completionHandler = { [weak self] date in
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .medium
                self?.title = formatter.string(from: date)
            }
        default:
            break
        }
    }

}
