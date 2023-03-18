//
//  CalendarViewController.swift
//  Etch
//
//  Created by macos on 3/31/22.
//  Copyright © 2022 Etch. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func actionCalendar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
