//
//  SplashViewController.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/26/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet var versionText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appVersion = AppDelegate.appVersion {
            //version.text = appVersion
        }
    }
}
