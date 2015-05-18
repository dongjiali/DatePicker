//
//  DatePickerFlowLayout.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit

let ACTIVE_DISTANCE:CGFloat = 55.0

class DatePickerFlowLayout: UICollectionViewFlowLayout {
    
    init(size frame:CGSize) {
        super.init()
        self.itemSize = frame;
        self.scrollDirection = UICollectionViewScrollDirection.Vertical;
        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.minimumLineSpacing = 0.0;
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var array:Array = super.layoutAttributesForElementsInRect(rect)!
        var visibleRect:CGRect = CGRect()
        visibleRect.origin = self.collectionView!.contentOffset
        visibleRect.size = self.collectionView!.bounds.size
        
        for item in array
        {
            var attributes:UICollectionViewLayoutAttributes = item as! UICollectionViewLayoutAttributes
            let distance:CGFloat = CGRectGetMidY(visibleRect) - attributes.center.y;
            let normalizedDistance = distance / ACTIVE_DISTANCE;
            if fabs(distance) < ACTIVE_DISTANCE
            {
                let zoom = 1 + 0.45 * (1 - fabs(normalizedDistance))
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                attributes.zIndex = 1
            }
        }
        
        return array
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var offsetAdjustment = CGFloat(MAXFLOAT)
        var horizontalCenter = proposedContentOffset.y + (CGRectGetHeight(self.collectionView!.bounds) / 2.0);
        var targetRect:CGRect = CGRectMake(0.0, proposedContentOffset.y, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
        var array:NSArray = super.layoutAttributesForElementsInRect(targetRect)!
        
        for item in array
        {
            let attributes:UICollectionViewLayoutAttributes = item as! UICollectionViewLayoutAttributes
            var itemHorizontalCenter:CGFloat = attributes.center.y
            if (fabs(itemHorizontalCenter - horizontalCenter) <= fabs(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            }
        }
        return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offsetAdjustment);
    }
    
}