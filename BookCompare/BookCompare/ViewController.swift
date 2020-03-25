//
//  ViewController.swift
//  BookCompare
// 
//  Created by Daniel Steinberg on 3/7/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let priceDataSource = PriceDataSource.sharedInstance
    var scanner: ScannerViewController?
    var didSearch = false
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! DetailViewController
            let scanner = sender as! ScannerViewController
            vc.book = scanner.book
            if let identifier = Int(scanner.book?.identifiers.isbn13?[0] ?? "") ?? Int(scanner.book?.identifiers.isbn10?[0] ?? "") {
                vc.priceData = self.priceDataSource.getListings(isbn: identifier)//identifier)
            }
        } else if segue.identifier == "scannerEmbed" {
            if let scanner = segue.destination as? ScannerViewController {
                self.scanner = scanner
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let code = searchBar.text {
            scanner?.found(code: code)
        }
        self.didSearch = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if self.didSearch {
            searchBar.text = ""
            self.didSearch = false
        }
    }
}
