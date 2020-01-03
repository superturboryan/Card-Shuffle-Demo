//
//  Haptics.swift
//  Card-Shuffle-Animation
//
//  Created by Ryan David Forsyth on 2020-01-02.
//  Copyright © 2020 Ryan David Forsyth. All rights reserved.
//

import UIKit

class Haptics: NSObject {
    
    private var selectionGen: UISelectionFeedbackGenerator?
    private var notificationGen: UINotificationFeedbackGenerator?
    private var impactGen: UIImpactFeedbackGenerator?
    
    override init() {
        self.selectionGen = UISelectionFeedbackGenerator()
        self.notificationGen = UINotificationFeedbackGenerator()
        self.impactGen = UIImpactFeedbackGenerator()
    }
    
    static let shared = Haptics()
    
     func selection() {
        self.selectionGen!.prepare()
        self.selectionGen!.selectionChanged()
    }
    
    func impact(withIntensity intensity:CGFloat) {
        self.impactGen!.prepare()
        self.impactGen?.impactOccurred(intensity: intensity)
    }
    
     func notification(withType type: UINotificationFeedbackGenerator.FeedbackType) {
        self.notificationGen!.notificationOccurred(type)
        self.notificationGen!.prepare()
    }

}
