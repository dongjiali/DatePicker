//
//  DatePickerCollectionView.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit

protocol PickerValueChangeDelegate {
    func didEndDecelerating(collectionView: DatePickerCollectionView)
    func DidScroll(collectionView: DatePickerCollectionView)
}

class DatePickerCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var cellItemArray = [String]()
    var selectedItemTag:Int?
    var pickerDelegate: PickerValueChangeDelegate?
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.contentInset = UIEdgeInsetsMake(220/2.0 - 44/2.0, 0, 220/2.0 - 44/2.0, 0)
        self.backgroundColor = UIColor.clearColor()
        self.scrollEnabled = true
        self.userInteractionEnabled = true
        self.showsVerticalScrollIndicator = false
        self.dataSource = self;
        self.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlightCellWithIndexPathRow(indexPathRow:Int)
    {
        selectedItemTag = indexPathRow;
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.reloadData()
        })
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellItemArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.label.text = cellItemArray[indexPath.row]
        if indexPath.row == selectedItemTag
        {
            cell.label.textColor = UIColor.whiteColor()
        }else
        {
            cell.label.textColor = UIColor.blackColor()
        }
        return cell
    }
    
    func setCollectionViewOfContentOffset(){
        let contentY:CGFloat = CGFloat(selectedItemTag!) * 44.0 - 2*44.0;
        self.setContentOffset(CGPointMake(0, contentY), animated: false)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.centerValueForScrollView(scrollView)
        pickerDelegate?.didEndDecelerating(self)
    }
    
    func centerValueForScrollView(scrollView: UIScrollView)
    {
        var offset = scrollView.contentOffset.y
        offset += (scrollView.contentInset.top)
        var indexPathRow = Int(offset/44.0);
        self.highlightCellWithIndexPathRow(indexPathRow)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.highlightCellWithIndexPathRow(-1)
        pickerDelegate?.DidScroll(self)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        pickerDelegate?.didEndDecelerating(self)
    }
}