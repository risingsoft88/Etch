//
//  AppConstants.swift
//  Bevy
//
//  Created by macOS on 6/27/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class AppConstants: NSObject {
    static let shared = AppConstants()

    var isDirtyBalance: Bool = false

    override init() {
        super.init()
    }
}
