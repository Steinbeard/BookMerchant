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
    var priceData: [BookListing]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTable.delegate = self
        priceTable.dataSource = self
        if let book = self.book {
            titleView.text = book.title
            authorView.text = book.authors[0].name
            datePublishedView.text = book.publishDate
        }
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.priceData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = priceTable.dequeueReusableCell(withIdentifier: "priceListingCell", for: indexPath) as! PriceTableViewCell
        cell.sellerLabel.text = self.priceData?[indexPath.row].seller.name
        if let price = self.priceData?[indexPath.row].price {
            cell.priceLabel.text = "$\(price)"
        }
        cell.conditionLabel.text = self.priceData?[indexPath.row].condition?.rawValue
        cell.locationLabel.text = self.priceData?[indexPath.row].seller.location
        return cell
    }
    
    
}
