//
//  TutorialPage.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 19/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

enum ViewHighlightType {
    case Round, Rect
}

enum ViewHighlightArrowPosition {
    case Up, Right, Down, Left
}

class ViewHighlight {
    weak var view: UIView?;
    
    let highlightType: ViewHighlightType;
    let message: String!;
    var inset: CGFloat = 10;
    
    var arrowPosition = ViewHighlightArrowPosition.Down
    var arrowWidth: CGFloat = 20
    var arrowHeight: CGFloat = 10
    var font = UIFont.systemFontOfSize(UIFont.labelFontSize())
    var textColor = UIColor.blackColor()
    var bubbleBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var opacity: Float = 1
    
    init(view: UIView, highlightType: ViewHighlightType, message: String = "") {
        self.view = view;
        self.highlightType = highlightType;
        self.message = message;
    }
}


class TutorialPageAnimator: UIViewController {

    
    // viewsToHighLight must be in view hierarchy with backgroundView
    weak var backgroundView: UIView?
    var viewsToHighlight: [ViewHighlight]!
    var dimViewColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    
    var didSelectHighlightedView: (UIView? -> Void)?
    var tapRecognizer: UITapGestureRecognizer?
    var acceptTapsOnlyOnHighlightedViews = false
    
    init(backgroundView: UIView, viewsToHighlight: [ViewHighlight]) {
        self.backgroundView = backgroundView;
        self.viewsToHighlight = viewsToHighlight;
        super.init(nibName: nil, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        self.view.backgroundColor = UIColor.clearColor();
        self.addTapRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: public
    
    func present(viewController: UIViewController) {
        // create a view with "holes" in places of viewsToHighlight
        ViewController.attachChild(self, parent: viewController);
        
        let background = self.createBackground();
        self.attachBackground(background);
        
        let paths = self.createPaths();
        self.attachPaths(paths, background: background);
        
        self.addTextViews(background)
    }
    
    func dismiss() {
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        self.didMoveToParentViewController(nil)
    }
    
    // MARK: private

    private func addTextViews(background: TutorialMaskView) {
        for hView in viewsToHighlight {
            if let view = hView.view {
                var rect = view.convertRect(view.bounds, toView: self.backgroundView);
                rect.insetInPlace(dx: -hView.inset, dy: -hView.inset);
                
                let textBack = TutorialTextBubble()
                textBack.text = hView.message;
                textBack.font = hView.font
                textBack.textColor = hView.textColor
                textBack.backgroundColor = hView.bubbleBackgroundColor
                textBack.layer.opacity = hView.opacity
                textBack.attachToSuperView(background, arrowPosition: hView.arrowPosition, rect: rect, arrowHeight: hView.arrowHeight)
            }
        }
    }
    
    private func createPaths() -> [TutorialLightPath] {
        var paths = [TutorialLightPath]()
        for hView in viewsToHighlight {
            if let view = hView.view {
                var rect = view.convertRect(view.bounds, toView: self.backgroundView);
                rect.insetInPlace(dx: -hView.inset, dy: -hView.inset);
                var lightPath: TutorialLightPath!
                if hView.highlightType == .Round {
                    lightPath = TutorialLightPath(oval: rect, arrowPosition: hView.arrowPosition, arrowWidth: hView.arrowWidth, arrowHeight:  hView.arrowHeight)
                } else {
                    lightPath = TutorialLightPath(rect: rect, arrowPosition: hView.arrowPosition, arrowWidth: hView.arrowWidth, arrowHeight:  hView.arrowHeight);
                }
                lightPath.arrowOpacity = hView.opacity
                lightPath.arrowColor = hView.bubbleBackgroundColor;
                paths.append(lightPath)
            }
        }
        return paths;
    }
    
    private func createBackground() -> TutorialMaskView {
        let view = TutorialMaskView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.backgroundColor = UIColor.clearColor();
        view.dimViewColor = self.dimViewColor;
        return view;
    }
    
    private func attachPaths(paths: [TutorialLightPath], background: TutorialMaskView) {
        background.paths = paths;
    }
    
    private func attachBackground(background: TutorialMaskView) {
        self.view.addSubview(background);
        
        let views = ["view":background] as [String: AnyObject];
        
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options:NSLayoutFormatOptions(), metrics:nil, views:views);
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options:NSLayoutFormatOptions(), metrics:nil, views:views);
        
        self.view.addConstraints(horizontal);
        self.view.addConstraints(vertical);
    }
    
    private func addTapRecognizer() {
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "onTap:")
        self.view.addGestureRecognizer(self.tapRecognizer!)
    }
    
    func onTap(recognizer: UITapGestureRecognizer) {
        if self.acceptTapsOnlyOnHighlightedViews {
            let tapPoint = recognizer.locationInView(self.view)
            for hView in viewsToHighlight {
                if let view = hView.view {
                    var rect = view.convertRect(view.bounds, toView: self.view);
                    rect.insetInPlace(dx: -hView.inset, dy: -hView.inset);
                    if rect.contains(tapPoint) {
                        if let closure = self.didSelectHighlightedView {
                            closure(hView.view)
                        }
                        self.dismiss()
                        return
                    }
                }
            }
        } else {
            if let closure = self.didSelectHighlightedView {
                closure(nil)
            }
            self.dismiss()
        }
    }
    
}
