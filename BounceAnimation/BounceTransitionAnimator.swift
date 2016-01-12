//
//  BounceTransitionAnimator.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 13/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

class BounceTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    let duration = 0.6
    let height: CGFloat = 200;
    var presenting = true;
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration;
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView();
        
        if let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let fromView = from.view,
            let toView = to.view {

                if (self.presenting) {
                    toView.frame = CGRectMake(CGFloat(0), -height, container!.bounds.size.width, height);
                    container!.addSubview(toView);
                    
                    UIView.animateWithDuration(NSTimeInterval(self.duration), delay: NSTimeInterval(0), usingSpringWithDamping: CGFloat(0.4), initialSpringVelocity: CGFloat(0.4), options: UIViewAnimationOptions(), animations: { () -> Void in
                        
                        toView.frame = CGRectMake(CGFloat(0), CGFloat(0), container!.bounds.size.width, self.height);
                        
                        }, completion: { (result) -> Void in
                            transitionContext.completeTransition(true);
                    });
                } else {
                    
                    UIView.animateWithDuration(NSTimeInterval(self.duration), delay: NSTimeInterval(0), usingSpringWithDamping: CGFloat(1), initialSpringVelocity: CGFloat(1.0), options: UIViewAnimationOptions(), animations: { () -> Void in
                        
                        fromView.frame = CGRectMake(CGFloat(0), -self.height, container!.bounds.size.width, self.height);
                        
                        }, completion: { (result) -> Void in
                            fromView.removeFromSuperview();
                            transitionContext.completeTransition(true);
                    });

                }
            }
        
    }

}
