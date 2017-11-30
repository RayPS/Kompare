//
//  AboutViewController.swift
//  Kompare
//
//  Created by Ray on 30/11/2017.
//  Copyright © 2017 Ray. All rights reserved.
//

import UIKit
import StoreKit

class AboutViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.clipsToBounds = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = false
        rateButton.layer.cornerRadius = 8
        rateButton.clipsToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentInset.top = 0

        let isPopover = view.superview!.bounds != UIScreen.main.bounds
        if isPopover {
            closeButton.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        scrollView.clipsToBounds = true
    }

    @IBAction func raypsdotcomButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://rayps.com")!)
    }

    @IBAction func rateButtonTapped(_ sender: UIButton) {
        SKStoreReviewController.requestReview()
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
