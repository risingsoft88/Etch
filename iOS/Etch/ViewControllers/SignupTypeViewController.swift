//
//  SignupTypeViewController.swift
//  Etch
//
//  Created by macos on 10/29/21.
//  Copyright © 2021 Etch. All rights reserved.
//

import UIKit

class SignupTypeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func actionCreator(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.userType = "creative"
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func actionClient(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.userType = "client"
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func actionLogin(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
