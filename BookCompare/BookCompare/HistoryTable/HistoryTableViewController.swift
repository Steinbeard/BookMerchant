//
//  HistoryTableViewController.swift
//  BookCompare
//
//  Created by Daniel Steinberg on 3/25/20.
//  Copyright © 2020 Daniel Steinberg. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    var historyStorage: HistoryStorage?
    var mainViewController: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load user history from UserDefaults

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let historyItemCount = historyStorage?.history.count else { return 1}
        return max(historyItemCount, 1)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        guard let historyItemCount = historyStorage?.history.count else { return cell }
        guard historyItemCount > 0 else {
            cell.textLabel?.text = "Scan history will appear here"
            cell.isUserInteractionEnabled = false
            return cell
        }
        let title = historyStorage?.history[indexPath.row].title ?? ""
        let author = historyStorage?.history[indexPath.row].author ?? ""
        cell.textLabel?.text = "\(title) by \(author)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let isbn = historyStorage?.history[indexPath.row].isbn else { return }
        mainViewController?.scanner?.found(code: isbn)
        self.dismiss(animated: true, completion: nil)
    }
}
