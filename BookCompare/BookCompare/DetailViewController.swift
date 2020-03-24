//
//  DetailViewController.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/7/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var titleView: UILabel!
    @IBOutlet var authorView: UILabel!
    @IBOutlet var datePublishedView: UILabel!
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let book = self.book {
            titleView.text = book.title
            authorView.text = book.authors[0].name
            datePublishedView.text = book.publishDate
        }
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

}
