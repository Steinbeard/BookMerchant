//
//  PriceModel.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/24/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import Foundation

class PriceDataSource {
    public static let sharedInstance = PriceDataSource()
    var listings = [Int: [BookListing]]()
    
    let dummySellers = [
    Seller(name: "Amazon", website: "Amazon.com", email: "jbezos@amazon.com", phone: "1 (888) 280-4331", location: "Online",  isIndividual: false),
    Seller(name: "Ebay", website: "ebay.com", email: "pierre@ebay.com", phone: "1 (866) 540-3229", location: "Online", isIndividual: false),
    Seller(name: "Barnes & Noble", website: "barnesandnoble.com", email: "bnoble@barnesandnoble.com", phone: "(773) 702-7712", location: "Online", isIndividual: false),
    Seller(name: "Seminary Co-op", website: "semcoop.com", email: "dboyer@semcoop.com", phone: "(773) 752-4381", location: "Online", isIndividual: false),
    Seller(name: "Daniel Steinberg", website: nil, email: "steinberg@uchicago.edu", phone: "(310) 612-0341", location: "Chicago", isIndividual: true),
    Seller(name: "Tim Apple", website: nil, email: "tim@apple.com", phone: "(333) 333-3333", location: "Cupertino", isIndividual: true),
    Seller(name: "Reese Witherspoon ", website: nil, email: "rwitherspoon@uchicago.edu", phone: "(773) 030-1721", location: "Chicago", isIndividual: true),
    Seller(name: "Keanu Reeves", website: nil, email: "kreeves@uchicago.edu", phone: "(773) 123-0341", location: "Chicago", isIndividual: true),
    Seller(name: "Phil Collins", website: nil, email: "takethephilpill@gmail.com", phone: "(141) 134-9993", location: "London", isIndividual: true),
    Seller(name: "Debbie Harry", website: nil, email: "debontheweb@gmail.com", phone: "(935) 293-3472", location: "New York", isIndividual: true),
    ]
    
    // Store scan history and user listings in UserDefaults
    fileprivate init() {
        if UserDefaults.standard.object(forKey: "history") == nil {
            // Store isbn (for fetching full data) and title (for table view)
            UserDefaults.standard.set([(String, String)](), forKey: "history")
        }
        if UserDefaults.standard.object(forKey: "listings") == nil {
            // Key: isbn, data: user price, book condition
            UserDefaults.standard.set([String: [BookListing]](), forKey: "listings")
        }
    }
    
    func getListings(isbn: Int) -> [BookListing]? {
        // Using dummy data
        // To get real data, replace with calls to an appropriate API—
        // Rainforest API for Amazon prices, or scraping BookFinder.com
        var listings = [BookListing]()
        var basePrice = Double.random(in: 4.0...100.0)
        // Check if user has posted listings for this book
        // If this doesn't works, use JSON encoding and decoding to store as NSData
        if let existingListings = UserDefaults.standard.object(forKey: "listings") as? [String: [BookListing]] {
            if let existingListing = existingListings["\(isbn)"] {
                for l in existingListing {
                    basePrice = (basePrice + l.price)/2
                    listings.append(l)
                }
            }
        }
        if let existingListings = self.listings[isbn] {
            return existingListings
        }
        let priceRange = basePrice*Double.random(in: 0.1...0.2)
        for i in 0..<Int.random(in: 4...10) {
            let condition = Condition.allCases.randomElement()
            var price = Double()
            if condition == .new {
                price = Double(round(100*(basePrice + Double.random(in: -priceRange...priceRange)))/100)
            } else {
                price = Double(round(100*(basePrice - priceRange + Double.random(in: -priceRange...priceRange)))/100)
            }
            let newListing = BookListing(
                seller: dummySellers[i],
                price: price,
                condition: condition)
            listings.append(newListing)
        }
        listings.sort { a, b in a.price < b.price }
        self.listings[isbn] = listings
        return listings
    }
}

struct BookListing: Codable {
    let seller: Seller
    let price: Double
    let condition: Condition?
}

struct Seller: Codable {
    let name: String
    let website: String?
    let email: String?
    let phone: String?
    let location: String?
    let isIndividual: Bool
}

enum Condition: String, CaseIterable, Codable {
    case new = "New"
    case used = "Used"
}