//
//  ViewController.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 11/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let animator = BounceTransitionAnimator();
    
    var presented = false;
    
    @IBOutlet weak var toHighlight: UIView!
    @IBOutlet weak var secondToHighlight: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let startPoint = CGPointMake(0, 0);
//        let endPoint = CGPointMake(100, 100);
//        let angle = M_PI_4 / 2;
//        
//        let arrowHead = ArrowHead(angle: angle, length: 20.0)
//        let arrow = Arrow(startPoint: startPoint, endPoint: endPoint, arrowHead: arrowHead);
//        
//        let arrowView = ArrowView(arrow: arrow, frame: CGRectMake(0, 0, 100, 100));
//        self.view.addSubview(arrowView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onButton(sender: AnyObject) {
        
        
        let highlight = ViewHighlight(view: self.toHighlight, highlightType: ViewHighlightType.Rect, message: "123 ashgjhasd jhag djhagsdjasg djhags hjdgasjdga jdg asjhgdjhag d")
        highlight.arrowPosition = .Right;
        
        let highlight2 = ViewHighlight(view: self.secondToHighlight, highlightType: ViewHighlightType.Round, message: " ahjkfh sdjfhksdf hkjdsfhkshfkdsjhf sdhf ksdhfk ahskdjh asdhaskd ashjkd askjd asdhjsadh sadhsadjsah dhkjdsfhkshfkdsjhf sdhf ksdhfk ahskdjh asdhaskd ashjkd askjd asdhjsadh sadhsadjsah dhkjdsfhkshfkdsjhf sdhf ksdhfk ahskdjh asdhaskd ashjkd askjd asdhjsadh sadhsadjsah d")
        highlight2.arrowPosition = .Down;
        highlight2.inset = 50
        highlight2.bubbleBackgroundColor = UIColor.redColor()
        highlight2.font = UIFont.systemFontOfSize(10)
        highlight2.textColor = UIColor.whiteColor()
        highlight2.opacity = 1
        highlight2.arrowWidth = 20
        highlight2.arrowHeight = 10
        let highlights = [highlight, highlight2];
        let ctrl = TutorialPageAnimator(backgroundView: self.view, viewsToHighlight: highlights);
        ctrl.dimViewColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        ctrl.didSelectHighlightedView = { view in
            print("1")
        }
        ctrl.acceptTapsOnlyOnHighlightedViews = true
        ctrl.present(self);
        

//        let ctrl = CategoryTags(nibName: "CategoryTags", bundle: NSBundle.mainBundle());
//        self.presentViewController(ctrl, animated: true, completion: nil);
        
        
//        let ctrl = SlideViewController();
//        ctrl.view.backgroundColor = UIColor.whiteColor();
//        ctrl.scaleMultiplier = 0.95;
//        ctrl.intersectWidth = 40;
//        self.presentViewController(ctrl, animated: true, completion: nil);
//
        
        
        
//        if presented == false {
        
//            let ctrl = TopMenuViewController(nibName: "TopMenuViewController", bundle: NSBundle.mainBundle());
//            ctrl.transitioningDelegate = self;
//            ctrl.modalPresentationStyle = UIModalPresentationStyle.Custom;
//            
//            self.presentViewController(ctrl, animated: true) { (result) -> Void in
//                self.presented = true;
//            }
//        } else {
//            self.dismissViewControllerAnimated(true, completion: nil);
//            self.presented = false;
//        }
        
    }
    
    
    class func attachChild(child: UIViewController, parent: UIViewController) {
        child.willMoveToParentViewController(parent);
        
        parent.view.addSubview(child.view);
        
        let views = ["view":child.view] as [String: AnyObject];
        
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options:NSLayoutFormatOptions(), metrics:nil, views:views);
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options:NSLayoutFormatOptions(), metrics:nil, views:views);
        
        parent.view.addConstraints(horizontal);
        parent.view.addConstraints(vertical);
        
        parent.addChildViewController(child);
        
        child.didMoveToParentViewController(parent);
    }
    


}


extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.presenting = true;
        return self.animator;
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.presenting = false;
        return self.animator;
    }

}
