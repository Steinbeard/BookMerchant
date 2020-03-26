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
    @IBOutlet var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let appVersion = AppDelegate.appVersion {
            versionText.text = "v\(appVersion)"
        }
        UIView.animate(withDuration: 1.7) {
            self.progressBar.setProgress(1.0, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: false)
        }
    }
}
