//
//  ViewController.swift
//  Card-Shuffle-Animation
//
//  Created by Ryan David Forsyth on 2019-12-26.
//  Copyright © 2019 Ryan David Forsyth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    var cards: [UIView] = []
    
    let cardWidth = 72.5
    let cardHeight = 96.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    func setupView() {
        addButton.layer.cornerRadius = 15.0
        shuffleButton.layer.cornerRadius = 15.0
        clearButton.layer.cornerRadius = 15.0
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        generateCards()
        moveCardsToCenter()
        
    }
    
    @IBAction func shufflePressed(_ sender: UIButton) {
        shuffleAllCards()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        clearAllCards()
    }
    
    //Cards 290x385
    func generateCards() {
        
        let viewHeight = self.view.frame.size.height
        let viewWidth = self.view.frame.size.width
        
        for index in 0...4 {
         
            let card = UIView()

            switch (index % 2 == 0) {
            case true:
                card.frame = CGRect(x: 0 - cardWidth - 10, y: Double(viewHeight*0.75), width: cardWidth, height: cardHeight)
                break
            case false:
                card.frame = CGRect(x: Double(viewWidth + 10), y: Double(viewHeight*0.75), width: cardWidth, height: cardHeight)
                break
            }
 
            let cardImage = UIImage(named: "PF-Card")
            let cardImageView = UIImageView(image: cardImage)
            cardImageView.frame.size = CGSize(width: cardWidth, height: cardHeight)
            
            card.addSubview(cardImageView)
            self.view.addSubview(card)
            
            self.cards.append(card)
        }
    }
    
    func moveCardsToCenter() {
        
        let viewHeight = self.view.frame.size.height
        let viewWidth = self.view.frame.size.width
        
        for (index, cardView) in self.cards.enumerated() {
            
            let x = Double((viewWidth/2))-(cardWidth/2)
            
            let y = Double((viewHeight/2))-(cardHeight/2)+Double(index*5)
            
            let newCenterFrame = CGRect(x: x, y: y, width: cardWidth, height: cardHeight)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.2*Double((index+1)),
                           options: .curveEaseInOut,
                           animations: {
                
                            cardView.frame = newCenterFrame
                
            }) { (sucess) in }
        }
    }
    
    func shuffleAllCards() {
        
        for (index,card) in self.cards.enumerated() {
            
            let radius = 30 + (3.0 * Double(index))
            
            let circlePath = UIBezierPath(arcCenter: card.center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: index%2==0)
            
            let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
            animation.duration = 1
            animation.repeatCount = 5
            animation.path = circlePath.cgPath
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isRemovedOnCompletion = false

            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index)*0.1)) { // Change `2.0` to the desired number of seconds.
               card.layer.add(animation, forKey: nil)
            }

        }
        
    }
    
    func clearAllCards() {
        
        for card in self.cards {
            card.removeFromSuperview()
        }
        self.cards = []
    }
    
    
    
}

