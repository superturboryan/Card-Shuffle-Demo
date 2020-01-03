//
//  ViewController.swift
//  Card-Shuffle-Animation
//
//  Created by Ryan David Forsyth on 2019-12-26.
//  Copyright © 2019 Ryan David Forsyth. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var chestView: UIView!
    @IBOutlet weak var chestBottom: UIImageView!
    @IBOutlet weak var chestTop: UIImageView!
    
    @IBOutlet weak var skView: SKView!
    
    var luckyNumber = 0
    
    var cards: [UIImageView] = []
    
    let cardWidth = 125.0
    let cardHeight = 162.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presentEmptyScene()
    }
    
    func setupView() {
        addButton.layer.cornerRadius = 10.0
        shuffleButton.layer.cornerRadius = 10.0
        setButton.layer.cornerRadius = 10.0
        clearButton.layer.cornerRadius = 10.0
        
        self.chestView.layer.masksToBounds = false
        self.chestView.isHidden = true
        self.chestView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
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
                           options: .curveEaseOut,
                           animations: {
                
                            cardView.frame = newCenterFrame
                
            }) { (sucess) in
                
            }
        }
    }
    
    func shuffleAllCards() {
        
        for (index,card) in self.cards.reversed().enumerated() {
            
            let radius = 30 + Int.random(in: 1...40)
            
            let circlePath = UIBezierPath(arcCenter: card.center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: index%2==0)
            
            let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
            animation.duration = 0.5 + (Double.random(in: 1...3)/10.0)
            animation.repeatCount = 5
            animation.path = circlePath.cgPath
            animation.fillMode = CAMediaTimingFillMode.forwards
//            animation.isRemovedOnCompletion = false

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
        
        self.chestView.isHidden = true
        self.chestView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
    }
    
    @objc func flipCard(_ tap:UITapGestureRecognizer) {
        
        let card = tap.view as! UIImageView
        let cardBackImage = UIImage(named: "PF-Card")
        let isLucky = card.tag == luckyNumber
        
        Haptics.shared.selection()
        
        if (card.image?.isEqual(cardBackImage))! {
            
            card.image = isLucky ? UIImage(named: "PF-Celebrate") : UIImage(named: "PF-Frown")
            UIView.transition(with: card, duration: isLucky ? 0.6 : 0.4, options: .transitionFlipFromLeft, animations: {
                
                if isLucky {
//                    UIView.animate(withDuration: 0.7) {
                        card.transform = .init(scaleX: 1.2, y: 1.2)
//                    }
                }
            
            }, completion: {(success) in
                if isLucky {
                    UIView.animate(withDuration: 0.4, animations: {
                        card.transform = .identity
                    }) { (success) in
                        Haptics.shared.notification(withType: .success)
                        self.presentChestReward()
                    }
                    
                }
                UIView.animate(withDuration: 0.5) {
                    card.transform = .identity
                }
            })
            
            
        }
        else {
            card.image = cardBackImage
            UIView.transition(with: card, duration: 0.4, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        
    }
    
    func presentChestReward() {
    
        for card in self.cards {
            
            UIView.animate(withDuration: 0.4, delay: 2.0, options: .curveEaseInOut, animations: {
                
                card.alpha = 0.0
                
            }) { (success) in
                
                if card.tag == 5 {
                    
                    self.showChest {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.shakeChestLid()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                                self.shakeChestLid()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showChest(ThenDo completion: @escaping ()->Void) {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.chestView.isHidden = false
            self.chestView.transform = .identity
        }) { (success) in
            
            completion()
        }
    }
    
    func shakeChestLid() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.delegate = self
        animation.duration = 0.1
        let repeatCount = Float(Int.random(in: 2...4))
        animation.repeatCount = repeatCount
        Haptics.shared.notification(withType: .warning)
        animation.autoreverses = true
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.fromValue = NSValue(cgPoint: CGPoint(x: chestTop.center.x, y: chestTop.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: chestTop.center.x, y: chestTop.center.y-10))
        chestTop.layer.add(animation, forKey: "position")
    }
    
    func openChest() {
        
        let angle = Measurement(value: 45, unit: UnitAngle.degrees).converted(to: .radians).value
        
        let rise = CGAffineTransform.init(translationX: -100, y: -250)
        let rotate = CGAffineTransform.init(rotationAngle: CGFloat(angle))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presentCoinExplosionScene()
        }
        
        UIView.animateKeyframes(withDuration: 0.7, delay: 1.0, options: .calculationModeCubicPaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                self.chestTop.transform = rise.concatenating(rotate)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.5) {
                self.chestTop.alpha = 0
            }
            
        }) { (success) in }
    }
    
    func presentEmptyScene() {
        let emptyScene = SKScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        emptyScene.backgroundColor = .clear
        self.skView.allowsTransparency = true
        self.skView.presentScene(emptyScene)
    }
    
    func presentCoinExplosionScene() {
        
        let coinExplosionScene = CoinExplosionScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        let emitterPosition = CGPoint(x: 187.5,y: 230)
        
        coinExplosionScene.setupEmittersWithPosition(emitterPosition)
        
        self.skView.presentScene(coinExplosionScene)
    }
    
    var animationCount = 0
}

extension ViewController:CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Animation finished")
        
        if animationCount == 1 {
            self.openChest()
        }
        animationCount += 1
    }
    
}

