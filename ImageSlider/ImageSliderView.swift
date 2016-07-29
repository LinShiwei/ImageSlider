//
//  ImageSliderView.swift
//  ImageSlider
//
//  Created by Linsw on 16/7/17.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

public class ImageSliderView: UIView{

    var imageSliderScrollView : ImageSliderScrollView?
    
    private var pageControl = UIPageControl()
    
    public var images = [UIImage](){
        didSet{
            guard images.count != 0 else{return}
            guard let scrollView = imageSliderScrollView else{return}
            scrollView.images = images
            pageControl.numberOfPages = images.count
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageSliderScrollView = ImageSliderScrollView(frame: bounds)
        imageSliderScrollView!.delegate = self
        pageControl.center = CGPoint(x: frame.width/2,y: frame.height - 30)
        pageControl.currentPage = imageSliderScrollView!.currentIndex
        self.addSubview(imageSliderScrollView!)
        self.addSubview(pageControl)
    }
}

extension ImageSliderView:UIScrollViewDelegate{
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        guard let view = scrollView as? ImageSliderScrollView else {return}
        view.initTimer()
    }
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        guard let view = scrollView as? ImageSliderScrollView else {return}
        view.prepareForDragging()
    }
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let view = scrollView as? ImageSliderScrollView else {return}
        view.updateTransit()    
        pageControl.currentPage = view.updateCurrentPage()
    }
}