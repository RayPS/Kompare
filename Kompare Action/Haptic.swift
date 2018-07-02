//
//  Haptic.swift
//  Kompare Action
//
//  Created by Ray on 29/11/2017.
//  Copyright © 2017 Ray. All rights reserved.
//

import UIKit

public enum Haptic {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection

    // trigger
    public func generate() {
        switch self {
        case .impact(let style):
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        case .notification(let type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
