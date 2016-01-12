//
//  TagFlowLayout.swift
//  Boardmaps
//
//  Created by Sergey Sedov on 5/8/15.
//  Copyright (c) 2015 Dashboard Systems. All rights reserved.
//

import UIKit

@objc class TagCenterFlowLayout: UICollectionViewFlowLayout {
    
    private let tagSpace: CGFloat = 15
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElementsInRect(rect) {
            let sortedAttributes = attributes.sort( { (obj1, obj2) -> Bool in
                if obj1.indexPath.section == obj2.indexPath.section {
                    return obj1.indexPath.row < obj2.indexPath.row;
                } else {
                    return obj1.indexPath.section < obj2.indexPath.section;
                }
            })
            
            let sectionInset = (self.collectionView!.delegate as! UICollectionViewDelegateFlowLayout!).collectionView!(self.collectionView!, layout: self, insetForSectionAtIndex: 0);
            
            var maxY: CGFloat = 0;
            var minY: CGFloat = 0;
            
            for (index, attribute) in sortedAttributes.enumerate() {
                var currentFrameY: CGFloat = 0;
                
                if index > 0 {
                    if index == 1 {
                        let currentFrame = attribute.frame;
                        currentFrameY = currentFrame.origin.y;
                        let newFrame = CGRectMake(sectionInset.left, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
                        attribute.frame = newFrame;
                        maxY = CGRectGetMaxY(currentFrame)
                    } else {
                        let prevAttributes = sortedAttributes[index - 1];
                        
                        let prevFrame = prevAttributes.frame;
                        let currentFrame = attribute.frame;
                        currentFrameY = currentFrame.origin.y;
                        
                        if prevFrame.origin.y == currentFrame.origin.y {
                            let newFrame = CGRectMake(CGRectGetMaxX(prevFrame) + self.tagSpace, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
                            attribute.frame = newFrame;
                        } else {
                            let newFrame = CGRectMake(sectionInset.left, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
                            attribute.frame = newFrame;
                        }
                        maxY = CGRectGetMaxY(currentFrame)
                    }
                    
                } else {
                    let currentFrame = attribute.frame;
                    currentFrameY = currentFrame.origin.y;
                    let newFrame = CGRectMake(sectionInset.left, currentFrame.origin.y, self.collectionView!.bounds.size.width, currentFrame.size.height);
                    attribute.frame = newFrame;
                    minY = CGRectGetMinY(currentFrame);
                    maxY = CGRectGetMaxY(currentFrame)
                }
                
                var isLastInRow = true;
                
                if index < sortedAttributes.count - 1 {
                    let nextAttr = sortedAttributes[index + 1];
                    isLastInRow = nextAttr.frame.origin.y != currentFrameY;
                }
                
                if isLastInRow {
                    self.alignCurrentLine(sortedAttributes, currentFrameY: currentFrameY, sectionInsets: sectionInset);
                }
            }
            
            
            if maxY < self.collectionView!.bounds.size.height {
                let yOffset = (self.collectionView!.bounds.size.height - maxY - minY) / 2;
                self.alignVerticalCenter(sortedAttributes, offset: yOffset);
            }
            
            
            return sortedAttributes;
        }
        return nil;
    }
    
    func alignCurrentLine(sortedAttributes: [UICollectionViewLayoutAttributes], currentFrameY: CGFloat, sectionInsets: UIEdgeInsets) {
        
        let lineAttributes = sortedAttributes.filter( { $0.frame.origin.y == currentFrameY });
        let allWidth = self.collectionView!.bounds.size.width - sectionInsets.left - sectionInsets.right;
        
        if lineAttributes.count >= 1 {
            let maxX = CGRectGetMaxX(lineAttributes.last!.frame)
            let minX = CGRectGetMinX(lineAttributes.first!.frame)
            let space = (allWidth - maxX + minX) / 2 ;

            for attribute in lineAttributes {
                var frame = attribute.frame;
                frame.origin.x += space;
                attribute.frame = frame;
            }
        }
    }
    
    func alignVerticalCenter(sortedAttributes: [UICollectionViewLayoutAttributes], offset: CGFloat) {
        for attribute in sortedAttributes {
            var frame = attribute.frame;
            frame.origin.y += offset;
            attribute.frame = frame;
        }
    }
}
