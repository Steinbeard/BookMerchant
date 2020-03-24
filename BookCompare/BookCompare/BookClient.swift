//
//  BookClient.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/20/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import Foundation

class BookClient {
    static func getBook(isbn: String, completion: @escaping ((Book?, Error?) -> Void)) {
        guard let url = URL(string: "https://openlibrary.org/api/books?jscmd=data&bibkeys=\(isbn)&format=json") else {
            let error = ParsingError.badUrl
            DispatchQueue.main.async {completion(nil, error)}
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let bookData = json[isbn] as? [String: Any] {
                        guard let book = Book(json: bookData) else {
                            let error = ParsingError.unavailable
                            print("Bad initialization of book: \(error)")
                            DispatchQueue.main.async {completion(nil, error)}
                            return
                        }
                        print(book)
                        DispatchQueue.main.async {completion(book, nil)}
                    }
                    else {
                        let error = ParsingError.unavailable
                        DispatchQueue.main.async {completion(nil, error)}
                        return
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                DispatchQueue.main.async {completion(nil, error)}
            }
        }
        task.resume()
    }
}

enum ParsingError: Error {
    case unavailable
    case badUrl
}
