//
//  SignupViewController.swift
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

class SignupViewController: UIViewController {

    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var viewFullname: UIView!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewPhone: UIView!
    @IBOutlet var viewPassword: UIView!

    @IBOutlet var editFullname: UITextField!
    @IBOutlet var editEmail: UITextField!
    @IBOutlet var editPhone: UITextField!
    @IBOutlet var editPassword: UITextField!

    var userType = ""
    var isLoading = false
    var hidePassword = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnSkip.isHidden = true
        editPassword.isSecureTextEntry = hidePassword
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewFullname.addBottomBorderWithColor(color: UIColor(rgb: 0x252422), width: 1)
        viewEmail.addBottomBorderWithColor(color: UIColor(rgb: 0x252422), width: 1)
        viewPhone.addBottomBorderWithColor(color: UIColor(rgb: 0x252422), width: 1)
        viewPassword.addBottomBorderWithColor(color: UIColor(rgb: 0x252422), width: 1)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionShowPwd(_ sender: Any) {
        if (isLoading) {
            return
        }

        hidePassword = !hidePassword
        editPassword.isSecureTextEntry = hidePassword
    }

    @IBAction func actionNext(_ sender: Any) {
        if (isLoading) {
            return
        }

        guard let fullname = editFullname.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let phone = editPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = editPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if fullname.isEmpty {
            showAlert("Please enter your full name!")
            return
        }

        if !email.isValidEmail() {
            showAlert("Please enter a valid email address!")
            return
        }

        if phone.isEmpty {
            showAlert("Please enter a valid phone number!")
            return
        }

        if !password.isValidPassword() {
            showAlert("Please enter a password with 6 or more characters!")
            return
        }

        let alertController = UIAlertController(title: "Are you sure want to create?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel action
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Create", style: .default) { (action) in
            self.isLoading = true
            SVProgressHUD.show()

            let db = Firestore.firestore()

            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    if (error.localizedDescription == "The email address is already in use by another account.") {
                        SVProgressHUD.dismiss()
                        self.isLoading = false
                        let alertController = UIAlertController(title: "The email address is already in use by exist account.", message: nil, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                        return;
                    }
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                guard let authResult = authResult else {
                    self.showErrorAndHideProgress(text: "There was an error signing up. Please try again.")
                    return
                }

                let authUser: Firebase.User = authResult.user
                let userID = authUser.uid

                db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        self.showErrorAndHideProgress(text: error.localizedDescription)
                        return
                    }

                    guard let snapshot = querySnapshot else {
                        self.showErrorAndHideProgress(text: "There was an error signing up. Please try again.")
                        return
                    }

                    // User exists with the specified email, show error
                    if snapshot.documents.first != nil {
                        self.showErrorAndHideProgress(text: "Email already used.")
                        return
                    }

                    var newUserDocRef: DocumentReference
                    newUserDocRef = db.collection("users").document(userID)

                    let newUser = User()
                    newUser.userID = userID
                    newUser.userType = self.userType
                    newUser.fullname = fullname
                    newUser.email = email
                    newUser.phone = phone
                    newUser.password = password
                    newUser.createdAt = Date()

                    newUserDocRef.setData(newUser.toJSON()) { error in
                        if let error = error {
                            self.showErrorAndHideProgress(text: error.localizedDescription)
                            return
                        }

                        AppManager.shared.saveCurrentUser(user: newUser)
                        AppManager.shared.saveCurrentUserRef(userRef: newUserDocRef)

                        SVProgressHUD.dismiss()
                        self.isLoading = false

                        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "SignupConfirmViewController") as! SignupConfirmViewController
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    @IBAction func actionLogin(_ sender: Any) {
        if (isLoading) {
            return
        }

        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        isLoading = false
        self.showError(text: text)
    }

}
