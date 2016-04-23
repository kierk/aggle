//
//  PictureView.swift
//  aggle
//
// DEPRECATED DEPRECATED
// DEPRECATED DEPRECATED
// DEPRECATED DEPRECATED

import UIKit

class PictureView: UIView {
    
    //Variables
    //--------------------------------------------------------------------------------------------------//
    let imageMarginSpace: CGFloat = 0.0
    var pictureField: UIImageView!
    var animator: UIDynamicAnimator!
    var originalCenter: CGPoint!
    var picture: String!
    var answer: Bool!
    var TAG: String = "[PicturesView]"
    //--------------------------------------------------------------------------------------------------//
    
    
    //Initialization
    //--------------------------------------------------------------------------------------------------//
    init(frame: CGRect, picture: String, answer: Bool, center: CGPoint) {
        print(TAG + "init")
        // Gives all the stuff Apple provides
        super.init(frame: frame)
        self.center = center
        self.answer = answer
        self.picture = picture
        self.layer.shouldRasterize = true
        self.originalCenter = center
        
        // Apple thing. For physics
        animator = UIDynamicAnimator(referenceView: self)
        
        // Picture
        pictureField = UIImageView()
        pictureField.frame = CGRectIntegral(CGRectMake(
            0.0 + self.imageMarginSpace,
            0.0 + self.imageMarginSpace,
            self.frame.width - (2 * self.imageMarginSpace),
            self.frame.height - (2 * self.imageMarginSpace)
            ))
        pictureField.layer.shouldRasterize = true
        pictureField.image = UIImage(named: picture)
        self.addSubview(pictureField)
        self.applyBorder()
    }
    //--------------------------------------------------------------------------------------------------//
    
    
    //Apple code required from ios9 onwards
    //--------------------------------------------------------------------------------------------------//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //--------------------------------------------------------------------------------------------------//
    
    
    //Shadow for the picture
    //--------------------------------------------------------------------------------------------------//
    func applyBorder() {
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = self.frame.size.height/15
        self.layer.masksToBounds = true;
    }
    //--------------------------------------------------------------------------------------------------//
    
    
    //Swipe animation
    //--------------------------------------------------------------------------------------------------//
    func swipe(answer: Bool) {
        print(TAG + "swiped: " + (answer ? "right" : "left"))
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
    //--------------------------------------------------------------------------------------------------//
    
    
    //What happens if swipe isn't enough in a direction, it puts it back into the center
    //--------------------------------------------------------------------------------------------------//
    func returnToCenter() {
        UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .AllowUserInteraction, animations: {
            self.center = self.originalCenter
            }, completion: { finished in }
        )
        
    }
    //--------------------------------------------------------------------------------------------------//
    
}
