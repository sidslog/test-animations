//
//  TutorialMaskView.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 19/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

let arrowHeight: CGFloat = 30
let arrowWidth: CGFloat = 30

let maxTextWidth: CGFloat = 200
let maxTextHeight: CGFloat = 200

class TutorialLightPath: NSObject {
    let path: UIBezierPath!;
    let arrowPath: UIBezierPath!
    
    init(path: UIBezierPath, arrowPath: UIBezierPath) {
        self.path = path
        self.arrowPath = arrowPath
    }
    
    convenience init(oval: CGRect, arrowPosition: ViewHighlightArrowPosition) {
        let path = UIBezierPath(ovalInRect: oval);
        let arrowPath = arrowPathFromRect(oval, arrowPosition: arrowPosition)
        self.init(path: path, arrowPath: arrowPath);
    }
    
    convenience init(rect: CGRect, arrowPosition: ViewHighlightArrowPosition) {
        let path = UIBezierPath(rect: rect);
        let arrowPath = arrowPathFromRect(rect, arrowPosition: arrowPosition)
        self.init(path: path, arrowPath: arrowPath);
    }
}

private func arrowPathFromRect(rect: CGRect, arrowPosition: ViewHighlightArrowPosition) -> UIBezierPath! {
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
        
        let fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).CGColor
        let strokeColor = UIColor(red: 233/255.0, green: 157/255.0, blue: 2/255.0, alpha: 0.5).CGColor
        
        CGContextSetFillColor(ctx, CGColorGetComponents(fillColor));
        CGContextSetStrokeColor(ctx, CGColorGetComponents(strokeColor));
        
        CGContextEOFillPath(ctx);
        
        CGContextRestoreGState(ctx)
    }
    
    func drawArrows(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        let path = CGPathCreateMutable();
        
        for lightPath in self.paths {
            CGPathAddPath(path, nil, lightPath.arrowPath.CGPath);
        }

        CGContextAddPath(ctx, path);

        let fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
        CGContextSetFillColor(ctx, CGColorGetComponents(fillColor));
        
        CGContextFillPath(ctx)
        
        CGContextRestoreGState(ctx)
    }

}
