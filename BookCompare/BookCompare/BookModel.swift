//
//  BookModel.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/23/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import Foundation

struct Book {
    let title: String?
    let url: String?
    let notes: String?
    let publishDate: String?
    let numberOfPages: String?
    let byStatement: String?
    let classifications: Classification
    let identifiers: BookIdentifier
    let authors: [Author]
    let publishers: [Publisher]
    let publishPlaces: [Place]
    
    init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let publishDate = json["publish_date"] as? String,
            let authors = json["authors"] as? [[String: Any]]
        else {
            return nil
        }
        let url = json["url"] as? String
        let notes = json["notes"] as? String
        let numberOfPages = json["number_of_pages"] as? String //try Int later
        let classifications = json["classifications"] as? [String: Any]
        let identifiers = json["identifiers"] as? [String: Any]
        let byStatement = json["by_statement"] as? String
        let publishers = json["publishers"] as? [[String: Any]] ?? []
        let publishPlaces = json["publish_places"] as? [[String:Any]] ?? []
        
        self.title = title
        self.url = url
        self.notes = notes
        self.publishDate = publishDate
        self.numberOfPages = numberOfPages
        self.byStatement = byStatement
        
        let deweyDecimalClass = classifications?["dewey_decimal_class"] as? [String]
        let lcClassifications = classifications?["lc_classifications"] as? [String]
        self.classifications = Classification(deweyDecimalClass: deweyDecimalClass, lcClassifications: lcClassifications)
        
        let isbn10 = identifiers?["isbn_10"] as? [String] //try Int later
        let isbn13 = identifiers?["isbn_13"] as? [String]
        self.identifiers = BookIdentifier(isbn13: isbn13, isbn10: isbn10)
        
        var authorNames = [Author]()
        for author in authors {
            let name = author["name"] as? String
            authorNames.append(Author(name: name))
        }
        self.authors = authorNames
        
        var publisherNames = [Publisher]()
        for publisher in publishers {
            let name = publisher["name"] as? String
            publisherNames.append(Publisher(name: name))
        }
        self.publishers = publisherNames

        var placeNames = [Place]()
        for place in publishPlaces {
            let name = place["name"] as? String
            placeNames.append(Place(name: name))
        }
        self.publishPlaces = placeNames
        
    }
}

struct Publisher {
    let name: String?
}

struct Author {
    let name: String?
}

struct BookIdentifier {
    let isbn13: [String]?
    let isbn10: [String]?
}

struct Place {
    let name: String?
}

struct Classification {
    let deweyDecimalClass: [String]?
    let lcClassifications: [String]? //Library of Congress system used by UChicago libraries
}
