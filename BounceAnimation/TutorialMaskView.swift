//
//  TutorialMaskView.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 19/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit

class TutorialLightPath: NSObject {
    let path: UIBezierPath;
    
    init(path: UIBezierPath) {
        self.path = path;
    }
    
    convenience init(ovalPath: CGRect) {
        let path = UIBezierPath(ovalInRect: ovalPath);
        self.init(path: path);
    }
    
    convenience init(rectPath: CGRect) {
        let path = UIBezierPath(rect: rectPath);
        self.init(path: path);
    }
    
}

class TutorialMaskView: UIView {
    
    var paths = [TutorialLightPath]()
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        
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
    }

}
