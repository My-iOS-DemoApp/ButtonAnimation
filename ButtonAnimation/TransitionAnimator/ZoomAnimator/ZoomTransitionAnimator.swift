//
//  ZoomTransitionAnimator.swift
//  CustomNavCntrl
//
//  Created by Shuvo on 8/21/17.
//  Copyright © 2017 Shuvo. All rights reserved.
//

import UIKit

class ZoomTransitionAnimator: ZoomAnimator, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        /* Determine which is the current view and which is the next view that 
         * we're navigating to and from. The container view will house the views 
         * for transition animation.
         */
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        // To avoid black screen while animating
        containerView.backgroundColor = fromView.backgroundColor
        
        /* Determine the starting frame of the current view for the animation. 
         * When we're presenting, the current view will grow 
         * out of the origin frame.
         */
        var initialFrame = originFrame
        let finalFrame = toView.frame
        
        /* Resize the next view to fit within the origin's frame at the beginning 
         * of the push animation while maintaining it's inherent aspect ratio.
         */
        let initialFrameAspectRatio = initialFrame.width / initialFrame.height
        let nextViewAspectRatio = toView.frame.width / toView.frame.height
        if initialFrameAspectRatio > nextViewAspectRatio {
            initialFrame.size = CGSize(width: initialFrame.height * nextViewAspectRatio, height: initialFrame.height)
        }
        else {
            initialFrame.size = CGSize(width: initialFrame.width, height: initialFrame.width / nextViewAspectRatio)
        }
        
        let finalFrameAspectRatio = finalFrame.width / finalFrame.height
        var resizedFinalFrame = finalFrame
        if finalFrameAspectRatio > nextViewAspectRatio {
            resizedFinalFrame.size = CGSize(width: finalFrame.height * nextViewAspectRatio, height: finalFrame.height)
        }
        else {
            resizedFinalFrame.size = CGSize(width: finalFrame.width, height: finalFrame.width / nextViewAspectRatio)
        }
        
        // Determine how much the next view needs to grow or shrink.
        let scaleFactor = resizedFinalFrame.width / initialFrame.width
        let growScaleFactor = scaleFactor
        let shrinkScaleFactor = 1/growScaleFactor
        
        /* Shrink the next view for the initial frame. The next view will be
         *scaled to CGAffineTransformIdentity below.
         */
        toView.transform = CGAffineTransform(scaleX: shrinkScaleFactor, y: shrinkScaleFactor)
        toView.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
        toView.clipsToBounds = true
        
        /* Set the initial state of the alpha for the current and next views so 
         * that we can fade them in and out during the animation.
         */
        toView.alpha = 0
        fromView.alpha = 1
        
        /* Add the view that we're transitioning to to the 
         * container view that houses the animation.
         */
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: toView)
        
        // Animate the transition.
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            // Fade the master and detail views in and out.
            toView.alpha = 1
            fromView.alpha = 0
            
            /* Scale the current view in parallel with the next view (which will 
             * grow to its inherent size). The translation gives the appearance
             * that the anchor point for the zoom is the center 
             * of the origin frame.
             */
            let scale = CGAffineTransform(scaleX: growScaleFactor, y: growScaleFactor)
            let translate = fromView.transform.translatedBy(x: fromView.frame.midX - self.originFrame.midX, y: fromView.frame.midY - self.originFrame.midY)
            fromView.transform = translate.concatenating(scale)
            toView.transform = .identity
            
            
            // Move the next view to the final frame position.
            toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { finished in
            containerView.backgroundColor = .clear
            transitionContext.completeTransition(finished)
        }
    }
    
    
}
