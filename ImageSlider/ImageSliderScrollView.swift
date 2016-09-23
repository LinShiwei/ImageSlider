//
//  ImageSliderScrollView.swift
//  ImageSlider
//
//  Created by Linsw on 16/7/17.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import AVFoundation

class ImageSliderScrollView: UIScrollView {

    var currentIndex = 0

    var images = [UIImage](){
        didSet{
            guard images.count != 0 else {return}
            contentSize = CGSize(width: frame.width * CGFloat(images.count + 2), height: frame.height)
            for view in self.subviews where view is UIImageView {
                view.removeFromSuperview()
            }
            for index in 0...images.count-1 {
                let imageView = createImageView(index)
                imageView.image = images[index]
                self.addSubview(imageView)
            }
            for imageview in createTransitImageView() {
                self.addSubview(imageview)
            }
            initTimer()
            
            contentOffset = CGPoint(x: frame.width, y: 0)
        }
    }
    
    fileprivate var timer:Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
//        backgroundColor = UIColor.redColor()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTimer(){
        guard timer == nil || timer?.isValid == false else{ return }
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ImageSliderScrollView.moveToNextPage), userInfo: nil, repeats: true)
        
    }
    
    func moveToNextPage (){
        isUserInteractionEnabled = false
        for view in subviews {
            view.isUserInteractionEnabled = false
        }
        let pageWidth:CGFloat = frame.width
        let contentOffset:CGFloat = self.contentOffset.x
        
        let slideToX = contentOffset + pageWidth

        scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: frame.height), animated: true)
    }
    
    func prepareForDragging() {
        isUserInteractionEnabled = false
        for view in subviews {
            view.isUserInteractionEnabled = false
        }
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func updateCurrentPage()->Int{
        isUserInteractionEnabled = true
        for view in subviews {
            view.isUserInteractionEnabled = true
        }
        let pageWidth:CGFloat = frame.width
        let currentPage:Int = Int(floor(self.contentOffset.x-pageWidth/2)/pageWidth)
        currentIndex = currentPage
        return currentPage
    }
    
    func updateTransit() {
        if contentOffset.x == 0 {
            contentOffset.x = contentSize.width - frame.width*2
        }
        if contentOffset.x == contentSize.width - frame.width {
            contentOffset.x = frame.width
        }
    }
    
    fileprivate func createImageView(_ index:Int)->UIImageView {
        var frame = centerFrameFromImageSize(images[index].size)
        frame.origin.x += self.frame.width * CGFloat(index+1)

        return UIImageView(frame: frame)
    }
    
    fileprivate func createTransitImageView()->[UIImageView] {
        var frameLast = centerFrameFromImageSize(images[0].size)
        frameLast.origin.x += self.frame.width * CGFloat(images.count+1)
        let imageViewLast = UIImageView(frame:frameLast)
        imageViewLast.image = images[0]
        
        var frameFirst = centerFrameFromImageSize(images[images.count-1].size)
        frameFirst.origin.x = 0
        let imageViewFirst = UIImageView(frame:frameFirst)
        imageViewFirst.image = images[images.count-1]
        
        return [imageViewFirst,imageViewLast]
    }
    
    fileprivate func centerFrameFromImageSize(_ imageSize:CGSize) -> CGRect {

        return AVMakeRect(aspectRatio: imageSize, insideRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
    }
}
