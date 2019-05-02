//
//  FlashcardTableViewController.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit
import os.log

class FlashcardTableViewController: UITableViewController {
    
    var set = FlashCards(name: "New FlashCards")
    var vc: SetTableViewController?
    
    @IBOutlet weak var flashcardSetTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        flashcardSetTitle.title = "\(set.name) Set"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return set.cards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlashCardTableViewCell", for: indexPath) as? FlashCardTableViewCell else {
            fatalError()
        }
        let card = set.cards[indexPath.row]
        // Configure the cell...
        cell.frontTextView.text = card.front.content
        cell.backTextView.text = card.back.content
        cell.flashcardTitle.text = card.title
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            set.cards.remove(at: indexPath.row)
            letTableSave()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    private func letTableSave() {
        if let pvc = vc {
            pvc.saveSets()
        } else {
            os_log("Failed to each set view controller", log: OSLog.default, type: .error)
        }
    }
    

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

    // MARK: - Button clicks
    
    @IBAction func renameSetClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "What's the name of the set?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Your name: \(name)")
                self.set.name = name
                self.flashcardSetTitle.title = name
                self.letTableSave()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowCard":
            guard let vc = segue.destination as? FlashCardViewController else {
                fatalError()
            }
            guard let ind = sender as? FlashCardTableViewCell else {
                fatalError()
            }
            guard let indexPath = tableView.indexPath(for: ind) else {
                fatalError()
            }
            vc.card = set.cards[indexPath.row]
            
        case "AddCard":
            guard let vc = segue.destination as? FlashCardViewController else {
                fatalError()
            }
            vc.card = FlashCards.FlashCard()
            
        case "ShowQuiz":
            guard let vc = segue.destination as? QuizViewController else {
                fatalError("Failed to segue to the quiz...")
            }
            vc.set = self.set
            
        default:
            fatalError(segue.identifier ?? "")
        }
    }
    
    // Handles the unwind for editing a new flashcard or creating a new one
    @IBAction func unwindToSetTableView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? FlashCardViewController {
            let flashcard = sourceViewController.card
            // If updating:
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                set.cards[selectedIndexPath.row] = flashcard
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            // Otherwise, add as new
            } else {
                let newIndexPath = IndexPath(row: set.cards.count, section: 0)
                set.cards.append(flashcard)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            letTableSave()
        }
    }
    
}
