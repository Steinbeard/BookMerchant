//
//  AddListingViewController.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/25/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit

class NewListingViewController: UITableViewController {
    
    var cells = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    @IBAction func handTap(_ sender: UITapGestureRecognizer) {
        if let cell = cells[0] as? NewListingTableViewCell {
            cell.isbnField.resignFirstResponder()
            cell.priceField.resignFirstResponder()
            cell.firstnameField.resignFirstResponder()
            cell.lastnameField.resignFirstResponder()
            cell.locationField.resignFirstResponder()
            cell.emailField.resignFirstResponder()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newListingCell", for: indexPath)
        self.cells.insert(cell, at: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height * 2/3
    }

}
