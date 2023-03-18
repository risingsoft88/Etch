//
//  HomeViewController.swift
//  Etch
//
//  Created by macos on 10/28/21.
//  Copyright © 2021 Etch. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var hScrollView: UIScrollView!
    @IBOutlet var vScrollView: UIScrollView!
    
    var hScrollWidth: CGFloat! = 0.0
    var hScrollHeight: CGFloat! = 0.0
    
    var vScrollWidth: CGFloat! = 0.0
    var vScrollHeight: CGFloat! = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //horizontal scrollivew
        self.hScrollView.delegate = self
        hScrollView.isPagingEnabled = true
        hScrollView.showsHorizontalScrollIndicator = false
        hScrollView.showsVerticalScrollIndicator = false

        hScrollWidth = hScrollView.frame.size.width
        hScrollHeight = hScrollView.frame.size.height
        
        let hSubViews = self.hScrollView.subviews
        for hSubview in hSubViews {
            hSubview.removeFromSuperview()
        }
        
        var hFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        hFrame.size = CGSize(width: 384, height: hScrollHeight)
        let hSlide = UIView(frame: hFrame)

        //subviews
        let hImageView = UIImageView.init(image: R.image.img_temp_hscroll())
        hImageView.frame = CGRect(x:0, y:0, width:384, height:hScrollHeight)
        hImageView.contentMode = .scaleAspectFit

        hSlide.addSubview(hImageView)
        hScrollView.addSubview(hSlide)
        
        //set width of scrollview to accomodate all the slides
        hScrollView.contentSize = CGSize(width: 384, height: hScrollHeight)

        //disable vertical scroll/bounce
        self.hScrollView.contentSize.height = 1.0
        
        //vertical scrollivew
        self.vScrollView.delegate = self
        vScrollView.isPagingEnabled = true
        vScrollView.showsHorizontalScrollIndicator = false
        vScrollView.showsVerticalScrollIndicator = false

        vScrollWidth = vScrollView.frame.size.width
        vScrollHeight = vScrollView.frame.size.height
        
        let vSubViews = self.vScrollView.subviews
        for vSubview in vSubViews {
            vSubview.removeFromSuperview()
        }
        
        var vFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        vFrame.size = CGSize(width: vScrollWidth, height: 920)
        let vSlide = UIView(frame: vFrame)

        //subviews
        let vImageView = UIImageView.init(image: R.image.img_temp_vscroll())
        vImageView.frame = CGRect(x:0, y:0, width:vScrollWidth, height:820)
        vImageView.contentMode = .scaleAspectFit
        
        let vButtonMore = UIImageView.init(image: R.image.btn_more())
        vButtonMore.frame = CGRect(x:(vScrollWidth-142)/2, y:850, width:142, height:44)
        vButtonMore.contentMode = .scaleAspectFit

        vSlide.addSubview(vImageView)
        vSlide.addSubview(vButtonMore)
        vScrollView.addSubview(vSlide)
        
        //set width of scrollview to accomodate all the slides
        vScrollView.contentSize = CGSize(width: vScrollWidth, height: 920)

        //disable vertical scroll/bounce
        self.vScrollView.contentSize.width = 1.0
    }

    @IBAction func actionCalendar(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func actionSearch(_ sender: Any) {
    }
}
