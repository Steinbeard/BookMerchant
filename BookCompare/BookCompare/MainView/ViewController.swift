//
//  ViewController.swift
//  BookCompare
// 
//  Created by Daniel Steinberg on 3/7/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    let priceDataSource = PriceDataSource.sharedInstance
    var scanner: ScannerViewController?
    var didSearch = false
    var didAskForReview = false
    var launchCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
            let defaults = UserDefaults.standard
            if var launchCount = defaults.object(forKey: "launchCount") as? Int {
                launchCount += 1
                self.launchCount = launchCount
                defaults.set(launchCount, forKey: "launchCount")
            } else {
                launchCount = 1
                defaults.set(1, forKey: "launchCount")
            }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(launchCount)
        if launchCount == 3 && !didAskForReview {
            didAskForReview = true
            SKStoreReviewController.requestReview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! DetailViewController
            let scanner = sender as! ScannerViewController
            vc.book = scanner.book
            if let identifier = Int(scanner.book?.identifiers.isbn13?[0] ?? "") {
                if let isbn13Listings = self.priceDataSource.getListings(isbn: identifier) {
                    vc.priceData += isbn13Listings
                }
            } else if let identifier = Int(scanner.book?.identifiers.isbn10?[0] ?? "") {
                if let isbn10Listings = self.priceDataSource.getListings(isbn: identifier) {
                     vc.priceData += isbn10Listings
                 }
            }
            // Add book to user history, if not already in it
            if let data = UserDefaults.standard.object(forKey: "history") as? Data {
                guard let book = scanner.book else { return }
                let decoder = JSONDecoder(), encoder = JSONEncoder()
                let newHistoryEntry = HistoryEntry(
                    isbn: (book.identifiers.isbn10?[0] ?? book.identifiers.isbn13?[0] ?? ""),
                    title: book.title ?? "",
                    author: book.authors[0].name ?? ""
                )
                if var historyStorage = try? decoder.decode(HistoryStorage.self, from: data) {
                    guard let identifiers = scanner.book?.identifiers else { return }
                    // If book is already in history, we want to filter it out to bump it to the top
                    historyStorage.history = historyStorage.history.filter() { element in
                        element.isbn != (identifiers.isbn10?[0] ?? "") && element.isbn != (identifiers.isbn13?[0] ?? "")
                    }
                    historyStorage.history.insert(newHistoryEntry, at: 0)
                    if let encoded = try? encoder.encode(historyStorage) {
                        UserDefaults.standard.set(encoded, forKey: "history")
                    }
                }
            }
        // Get reference to cotained scanner
        } else if segue.identifier == "scannerEmbed" {
            if let scanner = segue.destination as? ScannerViewController {
                self.scanner = scanner
            }
        } else if segue.identifier == "historySegue" {
            guard let historyTable = segue.destination as? HistoryTableViewController else { return }
            historyTable.mainViewController = self
            if let data = UserDefaults.standard.object(forKey: "history") as? Data {
                let decoder = JSONDecoder()
                if let historyStorage = try? decoder.decode(HistoryStorage.self, from: data) {
                    historyTable.historyStorage = historyStorage
                }
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
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
