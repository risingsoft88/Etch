//
//  SignupConfirmViewController.swift
//  Etch
//
//  Created by macos on 11/1/21.
//  Copyright © 2021 Etch. All rights reserved.
//

import UIKit
import DatePickerDialog
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class SignupConfirmViewController: UIViewController {

    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var imgCheckbox: UIImageView!
    @IBOutlet var lblCheckbox: UILabel!
    @IBOutlet var lblConfirm: UILabel!
    @IBOutlet var viewDay: UIView!
    @IBOutlet var viewMonth: UIView!
    @IBOutlet var viewYear: UIView!
    @IBOutlet var lblDay: UILabel!
    @IBOutlet var lblMonth: UILabel!
    @IBOutlet var lblYear: UILabel!

    var checkbox = true
    var isLoading = false
    var birthday = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewDay.layer.cornerRadius = 6
        viewDay.layer.borderWidth = 2
        viewDay.layer.borderColor = UIColor(rgb: 0x40434A).cgColor
        viewMonth.layer.cornerRadius = 6
        viewMonth.layer.borderWidth = 2
        viewMonth.layer.borderColor = UIColor(rgb: 0x40434A).cgColor
        viewYear.layer.cornerRadius = 6
        viewYear.layer.borderWidth = 2
        viewYear.layer.borderColor = UIColor(rgb: 0x40434A).cgColor
        btnSkip.isHidden = true
        setCheckbox()

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionCheckbox(tapGestureRecognizer:)))
        lblCheckbox.isUserInteractionEnabled = true
        lblCheckbox.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionCheckbox(tapGestureRecognizer:)))
        imgCheckbox.isUserInteractionEnabled = true
        imgCheckbox.addGestureRecognizer(tapGestureRecognizer)

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionDate(tapGestureRecognizer:)))
        viewDay.isUserInteractionEnabled = true
        viewDay.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionDate(tapGestureRecognizer:)))
        viewMonth.isUserInteractionEnabled = true
        viewMonth.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionDate(tapGestureRecognizer:)))
        viewYear.isUserInteractionEnabled = true
        viewYear.addGestureRecognizer(tapGestureRecognizer)

        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        self.lblDay.text = formatter.string(from: birthday)
        formatter.dateFormat = "MMMM"
        self.lblMonth.text = formatter.string(from: birthday)
        formatter.dateFormat = "yyyy"
        self.lblYear.text = formatter.string(from: birthday)
    }

    private func setCheckbox() {
        if (checkbox) {
            imgCheckbox.image = R.image.img_checkbox_on()
        } else {
            imgCheckbox.image = R.image.img_checkbox_off()
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func actionNext(_ sender: Any) {
        if (isLoading) {
            return
        }

        if (!checkbox) {
            showAlert("Please read and agree Terms of Use, Privacy Policy!")
            return
        }

        if let currentUserRef = AppManager.shared.currentUserRef {
            if let currentUser = AppManager.shared.currentUser {
                currentUser.birthday = self.birthday;

                currentUserRef.setData(currentUser.toJSON()) { error in
                    SVProgressHUD.dismiss()
                    self.isLoading = false

                    if let error = error {
                        self.showError(text: error.localizedDescription)
                        return
                    }

                    AppManager.shared.saveCurrentUser(user: currentUser)

                    let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "SignupCreativesViewController") as! SignupCreativesViewController
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func actionLogin(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    @objc func actionCheckbox(tapGestureRecognizer: UITapGestureRecognizer) {
        checkbox = !checkbox
        setCheckbox()
    }

    @objc func actionDate(tapGestureRecognizer: UITapGestureRecognizer) {
        DatePickerDialog().show("Select birthday", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "d"
                self.lblDay.text = formatter.string(from: dt)
                formatter.dateFormat = "MMMM"
                self.lblMonth.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy"
                self.lblYear.text = formatter.string(from: dt)
                self.birthday = dt
            }
        }
    }
}
