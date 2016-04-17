//
//  questionView.swift
//  tinderSwipe
//
//  Created by Max Li on 3/16/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    let imageMarginSpace: CGFloat = 5.0
    var questionField: UITextView!
    var animator: UIDynamicAnimator!
    var originalCenter: CGPoint!
    var question: String!
    var answer: Bool!
    
    init(frame: CGRect, question: String, answer: Bool, center: CGPoint) {
        // Gives all the stuff Apple provides
        super.init(frame: frame)
        self.center = center
        self.answer = answer
        self.question = question
        self.originalCenter = center
        
        // Set the background to white
        self.layer.shouldRasterize = true
        
        // Apple thing. For physics
        animator = UIDynamicAnimator(referenceView: self)
        
        // Question
        questionField = UITextView()
        questionField.text = question
        questionField.editable = false
        questionField.backgroundColor = UIColor(red: 0.0/255.0, green: 186.0/255.0, blue: 188/255.0, alpha: 1.0)
        questionField.textAlignment = NSTextAlignment.Center
        questionField.frame = CGRectIntegral(CGRectMake(
            0.0 + self.imageMarginSpace,
            0.0 + self.imageMarginSpace,
            self.frame.width - (2 * self.imageMarginSpace),
            self.frame.height - (2 * self.imageMarginSpace)
            ))
        questionField.font = UIFont(name: "Futura", size: CGFloat(36.0))
        questionField.textColor = UIColor.blackColor()
        questionField.layer.shouldRasterize = true
        self.addSubview(questionField)
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func swipe(answer: Bool) {
        animator.removeAllBehaviors()
        
        // If the answer is false, Move to the left
        // Else if the answer is true, move to the right
        let gravityX = answer ? 0.5 : -0.5
        let magnitude = answer ? 20.0 : -20.0
        let gravityBehavior:UIGravityBehavior = UIGravityBehavior(items: [self])
        gravityBehavior.gravityDirection = CGVectorMake(CGFloat(gravityX), 0)
        animator.addBehavior(gravityBehavior)
        
        let pushBehavior:UIPushBehavior = UIPushBehavior(items: [self], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = CGFloat(magnitude)
        animator.addBehavior(pushBehavior)
        
    }
    
    func returnToCenter() {
        UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.center = self.originalCenter
            }, completion: { finished in }
        )
        
    }
    
}