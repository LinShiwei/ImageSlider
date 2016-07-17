//
//  ViewController.swift
//  ImageSlider
//
//  Created by Linsw on 16/7/17.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    @IBOutlet weak var imageSlider: ImageSliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = UIImage(named: "image1")!
        let image2 = UIImage(named: "image2")!
        let image3 = UIImage(named: "image3")!
        let image4 = UIImage(named: "image4")!
        let images = [image1,image2,image3,image4]
        
        imageSlider.images = images
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

