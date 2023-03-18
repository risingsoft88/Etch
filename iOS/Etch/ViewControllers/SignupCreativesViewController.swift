//
//  SignupCreativesViewController.swift
//  Etch
//
//  Created by macos on 11/1/21.
//  Copyright © 2021 Etch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class SignupCreativesViewController: UIViewController {

    @IBOutlet var imgCreativeBarber: UIImageView!
    @IBOutlet var imgCreativeHairStylist: UIImageView!
    @IBOutlet var imgCreativeStylist: UIImageView!
    @IBOutlet var imgCreativeMakeup: UIImageView!
    @IBOutlet var imgCreativeBartender: UIImageView!
    @IBOutlet var imgCreativePrivateChef: UIImageView!
    @IBOutlet var imgCreativePhotographer: UIImageView!
    @IBOutlet var imgCreativePhysicalTrainer: UIImageView!

    var creativeBarber = false
    var creativeHairStylist = false
    var creativeStylist = false
    var creativeMakeup = false
    var creativeBartender = false
    var creativePrivateChef = false
    var creativePhotographer = false
    var creativePhysicalTrainer = false
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setCreatives()

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionBarber(tapGestureRecognizer:)))
        imgCreativeBarber.isUserInteractionEnabled = true
        imgCreativeBarber.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionHairStylist(tapGestureRecognizer:)))
        imgCreativeHairStylist.isUserInteractionEnabled = true
        imgCreativeHairStylist.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionStylist(tapGestureRecognizer:)))
        imgCreativeStylist.isUserInteractionEnabled = true
        imgCreativeStylist.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionMakeup(tapGestureRecognizer:)))
        imgCreativeMakeup.isUserInteractionEnabled = true
        imgCreativeMakeup.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionBartender(tapGestureRecognizer:)))
        imgCreativeBartender.isUserInteractionEnabled = true
        imgCreativeBartender.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionPrivateChef(tapGestureRecognizer:)))
        imgCreativePrivateChef.isUserInteractionEnabled = true
        imgCreativePrivateChef.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionPhotographer(tapGestureRecognizer:)))
        imgCreativePhotographer.isUserInteractionEnabled = true
        imgCreativePhotographer.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionPhysicalTrainer(tapGestureRecognizer:)))
        imgCreativePhysicalTrainer.isUserInteractionEnabled = true
        imgCreativePhysicalTrainer.addGestureRecognizer(tapGestureRecognizer)
    }

    private func setCreatives() {
        imgCreativeBarber.image = creativeBarber ? R.image.img_creative_barber_on() : R.image.img_creative_barber_off()
        imgCreativeHairStylist.image = creativeHairStylist ? R.image.img_creative_hairstylist_on() : R.image.img_creative_hairstylist_off()
        imgCreativeStylist.image = creativeStylist ? R.image.img_creative_stylist_on() : R.image.img_creative_stylist_off()
        imgCreativeMakeup.image = creativeMakeup ? R.image.img_creative_makeup_on() : R.image.img_creative_makeup_off()
        imgCreativeBartender.image = creativeBartender ? R.image.img_creative_bartender_on() : R.image.img_creative_bartender_off()
        imgCreativePrivateChef.image = creativePrivateChef ? R.image.img_creative_privatechef_on() : R.image.img_creative_privatechef_off()
        imgCreativePhotographer.image = creativePhotographer ? R.image.img_creative_photographer_on() : R.image.img_creative_photographer_off()
        imgCreativePhysicalTrainer.image = creativePhysicalTrainer ? R.image.img_creative_physicaltrainer_on() : R.image.img_creative_physicaltrainer_off()
    }

    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func actionSkip(_ sender: Any) {
        showAlert("Skip Tapped!")
    }

    @IBAction func actionDone(_ sender: Any) {
        if (isLoading) {
            return
        }

        if let currentUserRef = AppManager.shared.currentUserRef {
            if let currentUser = AppManager.shared.currentUser {
                currentUser.creativeBarber = self.creativeBarber;
                currentUser.creativeHairStylist = self.creativeHairStylist;
                currentUser.creativeStylist = self.creativeStylist;
                currentUser.creativeMakeup = self.creativeMakeup;
                currentUser.creativeBartender = self.creativeBartender;
                currentUser.creativePrivateChef = self.creativePrivateChef;
                currentUser.creativePhotographer = self.creativePhotographer;
                currentUser.creativePhysicalTrainer = self.creativePhysicalTrainer;

                self.isLoading = true
                SVProgressHUD.show()

                currentUserRef.setData(currentUser.toJSON()) { error in
                    if let error = error {
                        self.showErrorAndHideProgress(text: error.localizedDescription)
                        return
                    }

                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        if let error = error {
                            self.showErrorAndHideProgress(text: error.localizedDescription)
                            return
                        }

                        AppManager.shared.saveCurrentUser(user: currentUser)

                        SVProgressHUD.dismiss()
                        self.isLoading = false

                        let alertController = UIAlertController(title: "Sent verification email, please verify your email address!", message: nil, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            viewController.modalPresentationStyle = .fullScreen
                            self.present(viewController, animated: true, completion: nil)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                    }
                }
            }
        }
    }

    @IBAction func actionLogin(_ sender: Any) {
        let viewController = R.storyboard.main().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    @objc func actionBarber(tapGestureRecognizer: UITapGestureRecognizer) {
        creativeBarber = !creativeBarber
        setCreatives()
    }

    @objc func actionHairStylist(tapGestureRecognizer: UITapGestureRecognizer) {
        creativeHairStylist = !creativeHairStylist
        setCreatives()
    }

    @objc func actionStylist(tapGestureRecognizer: UITapGestureRecognizer) {
        creativeStylist = !creativeStylist
        setCreatives()
    }

    @objc func actionMakeup(tapGestureRecognizer: UITapGestureRecognizer) {
        creativeMakeup = !creativeMakeup
        setCreatives()
    }

    @objc func actionBartender(tapGestureRecognizer: UITapGestureRecognizer) {
        creativeBartender = !creativeBartender
        setCreatives()
    }

    @objc func actionPrivateChef(tapGestureRecognizer: UITapGestureRecognizer) {
        creativePrivateChef = !creativePrivateChef
        setCreatives()
    }

    @objc func actionPhotographer(tapGestureRecognizer: UITapGestureRecognizer) {
        creativePhotographer = !creativePhotographer
        setCreatives()
    }

    @objc func actionPhysicalTrainer(tapGestureRecognizer: UITapGestureRecognizer) {
        creativePhysicalTrainer = !creativePhysicalTrainer
        setCreatives()
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        isLoading = false
        self.showError(text: text)
    }
}
