//
//  LoginWithViewController.swift
//  Etch
//
//  Created by macos on 10/28/21.
//  Copyright © 2021 Etch. All rights reserved.
//

import UIKit

class LoginWithViewController: UIViewController {

    @IBOutlet var imgLoginLogo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionLogin(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func actionSignup(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "SignupTypeViewController") as! SignupTypeViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func actionFacebook(_ sender: Any) {
        showAlert("Facebook Tapped!")
    }

    @IBAction func actionTwitter(_ sender: Any) {
        showAlert("Twitter Tapped!")
    }

    @IBAction func actionGoogle(_ sender: Any) {
        showAlert("Google+ Tapped!")
    }

    @IBAction func actionApple(_ sender: Any) {
        showAlert("Apple Tapped!")
    }
}

