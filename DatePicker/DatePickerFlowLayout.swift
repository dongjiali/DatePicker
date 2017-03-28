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
        self.scrollDirection = UICollectionViewScrollDirection.vertical;
        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.minimumLineSpacing = 0.0;
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array:Array = super.layoutAttributesForElements(in: rect)!
        var visibleRect:CGRect = CGRect()
        visibleRect.origin = self.collectionView!.contentOffset
        visibleRect.size = self.collectionView!.bounds.size
        
        for item in array
        {
            let attributes:UICollectionViewLayoutAttributes = item 
            let distance:CGFloat = visibleRect.midY - attributes.center.y;
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
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.y + (self.collectionView!.bounds.height / 2.0);
        let targetRect:CGRect = CGRect(x: 0.0, y: proposedContentOffset.y, width: self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
        let array:NSArray = super.layoutAttributesForElements(in: targetRect)! as NSArray
        
        for item in array
        {
            let attributes:UICollectionViewLayoutAttributes = item as! UICollectionViewLayoutAttributes
            let itemHorizontalCenter:CGFloat = attributes.center.y
            if (fabs(itemHorizontalCenter - horizontalCenter) <= fabs(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            }
        }
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment);
    }
    
}
