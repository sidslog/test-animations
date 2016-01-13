//
//  TutorialMaskView.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 19/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

class TutorialLightPath: NSObject {
    let path: UIBezierPath!;
    let arrowPath: UIBezierPath!
    
    var arrowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var arrowOpacity: Float = 1
    
    init(path: UIBezierPath, arrowPath: UIBezierPath) {
        self.path = path
        self.arrowPath = arrowPath
    }
    
    convenience init(oval: CGRect, arrowPosition: ViewHighlightArrowPosition, arrowWidth: CGFloat, arrowHeight: CGFloat) {
        let path = UIBezierPath(ovalInRect: oval);
        let arrowPath = arrowPathFromRect(oval, arrowPosition: arrowPosition, arrowWidth: arrowWidth, arrowHeight: arrowHeight)
        self.init(path: path, arrowPath: arrowPath);
    }
    
    convenience init(rect: CGRect, arrowPosition: ViewHighlightArrowPosition, arrowWidth: CGFloat, arrowHeight: CGFloat) {
        let path = UIBezierPath(rect: rect);
        let arrowPath = arrowPathFromRect(rect, arrowPosition: arrowPosition, arrowWidth: arrowWidth, arrowHeight: arrowHeight)
        self.init(path: path, arrowPath: arrowPath);
    }
}

private func arrowPathFromRect(rect: CGRect, arrowPosition: ViewHighlightArrowPosition, arrowWidth: CGFloat, arrowHeight: CGFloat) -> UIBezierPath! {
    let result = UIBezierPath()
    
    var startPoint: CGPoint
    var base1Point: CGPoint
    var base2Point: CGPoint
    
    switch(arrowPosition) {
    case .Up:
        startPoint = CGPointMake(rect.midX, rect.minY)
        base1Point = CGPointMake(rect.midX - arrowWidth / 2, rect.minY - arrowHeight)
        base2Point = CGPointMake(rect.midX + arrowWidth / 2, rect.minY - arrowHeight)
    case .Down:
        startPoint = CGPointMake(rect.midX, rect.maxY)
        base1Point = CGPointMake(rect.midX - arrowWidth / 2, rect.maxY + arrowHeight)
        base2Point = CGPointMake(rect.midX + arrowWidth / 2, rect.maxY + arrowHeight)
    case .Left:
        startPoint = CGPointMake(rect.minX, rect.midY)
        base1Point = CGPointMake(rect.minX - arrowHeight, rect.midY - arrowWidth / 2)
        base2Point = CGPointMake(rect.minX - arrowHeight, rect.midY + arrowWidth / 2)
    case .Right:
        startPoint = CGPointMake(rect.maxX, rect.midY)
        base1Point = CGPointMake(rect.maxX + arrowHeight, rect.midY - arrowWidth / 2)
        base2Point = CGPointMake(rect.maxX + arrowHeight, rect.midY + arrowWidth / 2)
    }
    
    result.moveToPoint(startPoint)
    result.addLineToPoint(base1Point)
    result.addLineToPoint(base2Point)
    result.addLineToPoint(startPoint)
    return result;
}

class TutorialMaskView: UIView {
    
    var dimViewColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    
    var paths = [TutorialLightPath]() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
        self.drawLightPaths(rect)
        self.drawArrows(rect)
    }
    
    func drawLightPaths(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGContextClearRect(ctx, rect);
        
        let path = CGPathCreateMutable();
        
        CGPathAddRect(path, nil, rect);
        
        for lightPath in self.paths {
            CGPathAddPath(path, nil, lightPath.path.CGPath);
        }
        
        CGContextAddPath(ctx, path);
        
        let fillColor = self.dimViewColor.CGColor
        
        CGContextSetFillColor(ctx, CGColorGetComponents(fillColor));
        
        CGContextEOFillPath(ctx);
        
        CGContextRestoreGState(ctx)
    }
    
    func drawArrows(rect: CGRect) {
        for lightPath in self.paths {
            let ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            
            let path = CGPathCreateMutable();
            
            CGPathAddPath(path, nil, lightPath.arrowPath.CGPath);
            
            CGContextAddPath(ctx, path);
            
            let fillColor = lightPath.arrowColor.colorWithAlphaComponent(CGFloat(lightPath.arrowOpacity)).CGColor
            CGContextSetFillColor(ctx, CGColorGetComponents(fillColor));
            
            CGContextFillPath(ctx)
            
            CGContextRestoreGState(ctx)
        }

    }

}
