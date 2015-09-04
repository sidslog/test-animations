//
//  TagFlowLayout.swift
//  Boardmaps
//
//  Created by Sergey Sedov on 5/8/15.
//  Copyright (c) 2015 Dashboard Systems. All rights reserved.
//

import UIKit

@objc class TagTwoLinesFlowLayout: UICollectionViewFlowLayout {
    
    private let tagSpace: CGFloat = 15
    let collectionViewHeightConstraint: NSLayoutConstraint!
    
    init(collectionViewHeightConstraint: NSLayoutConstraint) {
        self.collectionViewHeightConstraint = collectionViewHeightConstraint;
        super.init();
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject] {
        let attributes = super.layoutAttributesForElementsInRect(rect) as! [UICollectionViewLayoutAttributes];
        
        let sortedAttributes = sorted(attributes, { (obj1, obj2) -> Bool in
            if obj1.indexPath.section == obj2.indexPath.section {
                return obj1.indexPath.row < obj2.indexPath.row;
            } else {
                return obj1.indexPath.section < obj2.indexPath.section;
            }
        })
        
        let sectionInset = (self.collectionView!.delegate as! UICollectionViewDelegateFlowLayout!).collectionView!(self.collectionView!, layout: self, insetForSectionAtIndex: 0);
        
        
        var numberOfLines = 1;
        var lastIndexPath = NSIndexPath(forRow: 0, inSection: 0);
        var maxFrameHeght: CGFloat = 20;
        
        for (index, attribute) in enumerate(sortedAttributes) {
            let indexPath = attribute.indexPath;
            lastIndexPath = indexPath;
            let currentFrame = attribute.frame;
            
            let height = CGRectGetHeight(currentFrame);
            if height > maxFrameHeght {
                maxFrameHeght = height;
            }

            if indexPath.row > 0 {
                let prevAttributes = sortedAttributes[index - 1];
                let prevFrame = prevAttributes.frame;
                if prevFrame.origin.y == currentFrame.origin.y {
                    let newFrame = CGRectMake(CGRectGetMaxX(prevFrame) + self.tagSpace, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
                    attribute.frame = newFrame;
                } else {
                    numberOfLines++;
                    let newFrame = CGRectMake(sectionInset.left, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
                    attribute.frame = newFrame;
                }
            } else {
                let newFrame = CGRectMake(sectionInset.left, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
                attribute.frame = newFrame;
            }
        }
        
        if numberOfLines <= 1 {
            if lastIndexPath.row < self.collectionView!.numberOfItemsInSection(0) - 1 {
                self.collectionViewHeightConstraint.constant = self.calculateMaxFrameHeight(maxFrameHeght);
            } else {
                self.collectionViewHeightConstraint.constant = maxFrameHeght + self.sectionInset.top + self.sectionInset.bottom;
            }
        } else {
            self.collectionViewHeightConstraint.constant = self.calculateMaxFrameHeight(maxFrameHeght);
        }
        
        return sortedAttributes;
    }
    
    func calculateMaxFrameHeight(maxFrameHeght: CGFloat) -> CGFloat {
        return self.minimumLineSpacing + 2 * maxFrameHeght + self.sectionInset.top + self.sectionInset.bottom;
    }
    
}
