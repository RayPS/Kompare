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
            if currentImageIndex == collectedImages.count || currentImageIndex < 0 {
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

    func animate(_ animations: @escaping () -> Void){
        UIView.animate(
            withDuration: 0.5, delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.0,
            options: [UIView.AnimationOptions.allowUserInteraction],
            animations: {
                animations()
        }, completion: nil)
    }


    @IBAction func imageViewDidTap(_ sender: UITapGestureRecognizer) {
        currentImageIndex += 1
        Haptic.impact(.light).generate()
    }

    var triggerPointDidFeedback = false

    @IBAction func imageViewDidPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        imageView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        let triggerPoint: CGFloat = 100.0

        switch sender.state {
        case .changed:
            let scale = abs(translation.y).modulate(from: [0, triggerPoint], to: [1, 1.5], limit: true)

            self.closeButton.transform = CGAffineTransform(scaleX: scale, y: scale)

            if abs(translation.y) >= triggerPoint {
                if !triggerPointDidFeedback {
                    Haptic.impact(.light).generate()
                    triggerPointDidFeedback = true
                }
            } else {
                triggerPointDidFeedback = false
            }
        case .ended:
            if abs(translation.y) >= triggerPoint {
                done()
            } else {
                animate {
                    self.imageView.transform = CGAffineTransform.identity
                    self.closeButton.transform = CGAffineTransform.identity
                }
            }

        default:
            break
        }


    }


    @IBAction func done() {
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        Haptic.impact(.light).generate()
    }

}



extension CGFloat {
    func modulate(from: [CGFloat], to: [CGFloat], limit: Bool) -> CGFloat {
        let  result = to[0] + (((self - from[0]) / (from[1] - from[0])) * (to[1] - to[0]))
        return limit ? [[result, to.min()!].max()!, to.max()!].min()! : result
    }
}

