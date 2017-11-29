//
//  ViewController.swift
//  Kompare
//
//  Created by Ray on 28/11/2017.
//  Copyright © 2017 Ray. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundColorSegmentControl: UISegmentedControl!

    var userDefaults = UserDefaults(suiteName: "group.Kompare")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let backgroundColor = userDefaults?.value(forKey: "backgroundColor") {
            backgroundColorSegmentControl.selectedSegmentIndex = backgroundColor as! Int
        }
    }

    @IBAction func backgroundColorSegmentControlChanged(_ sender: UISegmentedControl) {
        userDefaults?.set(sender.selectedSegmentIndex, forKey: "backgroundColor")
    }


}

