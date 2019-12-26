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
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var luckyNumber = 0
    
    var cards: [UIImageView] = []
    
    let cardWidth = 125.0
    let cardHeight = 162.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    func setupView() {
        addButton.layer.cornerRadius = 10.0
        shuffleButton.layer.cornerRadius = 10.0
        setButton.layer.cornerRadius = 10.0
        clearButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        generateCards()
        moveCardsToCenter()
        
    }
    
    @IBAction func shufflePressed(_ sender: UIButton) {
        shuffleAllCards()
    }
    
    
    @IBAction func setPressed(_ sender: UIButton) {
        organizeCardsIntoGrid()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        clearAllCards()
    }
    
    //Cards 290x385
    func generateCards() {
        
        let viewHeight = self.view.frame.size.height
        let viewWidth = self.view.frame.size.width
        
        self.luckyNumber = Int.random(in: 0..<5)
        
        for index in 0...5 {
         
            let card = UIImageView(image: UIImage(named: "PF-Card"))
            card.tag = index

            switch (index % 2 == 0) {
            case true:
                card.frame = CGRect(x: 0 - cardWidth - 10, y: Double(viewHeight*0.75), width: cardWidth, height: cardHeight)
                break
            case false:
                card.frame = CGRect(x: Double(viewWidth + 10), y: Double(viewHeight*0.75), width: cardWidth, height: cardHeight)
                break
            }
            
            card.layer.masksToBounds = false
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.2
            card.layer.shadowRadius = 5.0
            card.layer.shadowOffset = CGSize(width: 0, height: 3)

            self.view.addSubview(card)

            self.cards.append(card)
        }
    }
    
    func moveCardsToCenter() {
        
        let viewHeight = self.view.frame.size.height
        let viewWidth = self.view.frame.size.width
        
        for (index, cardView) in self.cards.enumerated() {
            
            let x = Double((viewWidth/2))-(cardWidth/2)+Double(index*5)
            
            let y = Double((viewHeight/2))-(cardHeight/2)+Double(index*5)
            
            let newCenterFrame = CGRect(x: x, y: y, width: cardWidth, height: cardHeight)
            
            UIView.animate(withDuration: 1.0,
                           delay: 0.2*Double((index+1)),
                           options: .curveEaseInOut,
                           animations: {
                
                            cardView.frame = newCenterFrame
                
            }) { (sucess) in
                
            }
        }
    }
    
    func shuffleAllCards() {
        
        for (index,card) in self.cards.reversed().enumerated() {
            
            let radius = 40
            
            let circlePath = UIBezierPath(arcCenter: card.center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: index%2==0)
            
            let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
            animation.duration = 0.8
            animation.repeatCount = 5
            animation.path = circlePath.cgPath
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isRemovedOnCompletion = false

            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index)*0.15)) {
               card.layer.add(animation, forKey: nil)
            }

        }
        
    }
    
    func organizeCardsIntoGrid() {
        
        let viewWidth = Double(view.frame.size.width)
        let viewHeight = Double(view.frame.size.height)
        let horizontalSpacing = (viewWidth - (3*cardWidth)) / 5
        
        for (index,card) in self.cards.enumerated() {
   
            var col = index
            var row = col > 2 ? 1 : 0
            if col > 2 {col = col - 3}
            
            let x = (Double(col+1) * horizontalSpacing) + (Double(col) * cardWidth)
            
            let y = (Double(row+1) * horizontalSpacing) + (Double(row) * cardHeight) + 200
            
            let newFrame = CGRect(x: x, y: y, width: cardWidth, height: cardHeight)
            
            UIView.animate(withDuration: 0.9, delay: 0.1, options: .curveEaseInOut, animations: {
                card.layer.removeAllAnimations()
                card.frame = newFrame
            }) { (success) in
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.flipCard(_:)))
                card.isUserInteractionEnabled = true
                card.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        
    }
    
    func clearAllCards() {
        
        for card in self.cards {
            card.removeFromSuperview()
        }
        self.cards = []
    }
    
    @objc func flipCard(_ tap:UITapGestureRecognizer) {
        
        let card = tap.view as! UIImageView
        let cardBackImage = UIImage(named: "PF-Card")
        
        if (card.image?.isEqual(cardBackImage))! {
            card.image = card.tag == self.luckyNumber ? UIImage(named: "PF-Celebrate") : UIImage(named: "PF-Frown")
            UIView.transition(with: card, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        else {
            card.image = cardBackImage
            UIView.transition(with: card, duration: 0.4, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        
    }
    
    
}

