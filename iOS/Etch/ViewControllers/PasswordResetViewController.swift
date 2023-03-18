//
//  PasswordResetViewController.swift
//  Etch
//
//  Created by macos on 10/30/21.
//  Copyright © 2021 Etch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class PasswordResetViewController: UIViewController {

    @IBOutlet var viewEmail: UIView!
    @IBOutlet var editEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewEmail.addBottomBorderWithColor(color: UIColor(rgb: 0x252422), width: 1)
    }

    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func actionDone(_ sender: Any) {
        guard let email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if (email.isValidEmail()) {
            SVProgressHUD.show()
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                SVProgressHUD.dismiss()
                if let error = error {
                    self.showError(text: error.localizedDescription)
                    return
                }

                let alertController = UIAlertController(title: "We've sent reset email to you, please check email box!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        } else {
            self.showAlert("Please enter a valid email!")
        }
    }

    @IBAction func actionSignup(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "SignupTypeViewController") as! SignupTypeViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
