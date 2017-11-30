//
//  AboutViewController.swift
//  Kompare
//
//  Created by Ray on 30/11/2017.
//  Copyright © 2017 Ray. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.clipsToBounds = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = false
    }

    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentInset.top = 0
    }

    @IBAction func raypsdotcomButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://rayps.com")!)
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
