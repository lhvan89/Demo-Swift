//
//  ChapterViewController.swift
//  *
//
//  Created by lhvan on 2/28/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit
import Kingfisher

class ChapterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var chapterImageView: UIImageView!
    var chapterImage:ChapterImage!
    var index:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    
        scrollView.delegate = self
        
        //let pointImage = adjustImageCenterScreen()
        
        chapterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        
        chapterImageView.contentMode = .scaleAspectFit
        guard let imgURL = URL(string: chapterImage.imgLink) else {return}
        
        //scrollView.contentSize.height = newHeightImage
        
        scrollView.addSubview(chapterImageView)
        
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        
        
        
        
        ImageCache.default.retrieveImage(forKey: chapterImage.imgLink, options: nil) { (image, cacheType) in
            if let image = image {
                self.chapterImageView.image = image
            }else {
                self.chapterImageView.kf.indicatorType = .activity
                self.chapterImageView.kf.setImage(with: imgURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (img, error, type, url) in
                    self.chapterImageView.kf.indicator?.stopAnimatingView()
                })
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func adjustImageSise() -> CGSize {
        let imageWidth = CGFloat(chapterImage.width)
        let imageHeight = CGFloat(chapterImage.height)
        var newImageWidth = screenWidth
        var newImageHeight = imageHeight * screenWidth / imageWidth
        if newImageHeight > screenHeight {
            newImageHeight = screenHeight
            newImageWidth = imageWidth * screenHeight / imageHeight
        }
        return CGSize(width: newImageWidth, height: newImageHeight)
        
    }
    func adjustImageCenterScreen() -> CGPoint {
        let sizeImage = adjustImageSise()
        var pointY:CGFloat
        if screenHeight == sizeImage.height {
            pointY = 0
        }else {
            pointY = (screenHeight-sizeImage.height) / 2
        }
        
        var pointX:CGFloat
        if screenWidth == sizeImage.width {
            pointX = 0
        }else {
            pointX = (screenWidth-sizeImage.width)/2
        }
        return CGPoint(x: pointX, y: pointY)
    }
}

extension ChapterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.chapterImageView
    }
}
