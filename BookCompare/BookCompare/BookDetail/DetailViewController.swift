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
    @IBOutlet var priceTable: UITableView!
    var book: Book?
    var priceData = [BookListing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTable.delegate = self
        priceTable.dataSource = self
        if let book = self.book {
            titleView.text = book.title
            authorView.text = "by "  + (book.byStatement ?? book.authors[0].name ?? "unknown author")
            datePublishedView.text = (book.publishers.count > 0) ?
                ("\(book.publishers[0].name ?? "Published"): \(book.publishDate ?? "unknown date")") :
                ("Published: \(book.publishDate ?? "unknown date")")
        }
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.priceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = priceTable.dequeueReusableCell(withIdentifier: "priceListingCell", for: indexPath) as! PriceTableViewCell
        cell.sellerLabel.text = self.priceData[indexPath.row].seller.name
        cell.priceLabel.text = "$\(self.priceData[indexPath.row].price)"
        cell.conditionLabel.text = self.priceData[indexPath.row].condition?.rawValue
        cell.locationLabel.text = self.priceData[indexPath.row].seller.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let email = self.priceData[indexPath.row].seller.email, let title = book?.title else {
            return
        }
        // Tapping listing opens email for seller
        // Stackoverflow answer from @soprof for reference
        // https://stackoverflow.com/questions/23299169/ios-button-mail-to-with-subject
        let emailStr = "\(email)?subject=I'm interested in buying your copy of \(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: ("mailto:\(emailStr ?? "")")) {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
}
