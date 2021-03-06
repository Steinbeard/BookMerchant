//
//  NewListingTableViewCell.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/25/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit
import AVFoundation

class NewListingTableViewCell: UITableViewCell {

    @IBOutlet var categorySwitch: UISegmentedControl!
    @IBOutlet var isbnField: UITextField!
    @IBOutlet var firstnameField: UITextField!
    @IBOutlet var lastnameField: UITextField!
    @IBOutlet var locationField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var successIndicator: UIImageView!
    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var feedbackText: UILabel!
    var parentViewController: UITableViewController?
    var textFieldOrder: [UITextField]?
    var isISBNValid = false
    
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
    
    @IBAction func pressSubmit(_ sender: Any) { submitForm() }
    
    @IBAction func editedPrice(_ sender: Any) {
        self.feedbackText.isHidden = true
    }
    
    @IBAction func validateISBN(_ sender: Any) {
        self.feedbackText.isHidden = true
        self.successIndicator.isHidden = true
        self.isISBNValid = false
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
                self.isISBNValid = true
                return
            }
        }
    }

    func submitForm() {
        guard let isbn = self.isbnField.text else {
            return
        }
        guard isISBNValid else {
            print("invalid isbn") //TODO give error indication
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.feedbackText.text = "Invalid ISBN"
            self.feedbackText.isHidden = false
            return
        }
        guard let priceText = priceField.text else {
            return
        }
        guard let price = Double(priceText) else {
            print("invalid price") //TODO give error indication
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.feedbackText.text = "Invalid price"
            self.feedbackText.isHidden = false
            return
        }
        let listing = BookListing(
            seller: Seller(
                name: (firstnameField.text ?? "Unlisted") + " " + (lastnameField.text ?? ""),
                website: nil,
                email: emailField.text,
                phone: nil,
                location: locationField.text,
                isIndividual: true),
            price: price,
            condition: (categorySwitch.selectedSegmentIndex == 0) ? .new : .used
        )
        if let listingData = UserDefaults.standard.object(forKey: "listings") as? Data {
            let decoder = JSONDecoder()
            if var existingListings = try? decoder.decode(ListingStorage.self, from: listingData) {
                if var existingListing = existingListings.listings[isbn] {
                    existingListing.append(listing)
                    existingListings.listings[isbn] = existingListing
                } else {
                    existingListings.listings[isbn] = [listing]
                }
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(existingListings) {
                    UserDefaults.standard.set(encoded, forKey: "listings")
                }
                self.parentViewController?.navigationController?.popViewController(animated: true)
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
            submitForm()
        }
        return true
    }
}
