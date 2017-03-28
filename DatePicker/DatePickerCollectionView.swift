//
//  DatePickerCollectionView.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit

protocol PickerValueChangeDelegate {
    func didEndDecelerating(_ collectionView: DatePickerCollectionView)
    func DidScroll(_ collectionView: DatePickerCollectionView)
}

class DatePickerCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var cellItemArray = [String]()
    var selectedItemTag:Int?
    var pickerDelegate: PickerValueChangeDelegate?
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.contentInset = UIEdgeInsetsMake(220/2.0 - 44/2.0, 0, 220/2.0 - 44/2.0, 0)
        self.backgroundColor = UIColor.clear
        self.isScrollEnabled = true
        self.isUserInteractionEnabled = true
        self.showsVerticalScrollIndicator = false
        self.dataSource = self;
        self.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlightCellWithIndexPathRow(_ indexPathRow:Int)
    {
        selectedItemTag = indexPathRow;
        DispatchQueue.main.async(execute: { () -> Void in
            self.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellItemArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.label.text = cellItemArray[indexPath.row]
        if indexPath.row == selectedItemTag
        {
            cell.label.textColor = UIColor.white
        }else
        {
            cell.label.textColor = UIColor.black
        }
        return cell
    }
    
    func setCollectionViewOfContentOffset(){
        let contentY:CGFloat = CGFloat(selectedItemTag!) * 44.0 - 2*44.0;
        self.setContentOffset(CGPoint(x: 0, y: contentY), animated: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.centerValueForScrollView(scrollView)
        pickerDelegate?.didEndDecelerating(self)
    }
    
    func centerValueForScrollView(_ scrollView: UIScrollView)
    {
        var offset = scrollView.contentOffset.y
        offset += (scrollView.contentInset.top)
        let indexPathRow = Int(offset/44.0);
        self.highlightCellWithIndexPathRow(indexPathRow)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.highlightCellWithIndexPathRow(-1)
        pickerDelegate?.DidScroll(self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        pickerDelegate?.didEndDecelerating(self)
    }
}
