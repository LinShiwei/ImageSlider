//
//  ImageSliderScrollView.swift
//  ImageSlider
//
//  Created by Linsw on 16/7/17.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import AVFoundation

public class ImageSliderScrollView: UIScrollView {

    var currentIndex = 0

    var images = [UIImage](){
        didSet{
            guard images.count != 0 else {return}
            contentSize = CGSize(width: frame.width * CGFloat(images.count), height: frame.height)

            for view in self.subviews where view is UIImageView {
                view.removeFromSuperview()
            }
            for index in 0...images.count-1 {
                let imageView = createImageView(index)
                imageView.image = images[index]
                self.addSubview(imageView)
            }
        }
    }
    
    private var timer:NSTimer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        backgroundColor = UIColor.redColor()
        initTimer()

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        pagingEnabled = true
//        showsHorizontalScrollIndicator = false
//        showsVerticalScrollIndicator = false
//        
//    }
    
    func initTimer(){
        guard timer == nil || timer?.valid == false else{ return}
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "moveToNextPage", userInfo: nil, repeats: true)
        
    }
    
    func moveToNextPage (){
        userInteractionEnabled = false
        for view in subviews {
            view.userInteractionEnabled = false
        }
        let pageWidth:CGFloat = frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(images.count)
        let contentOffset:CGFloat = self.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: frame.height), animated: true)
    }
    
    func prepareForDragging() {
        userInteractionEnabled = false
        for view in subviews {
            view.userInteractionEnabled = false
        }
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func updateCurrentPage()->Int{
        userInteractionEnabled = true
        for view in subviews {
            view.userInteractionEnabled = true
        }
        let pageWidth:CGFloat = frame.width
        let currentPage:Int = Int(floor((self.contentOffset.x-pageWidth/2)/pageWidth)+1)
        currentIndex = currentPage
        assert(0..<images.count ~= currentPage)
        return currentPage
    }
    
    private func createImageView(index:Int)->UIImageView {
        var frame = centerFrameFromImageSize(images[index].size)
        frame.origin.x += self.frame.width * CGFloat(index)
        return UIImageView(frame: frame)
    }
    
    private func centerFrameFromImageSize(imageSize:CGSize) -> CGRect {

        return AVMakeRectWithAspectRatioInsideRect(imageSize, bounds)
    }
}
