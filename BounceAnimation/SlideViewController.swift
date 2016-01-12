//
//  SlideViewController.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 14/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit
import QuartzCore

protocol SlideViewControllerDelegate : class {
    func numberOfViewControllers() -> Int;
    func viewControllerForIndex(index: Int) -> UIViewController;
}

enum ViewLevel {
    case LeftLeft, Left, Center, Right, RightRight
}

class SlideViewController: UIViewController {

    var cards: [Card] = [];
    weak var delegate: SlideViewControllerDelegate?;
    
    var scaleMultiplier: CGFloat = 0.8;
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 40, left: 10, bottom: 40, right: 10);
    var intersectWidth: CGFloat = 10;

    private weak var leftViewController: UIViewController?
    private weak var centerViewController: UIViewController?
    private weak var rightViewController: UIViewController?
    private weak var leftLeftViewController: UIViewController?
    private weak var rightRightViewController: UIViewController?

    private var numberOfControllers: Int! = 0
    
    private var leftView: UIView?  {
        return self.leftViewController?.view;
    }
    
    private weak var centerView: UIView? {
        return self.centerViewController?.view;
    }
    private weak var rightView: UIView? {
        return self.rightViewController?.view;
    }
    
    private weak var leftLeftView: UIView? {
        return self.leftLeftViewController?.view;
    }
    private weak var rightRightView: UIView? {
        return self.rightRightViewController?.view;
    }
    
    private var panRecognizer: UIPanGestureRecognizer?
    private var originX: CGFloat = 0;
    
    var currentIndex: Int = 0;
    
    var didReloadAfterLayout = false;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for i in 1...7 {
            let card = Card(name: "\(i)")
            cards.append(card);
        }
        
        self.currentIndex = 1;

        self.delegate = self;
        
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: "onPan:");
        self.view.addGestureRecognizer(self.panRecognizer!);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didReloadAfterLayout {
            self.reloadData();
            self.didReloadAfterLayout = true;
        }
    }
    
    // MARK: public
    
    func reloadData() {
        self.reloadNumberOfControllers();
        self.clearControllersAndViews();
        self.drawViews();
        self.applyHierarchy();
    }
    
    func insertAnimated(index: Int) {
        self.reloadNumberOfControllers();
        
        // if we insert view controller before visible controllers, we just need increment current index
        if index < self.currentIndex - 1 {
            self.currentIndex++;
            return;
        } else if index > self.currentIndex + 2 {
            // if we insert view controller after visible controllers, we do nothing
            return;
        } else {
            // if we insert view controller in visible area
            if index == self.currentIndex + 2 {
                // rightright
                if let _ = self.delegate?.viewControllerForIndex(index) {
                    self.removeControllerFromParent(self.rightRightViewController);
                    self.drawViews()
                }
            } else if index == self.currentIndex - 1 {
                // leftleft
                if let _ = self.delegate?.viewControllerForIndex(index) {
                    self.removeControllerFromParent(self.leftLeftViewController);
                    self.currentIndex++;
                    self.drawViews();
                }
            } else if index == self.currentIndex + 1 {
                // right
                if let viewController = self.delegate?.viewControllerForIndex(index) {
                    self.removeControllerFromParent(self.rightRightViewController);
                    self.rightRightViewController = self.rightViewController;
                    self.animateDefaultTransform(0.4, completion: { () -> () in
                        self.rightViewController = viewController;
                        self.insertViewAnimated(self.rightViewController!, level: .Right);
                    })
                }
            } else {
                // left
                if let viewController = self.delegate?.viewControllerForIndex(index) {
                    self.removeControllerFromParent(self.leftLeftViewController);
                    self.leftLeftViewController = self.leftViewController;
                    self.animateDefaultTransform(0.4, completion: { () -> () in
                        self.currentIndex++
                        self.leftViewController = viewController;
                        self.insertViewAnimated(self.leftViewController!, level: .Left);
                    })
                }
            }
        }
    }
    
    func removeCurrentAnimated(forward: Bool) {
        self.reloadNumberOfControllers();
        
        let vcToRemove = self.centerViewController;
        
        if (self.numberOfControllers == 0) {
            self.removeControllerAnimated(vcToRemove);
            return;
        }
        
        if (forward) {
            if (self.currentIndex == self.numberOfControllers) {
                self.removeCurrentAnimated(false);
                return;
            }
            self.centerViewController = self.rightViewController;
            self.rightViewController = self.rightRightViewController;
            self.removeControllerFromParent(self.rightRightViewController);
        } else {
            if self.currentIndex == 0 {
                self.removeCurrentAnimated(true);
                return;
            }
            self.centerViewController = self.leftViewController;
            self.leftViewController = self.leftLeftViewController;
            self.removeControllerFromParent(self.leftLeftViewController);
        }
        
        self.removeControllerAnimated(vcToRemove);
        
        self.applyHierarchy();
        self.animateDefaultTransform(0.2, completion: {
            if forward == false {
                if self.currentIndex > 0 {
                    self.currentIndex--;
                }
            }
            self.drawViews();
        });
    }

    // MARK: gesture recognizers methods
    
    func onPan(recognizer: UIPanGestureRecognizer) {
        if let _ = recognizer.view {
            switch(recognizer.state) {
            case .Began:
                self.originX = recognizer.locationInView(self.view).x;
                break;
            case .Changed:
                let dx = recognizer.locationInView(self.view).x - self.originX;
                self.applyTransform(dx, level: .LeftLeft, view: self.leftLeftView);
                self.applyTransform(dx, level: .Left, view: self.leftView);
                self.applyTransform(dx, level: .Right, view: self.rightView);
                self.applyTransform(dx, level: .RightRight, view: self.rightRightView);
                self.applyTransform(dx, level: .Center, view: self.centerView);
                break;
            case .Ended:
                let dx = recognizer.locationInView(self.view).x - self.originX;
                self.endTransition(dx);
                break;
                
            default:
                break;
            }
        }
        
    }
    
    // MARK: private
    
    private func reloadNumberOfControllers() {
        if let n = self.delegate?.numberOfViewControllers() {
            self.numberOfControllers = n;
        }
    }
    
    private func clearControllersAndViews() {
        self.removeControllerFromParent(self.leftLeftViewController);
        self.removeControllerFromParent(self.leftViewController);
        self.removeControllerFromParent(self.centerViewController);
        self.removeControllerFromParent(self.rightViewController);
        self.removeControllerFromParent(self.rightRightViewController);
    }
    
    private func removeControllerFromParent(viewController: UIViewController?) {
        viewController?.willMoveToParentViewController(nil);
        viewController?.view.removeFromSuperview();
        viewController?.removeFromParentViewController();
        viewController?.didMoveToParentViewController(nil);
    }
    
    private func removeControllerAnimated(viewController: UIViewController?) {
        if let viewController = viewController {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                var transform = viewController.view.transform;
                transform = CGAffineTransformTranslate(transform, 0, self.view.bounds.size.height);
                viewController.view.transform = transform;
                }) { (finished) -> Void in
                    self.removeControllerFromParent(viewController);
            };
        }
    }
    
    private func drawViews() {
        if (currentIndex > 0) {
            if self.leftView == nil {
                if let prevController = self.delegate?.viewControllerForIndex(self.currentIndex - 1) {
                    self.leftViewController = prevController;
                    self.drawView(prevController, level: .Left);
                }
            }
            
            if (currentIndex > 1) {
                if self.leftLeftView == nil {
                    if let prevController = self.delegate?.viewControllerForIndex(self.currentIndex - 2) {
                        self.leftLeftViewController = prevController;
                        self.drawView(prevController, level: .LeftLeft);
                    }
                }
            }
        }
        
        if self.centerView == nil {
            if let viewController = self.delegate?.viewControllerForIndex(self.currentIndex) {
                self.centerViewController = viewController;
                self.drawView(viewController, level: .Center);
            }
        }
        
        if self.numberOfControllers > self.currentIndex + 1 {
            if self.rightView == nil {
                if let nextController = self.delegate?.viewControllerForIndex(self.currentIndex + 1) {
                    self.rightViewController = nextController;
                    self.drawView(nextController, level: .Right);
                }
            }
        
            if self.numberOfControllers > self.currentIndex + 2 {
                if self.rightRightView == nil {
                    if let nextController = self.delegate?.viewControllerForIndex(self.currentIndex + 2) {
                        self.rightRightViewController = nextController;
                        self.drawView(nextController, level: .RightRight);
                    }
                }
            }
        }
    }
    
    private func insertViewAnimated(viewController: UIViewController, level: ViewLevel) {
        self.drawView(viewController, level: level);
        var transform = viewController.view.transform;
        transform = CGAffineTransformTranslate(transform, 0, -self.view.bounds.size.height);
        viewController.view.transform = transform;
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            viewController.view.transform = self.defaultTransform(level);
        })
        
    }
    
    private func drawView(viewController: UIViewController, level: ViewLevel) {
        viewController.willMoveToParentViewController(self);
        self.view.addSubview(viewController.view);
        self.addConstraintsForView(viewController.view, level: level);
        self.addChildViewController(viewController);
        viewController.didMoveToParentViewController(self);
        viewController.view.transform = self.defaultTransform(level);
    }
    
    private func addConstraintsForView(view: UIView, level: ViewLevel) {
        let views = ["view":view] as [String: AnyObject];
        
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(self.edgeInsets.left)-[view]-\(self.edgeInsets.right)-|", options:NSLayoutFormatOptions(), metrics:nil, views:views);
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(self.edgeInsets.top)-[view]-\(self.edgeInsets.bottom)-|", options:NSLayoutFormatOptions(), metrics:nil, views:views);

        view.superview!.addConstraints(horizontal);
        view.superview!.addConstraints(vertical);
    }
    
    
    private func defaultTranslate(level: ViewLevel) -> CGAffineTransform {
        switch(level) {
        case .LeftLeft:
            let transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width * 2 + self.intersectWidth * 2, 0);
            return transform;
        case .Left:
            let transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width + self.intersectWidth, 0);
            return transform;
        case .Center:
            return CGAffineTransformIdentity;
        case .Right:
            let transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width - self.intersectWidth, 0);
            return transform;
        case .RightRight:
            let transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width * 2 - self.intersectWidth * 2, 0);
            return transform;
        }

    }
    
    private func defaultTransform(level: ViewLevel) -> CGAffineTransform {
        var transform = self.defaultTranslate(level);
        let scale = self.scaleMultiplierByDx(transform.tx);
        transform = CGAffineTransformScale(transform, scale, scale);
        return transform;
    }
    
    private func endTransition(dx: CGFloat) {
        var next: Bool?
        
        var animationDuration: NSTimeInterval = 0.2;
        
        // change views
        if (abs(dx) > self.view.bounds.size.width / 6) {
            
            animationDuration = animationDuration * NSTimeInterval( abs(dx) / (self.view.bounds.size.width / 2));
            
            if (dx > 0) {
                if self.currentIndex > 0 {
                    self.rightRightViewController = self.rightViewController;
                    self.rightViewController = self.centerViewController;
                    self.centerViewController = self.leftViewController;
                    self.leftViewController = self.leftLeftViewController;
                    self.leftLeftViewController = nil;
                    
                    self.removeControllerFromParent(self.rightRightViewController);
                    next = false;
                }
            } else {
                    if self.numberOfControllers > self.currentIndex + 1 {
                        self.leftLeftViewController = self.leftViewController;
                        self.leftViewController = self.centerViewController;
                        self.centerViewController = self.rightViewController;
                        self.rightViewController = self.rightRightViewController;
                        self.rightRightViewController = nil;
                        
                        self.removeControllerFromParent(self.leftLeftViewController);
                        next = true;
                    }
            }
            self.applyHierarchy();
        } else {
            animationDuration = animationDuration * (1 - NSTimeInterval(abs(dx) / (self.view.bounds.size.width / 2)));
        }
        
        self.animateDefaultTransform(animationDuration, completion: {
            if let next = next {
                if (next) {
                    self.currentIndex++;
                } else {
                    self.currentIndex--;
                }
                self.drawViews();
            }
        });
    }
    
    private func animateDefaultTransform(duration: NSTimeInterval, completion: (() -> ())) {
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.applyDefaultTransform();
            }) { (finished) -> Void in
                if finished {
                    completion()
                }
        }
    }
    
    private func applyHierarchy() {
        if let view = self.rightRightView {
            self.view.bringSubviewToFront(view);
        }
        if let view = self.leftLeftView {
            self.view.bringSubviewToFront(view);
        }
        if let view = self.rightView {
            self.view.bringSubviewToFront(view);
        }
        if let view = self.leftView {
            self.view.bringSubviewToFront(view);
        }
        if let view = self.centerView {
            self.view.bringSubviewToFront(view);
        }
    }
    
    
    private func applyDefaultTransform() {
        if let view = self.leftView {
            view.transform = self.defaultTransform(.Left);
        }
        if let view = self.centerView {
            view.transform = self.defaultTransform(.Center);
        }
        if let view = self.rightView {
            view.transform = self.defaultTransform(.Right);
        }
        if let view = self.rightRightView {
            view.transform = self.defaultTransform(.RightRight);
        }
        if let view = self.leftLeftView {
            view.transform = self.defaultTransform(.LeftLeft);
        }
    }
    
    private func applyTransform(dx: CGFloat, level: ViewLevel, view: UIView?) {
        if let view = view {
            var transform = self.defaultTranslate(level);
            transform = CGAffineTransformTranslate(transform, dx, 0)
            let scale = self.scaleMultiplierByDx(transform.tx);
            transform = CGAffineTransformScale(transform, scale, scale);
            view.transform = transform;
        }
    }
    
    private func scaleMultiplierByDx(dx: CGFloat) -> CGFloat {
        let absDX = abs(dx);
        let diff = absDX / (self.view.bounds.size.width / 2 - 10); // 0 -> 1
        let scale = (1 - self.scaleMultiplier) * diff;
        return 1 - scale;
    }
}

extension SlideViewController: SlideViewControllerDelegate {
    func viewControllerForIndex(index: Int) -> UIViewController {
        return CardViewController(card: self.cards[index]);
    }
    
    func numberOfViewControllers() -> Int {
        return self.cards.count;
    }
}
