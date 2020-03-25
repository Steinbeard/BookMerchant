//
//  NewListingTableViewCell.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/25/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit

class NewListingTableViewCell: UITableViewCell {

    @IBOutlet var categorySwitch: UISegmentedControl!
    @IBOutlet var isbnField: UITextField!
    @IBOutlet var firstnameField: UITextField!
    @IBOutlet var lastnameField: UITextField!
    @IBOutlet var locationField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var successIndicator: UIImageView!
    var textFieldOrder: [UITextField]?
    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var priceField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldOrder = [isbnField, priceField, firstnameField, lastnameField, locationField, emailField]
        isbnField.delegate = self
        priceField.delegate = self
        firstnameField.delegate = self
        lastnameField.delegate = self
        locationField.delegate = self
        emailField.delegate = self
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func validateISBN(_ sender: Any) {
        self.successIndicator.isHidden = true
        self.bookTitle.text = "What book are you selling?"
        let textField = sender as! UITextField
        guard let text = textField.text else { return }
        if (text.count == 10 || text.count == 13) {
            activityIndicator.isHidden = false
            BookClient.getBook(isbn: text) {(book, error) in
                self.activityIndicator.isHidden = true
                guard let book = book, error == nil else {
                    self.successIndicator.isHidden = false
                    self.successIndicator.image = UIImage(systemName: "xmark.circle")
                    self.successIndicator.tintColor = .systemRed
                    return
                }
                self.successIndicator.isHidden = false
                self.successIndicator.image = UIImage(systemName: "checkmark.circle")
                self.successIndicator.tintColor = .systemGreen
                self.bookTitle.text = book.title
                return
            }
        }
    }
    
}

extension NewListingTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let index = textFieldOrder?.firstIndex(of: textField), let orderCount = textFieldOrder?.count else {
            return false
        }
        if index + 1 < orderCount {
            textFieldOrder?[index + 1].becomeFirstResponder()
        } else {
            print("now submit!!!")
        }
        return true
    }
    

    
//    @objc func textFieldDidChange (){
//        if textField == isbnField, let text = textField.text {
//            if (text.count == 10 || text.count == 13) {
//                activityIndicator.isHidden = false
//                BookClient.getBook(isbn: text) {(book, error) in
//                    self.activityIndicator.isHidden = true
//                    guard let book = book, error == nil else {
//                        self.successIndicator.isHidden = false
//                        self.successIndicator.image = UIImage(systemName: "xmark.circle")
//                        self.successIndicator.tintColor = .systemRed
//                        return
//                    }
//                    self.successIndicator.isHidden = false
//                    self.successIndicator.image = UIImage(systemName: "checkmark.circle")
//                    self.successIndicator.tintColor = .systemGreen
//                    self.bookTitle.text = book.title
//                    return
//                }
//            }
//        }
//        return true
//    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        if let code = searchBar.text {
//            scanner?.found(code: code)
//        }
//        self.didSearch = true
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        if self.didSearch {
//            searchBar.text = ""
//            self.didSearch = false
//        }
//    }
}
