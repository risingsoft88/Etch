//
//  OnboardingViewController.swift
//  Etch
//
//  Created by macos on 10/28/21.
//  Copyright © 2021 Etch. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    var imgCreatives = [R.image.img_onboarding_creatives1(), R.image.img_onboarding_creatives2(), R.image.img_onboarding_creatives3()]
    var imgClients = [R.image.img_onboarding_clients1(), R.image.img_onboarding_clients2(), R.image.img_onboarding_clients3()]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height

        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let subViews = self.scrollView.subviews
        for subview in subViews {
            subview.removeFromSuperview()
        }

        for index in 0..<imgCreatives.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: imgCreatives[index])
            imageView.frame = CGRect(x:0, y:0, width:scrollWidth, height:scrollHeight)
            imageView.contentMode = .scaleAspectFit

            slide.addSubview(imageView)
            scrollView.addSubview(slide)
        }

        //set width of scrollview to accomodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(imgCreatives.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0
    }

    @IBAction func actionDone(_ sender: Any) {
        let page = Int((scrollView?.contentOffset.x)!/scrollWidth)
        if (page == imgCreatives.count-1) {
            let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        } else {
            scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat(page+1), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        }
    }
}
