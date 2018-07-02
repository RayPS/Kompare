//
//  ActionViewController.swift
//  Kompare Action
//
//  Created by Ray on 28/11/2017.
//  Copyright © 2017 Ray. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!

    var userDefaults = UserDefaults(suiteName: "group.Kompare")
    let queue = OperationQueue.main
    var collectedImages: [UIImage] = []
    var currentImageIndex: Int = 0 {
        didSet {
            if currentImageIndex + 1 > collectedImages.count {
                currentImageIndex = 0
            }
            imageView.image = collectedImages[currentImageIndex]
            indexLabel.text = "\(currentImageIndex + 1)/\(collectedImages.count)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredContentSize = UIScreen.main.bounds.size

        queue.addObserver(self, forKeyPath: "operations", options: .new, context: nil)

        let extensionItems = (self.extensionContext!.inputItems as! [NSExtensionItem]).first!
        let attachments = extensionItems.attachments! as! [NSItemProvider]

        for provider in attachments {
            provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil) {
                (imageURL, error) in
                self.queue.addOperation {
                    if let imageURL = imageURL as? URL {
                        if let image = UIImage(data: try! Data(contentsOf: imageURL)) {
                            self.collectedImages.append(image)
                        }
                    }
                }
            }
        }

        if let backgroundColor = userDefaults?.value(forKey: "backgroundColor") {
            let colorIndex = backgroundColor as! Int
            if colorIndex == 1 {
                view.backgroundColor = .white
                closeButton.setImage(#imageLiteral(resourceName: "Close_dark"), for: UIControl.State.normal)
                indexLabel.textColor = .black
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? OperationQueue == queue && keyPath == "operations" {
            if queue.operations.isEmpty {
                // Do something here when your queue has completed
                print("----- All operations is finished.")
                currentImageIndex = 0
                self.queue.removeObserver(self, forKeyPath:"operations")
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }



    @IBAction func imageViewDidTap(_ sender: UITapGestureRecognizer) {
        currentImageIndex += 1
        Haptic.impact(.light).generate()
    }

    @IBAction func imageViewDidPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        imageView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        if sender.state == .ended {
            let triggerPoint: CGFloat = 200.0
            if abs(translation.y) >= triggerPoint {
                done()
            } else {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0.0,
                    options: [UIView.AnimationOptions.allowUserInteraction],
                    animations: {
                        self.imageView.transform = CGAffineTransform(translationX: 0, y: 0)
                    },
                    completion: nil
                )
            }
        }
    }


    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
        Haptic.impact(.light).generate()
    }

}
