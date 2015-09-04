//
//  ArrowDrawing.swift
//  BounceAnimation
//
//  Created by Sergey Sedov on 26/08/15.
//  Copyright (c) 2015 Sergey Sedov. All rights reserved.
//

import UIKit


struct Arrow {
    let startPoint: CGPoint!;
    let endPoint: CGPoint!;
    let arrowHead: ArrowHead!;
    
    func arrowPath() -> CGPath {
        // no curve right now
        var path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, self.startPoint.x, self.startPoint.y);
        
        
        let tangentX1 = startPoint.x + (endPoint.x - startPoint.x) / 4
        let tangentY1 = startPoint.y //+ (endPoint.y - startPoint.y) / 8
        
        let tangentX2 = endPoint.x //- (endPoint.x - startPoint.x) / 4
        let tangentY2 = endPoint.y //- 8 * (endPoint.y - startPoint.y) / 8
        
        
//        let midPoint = CGPointMake(self.endPoint.x - (self.endPoint.x - self.startPoint.x) / 4, self.endPoint.y - (self.endPoint.y - self.startPoint.y) / 4)
        
        CGPathAddCurveToPoint(path, nil, tangentX1, tangentY1, tangentX2, tangentY2, endPoint.x, endPoint.y)
        
        
//        CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
        return path;
    }
    
    func headPath() -> CGPath {
        var path = CGPathCreateMutable();
        let (end1, end2) = self.arrowEnds();
        CGPathMoveToPoint(path, nil, end1.x, end1.y);
        CGPathAddLineToPoint(path, nil, self.endPoint.x, self.endPoint.y);
        CGPathMoveToPoint(path, nil, self.endPoint.x, self.endPoint.y);
        CGPathAddLineToPoint(path, nil, end2.x, end2.y);
        return path;
    }
    
    func arrowEnds() -> (CGPoint, CGPoint) {
        
        // no curve right now
        var x1 = Double(self.startPoint.x)
        var y1 = Double(self.startPoint.y)
        
        var x2 = Double(self.endPoint.x)
        var y2 = Double(self.endPoint.y)

        var yDiff = y2 - y1
        var xDiff = x2 - x1
        
        var length = sqrt(xDiff * xDiff + yDiff * yDiff)
        
        var b = acos(Double((y2 - y1) / length))
        
        var t = self.arrowHead.angle - b
        var l = Double(self.arrowHead.length)
        
        var x3 = CGFloat(x2 + l * sin(t))
        var y3 = CGFloat(y2 - l * cos(t))
        
        var x4 = CGFloat(x2 - l * cos(t))
        var y4 = CGFloat(x2 + l * sin(t))
        
        return (CGPointMake(x3, y3), CGPointMake(x4, y4))
    }
}

struct ArrowHead {
    let angle: Double;
    let length: CGFloat!;
}


class ArrowView: UIView {

    let arrow: Arrow!

    var animationDuration: CFTimeInterval = 3;
    var strokeColor = UIColor.blackColor();
    var lineWidth: CGFloat = 2;
    
    lazy var arrowLayer: CAShapeLayer = {
        let layer = CAShapeLayer();
        self.layer.addSublayer(layer);
        return layer;
    }()
    
    lazy var headLayer: CAShapeLayer = {
        let layer = CAShapeLayer();
        self.layer.addSublayer(layer);
        return layer;
    }()
    
    init(arrow: Arrow, frame: CGRect) {
        self.arrow = arrow;
        super.init(frame: frame);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    func updateArrowLayer() {
        self.applyStyle(self.arrowLayer)
        self.applyBounds(self.arrowLayer);
        self.arrowLayer.path = self.arrow.arrowPath()
    }

    func updateHeadLayer() {
        self.applyStyle(self.headLayer)
        self.applyBounds(self.headLayer)
        self.headLayer.path = self.arrow.headPath()
    }
    
    func applyStyle(layer: CAShapeLayer) {
        layer.strokeColor = self.strokeColor.CGColor;
        layer.lineWidth = self.lineWidth;
        layer.fillColor = nil;
    }
    
    func applyBounds(layer: CAShapeLayer) {
        layer.bounds = self.bounds
        layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    }
    
    func drawArrow() {
        self.updateArrowLayer()
        self.updateHeadLayer()
        self.addAnimations()
    }
    
    func addAnimations() {
        
        var arrowAnimationDuration = 2 * self.animationDuration / 3;
        var headAnimationDuration = 2 * self.animationDuration / 3;
        
        var animation = CABasicAnimation(keyPath: "strokeEnd");
        animation.duration = arrowAnimationDuration;
        animation.fromValue = 0;
        animation.toValue = 1;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn);
        
        var headHidden = CABasicAnimation(keyPath: "strokeEnd");
        headHidden.duration = arrowAnimationDuration;
        headHidden.fromValue = 0;
        headHidden.toValue = 0;
        
        var headAnimationLeft = CABasicAnimation(keyPath: "strokeEnd");
        headAnimationLeft.duration = headAnimationDuration;
        headAnimationLeft.fromValue = 0.5;
        headAnimationLeft.toValue = 1;
        headAnimationLeft.beginTime = 2;
        headAnimationLeft.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut);
        
        var headAnimationRight = CABasicAnimation(keyPath: "strokeStart");
        headAnimationRight.duration = headAnimationDuration;
        headAnimationRight.fromValue = 0.5;
        headAnimationRight.toValue = 0;
        headAnimationRight.beginTime = 2;
        headAnimationRight.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut);
        
        var animationGroup = CAAnimationGroup();
        animationGroup.duration = self.animationDuration;
        animationGroup.animations = [headHidden, headAnimationRight, headAnimationLeft];
        
        self.arrowLayer.addAnimation(animation, forKey: "SCArrowDrawAnimation");
        self.headLayer.addAnimation(animationGroup, forKey: "SCArrowDrawHeadAnimation");
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawArrow()
    }
}
