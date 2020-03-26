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
        return historyStorage?.history.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        guard let historyItemCount = historyStorage?.history.count else { return cell }
        guard historyItemCount > 0 else {
            cell.textLabel?.text = "Once you've scanned some books, your browsing history will appear here"
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
