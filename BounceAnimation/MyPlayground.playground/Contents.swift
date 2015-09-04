//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


var a = M_PI_4 / 2

var l: Double = 4

var x1: Double = 0
var y1: Double = 0

var x2: Double = 100
var y2: Double = 100

var yDiff = y2 - y1
var xDiff = x2 - x1

var length = sqrt(xDiff * xDiff + yDiff * yDiff)

var b = acos(Double((y2 - y1) / length))

var t = a - b

var x3 = x2 + l * sin(t)
var y3 = y2 - l * cos(t)

var x4 = x2 - l * cos(t)
var y4 = x2 + l * sin(t)

UIGraphicsBeginImageContext(CGSizeMake(100, 100))

let ctx = UIGraphicsGetCurrentContext();

var path = CGPathCreateMutable();

let startPoint: CGPoint! = CGPointMake(CGFloat(x1), CGFloat(y1))
let endPoint: CGPoint! = CGPointMake(CGFloat(x2), CGFloat(y2));


CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);

let tangentX1: CGFloat = 100.0//startPoint.x + (endPoint.x - startPoint.x) / 4
let tangentY1: CGFloat = 0//startPoint.y //+ (endPoint.y - startPoint.y) / 8

let tangentX2 = endPoint.x - (endPoint.x - startPoint.x) / 4
let tangentY2 = endPoint.y - 8 * (endPoint.y - startPoint.y) / 8

//

CGPathAddArcToPoint(path, nil, tangentX1, tangentX2, endPoint.x, endPoint.y, 100)

CGContextAddPath(ctx, path)

CGContextStrokePath(ctx)

let image = UIGraphicsGetImageFromCurrentImageContext()
