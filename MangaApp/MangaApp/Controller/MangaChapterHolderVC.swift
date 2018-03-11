//
//  MangaChapterHolderVC.swift
//  *
//
//  Created by lhvan on 3/2/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit
import Kingfisher

class MangaChapterHolderVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var data:ShortChapterDetail!
    var pageView:ChapterPageViewController!
    
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var currentChapterLabel: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    class func newVC(data:ShortChapterDetail) -> MangaChapterHolderVC {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MangaChapterHolderVC") as! MangaChapterHolderVC
        vc.data = data
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateChapterName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pageView = ChapterPageViewController.newVC(data: data)
        self.containerView.addSubview(pageView.view)
        self.pageView.customDelegate = self
        
        pageView.view.frame = self.containerView.bounds
        pageView.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        pageView.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        ImageCache.default.clearMemoryCache()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        showHideMenu()
    }
    
    func showHideMenu(){
        if viewTopConstraint.constant == 0 {
            viewTopConstraint.constant = -50
            viewBottomConstraint.constant = -50
        }else{
            viewTopConstraint.constant = 0
            viewBottomConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateChapterName(){
        if data.chapterName.count <= 3 {
            currentChapterLabel.text = "Chapter \(data.chapterNumber)"
        }else{
            currentChapterLabel.text = "Chapter \(data.chapterNumber): \(data.chapterName)"
        }
        self.currentChapterLabel.text = data.chapterName
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension MangaChapterHolderVC : ChapterPageViewControllerDelegate {
    func updateTitle(pageView: ChapterPageViewController, title: String) {
        //self.title = title
        self.currentPageLabel.text = title
    }
    
    func finishLoadingChapterPage(pageView: ChapterPageViewController, current: Int, total: Int) {
        self.progressView.progress = Float(current+1)/Float(total)
    }
}

