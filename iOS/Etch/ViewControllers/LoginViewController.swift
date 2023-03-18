//
//  LoginViewController.swift
//  Etch
//
//  Created by macos on 10/28/21.
//  Copyright © 2021 Etch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewPassword: UIView!
    @IBOutlet var editEmail: UITextField!
    @IBOutlet var editPassword: UITextField!
    @IBOutlet var lblRememberMe: UILabel!
    @IBOutlet var imgRememberMe: UIImageView!
    @IBOutlet var imgCorrectEmail: UIImageView!

    var hidePassword = true
    var correctEmail = true
    var notRememberMe = true
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editPassword.isSecureTextEntry = hidePassword
        imgCorrectEmail.isHidden = correctEmail
        let defaults = UserDefaults.standard
        notRememberMe = defaults.bool(forKey: "remember")
        setRemember()

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionRememberMe(tapGestureRecognizer:)))
        lblRememberMe.isUserInteractionEnabled = true
        lblRememberMe.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionRememberMe(tapGestureRecognizer:)))
        imgRememberMe.isUserInteractionEnabled = true
        imgRememberMe.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let defaults = UserDefaults.standard
        let useremail = defaults.string(forKey: "useremail") ?? ""
        let userpwd = defaults.string(forKey: "userpwd") ?? ""
        if !notRememberMe && useremail != "" && userpwd != "" {
            self.signInWith(email: useremail, password: userpwd)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewEmail.addBottomBorderWithColor(color: UIColor(rgb: 0x252422), width: 1)
        viewPassword.addBottomBorderWithColor(color: UIColor(rgb: 0x252422), width: 1)
    }

    private func setRemember() {
        if (notRememberMe) {
            imgRememberMe.image = R.image.icon_switch_off()
        } else {
            imgRememberMe.image = R.image.icon_switch_on()
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func actionSignup(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "SignupTypeViewController") as! SignupTypeViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func actionShowPwd(_ sender: Any) {
        hidePassword = !hidePassword
        editPassword.isSecureTextEntry = hidePassword
    }

    @IBAction func actionLogin(_ sender: Any) {
        if (isLoading) {
            return
        }

        guard let email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = editPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if email.isEmpty {
            showAlert("Please enter an email address!")
            return
        }

        if password.isEmpty {
            showAlert("Please enter a password!")
            return
        }

        self.signInWith(email: email, password: password)
    }

    @IBAction func actionForgotPwd(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "PasswordResetViewController") as! PasswordResetViewController
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
        showAlert("Google Tapped!")
    }

    @IBAction func actionApple(_ sender: Any) {
        showAlert("Apple Tapped!")
    }

    @objc func actionRememberMe(tapGestureRecognizer: UITapGestureRecognizer) {
        notRememberMe = !notRememberMe
        let defaults = UserDefaults.standard
        defaults.set(notRememberMe, forKey: "remember")
        setRemember()
    }

    private func signInWith(email: String, password: String) {
        isLoading = true
        SVProgressHUD.show()

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.showErrorAndHideProgress(text: error.localizedDescription)
                return
            }

            guard let _ = authResult else {
                self.showErrorAndHideProgress(text: "Could not log in. Please try again")
                return
            }

            let db = Firestore.firestore()
            db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                guard let snapshot = querySnapshot else {
                    self.showErrorAndHideProgress(text: "There was an error signing in.")
                    return
                }

                // User exists with the specified email, show error
                if let existingUserDocument = snapshot.documents.first {
                    let existingUser = User(JSON: existingUserDocument.data())
                    existingUser?.password = password
                    existingUserDocument.reference.updateData(["password": password]);
                    AppManager.shared.saveCurrentUserRef(userRef: existingUserDocument.reference)

                    guard let currentUser = Auth.auth().currentUser else {
                        self.showErrorAndHideProgress(text: "User login failed!")
                        return;
                    }

                    SVProgressHUD.dismiss()
                    self.isLoading = false

                    if (currentUser.isEmailVerified) {
                        AppManager.shared.saveCurrentUser(user: existingUser!)

                        let defaults = UserDefaults.standard
                        defaults.set(email, forKey: "useremail")
                        defaults.set(password, forKey: "userpwd")

                        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Please verify your email address!", message: nil, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                            // cancel action
                        }
                        alertController.addAction(cancelAction)
                        let ResendAction = UIAlertAction(title: "Resend", style: .default) { (action) in
                            SVProgressHUD.show()
                            Auth.auth().currentUser?.sendEmailVerification { (error) in
                                if let error = error {
                                    self.showErrorAndHideProgress(text: error.localizedDescription)
                                    return
                                }

                                SVProgressHUD.dismiss()
                                self.showAlert("Please verify your email address!")
                            }
                        }
                        alertController.addAction(ResendAction)
                        self.present(alertController, animated: true)
                    }
                } else {
                    self.showErrorAndHideProgress(text: "Unknown error!")
                    return;
                }
            }
        }
    }

    private func showErrorAndHideProgress(text: String) {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "useremail")
        defaults.set("", forKey: "userpwd")
        SVProgressHUD.dismiss()
        isLoading = false
        self.showError(text: text)
    }
}
