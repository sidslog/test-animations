//
//  TutorialTextBubble.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 12/01/16.
//  Copyright © 2016 Sergey Sedov. All rights reserved.
//

import UIKit

class TutorialTextBubble: UIView {

    weak var label: UILabel?
    
    var text = "" {
        didSet {
            self.label?.text = text
        }
    }
    
    var textColor = UIColor.whiteColor() {
        didSet {
            self.label?.textColor = textColor
        }
    }
    
    var font = UIFont.systemFontOfSize(UIFont.labelFontSize()) {
        didSet {
            self.label?.font = font
        }
    }

    init() {
        super.init(frame: CGRectZero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = true

        let label = UILabel()
        label.numberOfLines = 0;
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        
        self.addSubview(label)
        self.label = label
        
        let views = ["view":label] as [String: AnyObject]
        
        let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[view]-10-|", options:NSLayoutFormatOptions(), metrics:nil, views:views)
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[view]-10-|", options:NSLayoutFormatOptions(), metrics:nil, views:views)
        
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attachToSuperView(background: UIView, arrowPosition: ViewHighlightArrowPosition, rect: CGRect, arrowHeight: CGFloat) {
        
        background.addSubview(self)
        
        var constraints: [NSLayoutConstraint]
        
        switch arrowPosition {
        case .Down:
            constraints = [
                self.topEqual(background, attribute: NSLayoutAttribute.Top, offset: -(rect.maxY + arrowHeight)),
                self.leftCenter(background, offset: -rect.midX),
            ]
        case .Up:
            constraints = [
                self.topEqual(background, attribute: NSLayoutAttribute.Bottom, offset: -(rect.minY - arrowHeight)),
                self.leftCenter(background, offset: -rect.midX),
            ]
        case .Right:
            constraints = [
                self.leftEqual(background, attribute: NSLayoutAttribute.Left, offset: -(rect.maxX + arrowHeight)),
                self.topCenter(background, offset: -rect.midY),
            ]
        case .Left:
            constraints = [
                self.leftEqual(background, attribute: NSLayoutAttribute.Right, offset: -(rect.minX - arrowHeight)),
                self.topCenter(background, offset: -rect.midY),
            ]
        }
        
        background.addConstraints(constraints)
        
        background.addConstraints([
            self.edgeLess(background, attribute: NSLayoutAttribute.Left, offset: -10),
            self.edgeLess(background, attribute: NSLayoutAttribute.Top, offset: -10),
            self.edgeGreater(background, attribute: NSLayoutAttribute.Bottom, offset: 10),
            self.edgeGreater(background, attribute: NSLayoutAttribute.Right, offset: 10)
            ]);
    }


    func edgeGreater(background: UIView, attribute: NSLayoutAttribute, offset: CGFloat) -> NSLayoutConstraint {
        let constraint =  NSLayoutConstraint(item: background, attribute: attribute, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self, attribute: attribute, multiplier: 1, constant: offset);
        constraint.priority = UILayoutPriorityRequired
        return constraint;
    }
    func edgeLess(background: UIView, attribute: NSLayoutAttribute, offset: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: background, attribute: attribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: attribute, multiplier: 1, constant: offset);
        constraint.priority = UILayoutPriorityRequired
        return constraint;
    }
    
    func topEqual(background: UIView, attribute: NSLayoutAttribute, offset: CGFloat) -> NSLayoutConstraint {
        let constraint =  NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: attribute, multiplier: 1, constant: offset);
        constraint.priority = UILayoutPriorityDefaultHigh
        return constraint;
    }
    
    func leftEqual(background: UIView, attribute: NSLayoutAttribute, offset: CGFloat) -> NSLayoutConstraint {
        let constraint =  NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: attribute, multiplier: 1, constant: offset);
        constraint.priority = UILayoutPriorityDefaultHigh
        return constraint;
    }
    
    func leftCenter(background: UIView, offset: CGFloat) -> NSLayoutConstraint {
        let constraint =  NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: offset);
        constraint.priority = UILayoutPriorityDefaultHigh
        return constraint;
    }
    
    func topCenter(background: UIView, offset: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: offset);
        constraint.priority = UILayoutPriorityDefaultHigh
        return constraint;
    }
    
    
}
