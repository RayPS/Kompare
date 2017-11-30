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
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var howtoButton: UIButton!

    var userDefaults = UserDefaults(suiteName: "group.Kompare")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let backgroundColor = userDefaults?.value(forKey: "backgroundColor") {
            backgroundColorSegmentControl.selectedSegmentIndex = backgroundColor as! Int
        }
        howtoButton.layer.cornerRadius = 8
        howtoButton.clipsToBounds = true
    }

    @IBAction func backgroundColorSegmentControlChanged(_ sender: UISegmentedControl) {
        userDefaults?.set(sender.selectedSegmentIndex, forKey: "backgroundColor")
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let popoverVC = segue.destination.popoverPresentationController
        if segue.identifier == "PresentAboutPopover" {
            popoverVC?.sourceRect = aboutButton.bounds
        }
    }

}

