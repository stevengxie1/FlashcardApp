//
//  SetTableViewController.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController {

    // MARK: - Data structures
    var flashcardSets = [FlashCards]()
    // MARK: - References to Cell
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        flashcardSets = sampleSetsOfFlashCards()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcardSets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetTableViewCell", for: indexPath) as? SetTableViewCell else {
            fatalError("Problem creating a SetTableViewCell")
        }
        
        let flashcard = flashcardSets[indexPath.row]
        cell.setTitle.text = flashcard.name
        cell.setCardCount.text = String(flashcard.cards.count)
        
        // Configure the cell...
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
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
            flashcardSets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

    // MARK: - UI Button Press
    
    @IBAction func addSetButtonPress(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "What's the name of the set?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Your name: \(name)")
                
                let newIndexPath = IndexPath(row: self.flashcardSets.count, section: 0)
                self.flashcardSets.append(FlashCards(name: name))
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                
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
        case "SetDetail":
            guard let vc = segue.destination as? FlashcardTableViewController else {
                fatalError()
            }
            guard let p = sender as? SetTableViewCell else {
                fatalError()
            }
            
            guard let indexPath = tableView.indexPath(for: p) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            vc.set = flashcardSets[indexPath.row]
            
        default: fatalError("unknown identifier")
        }
    }
    
    func sampleSetsOfFlashCards() -> [FlashCards] {
        let firstSet = FlashCards(name: "Data Privacy")
        firstSet.cards.append(FlashCards.FlashCard(title: "Anonymity", frontPhoto: nil, frontContent: "what is anonymity", backPhoto: nil, backContent: "state of being not identifiable within a set of subjects (the anonymity set)"))
        firstSet.cards.append(FlashCards.FlashCard(title: "Unlinkability", frontPhoto: nil, frontContent: "what is unlinkability", backPhoto: nil, backContent: "Unlinkability of two or more items of interest (IOIs, e.g., subjects, messages, events, actions, etc.) means that within the system, from the attacker’s perspective, these IOIs are no more and no less related after his observation than they are related relying on his a-priori knowledge"))
        let secondSet = FlashCards(name: "Law and Economics")
        secondSet.cards.append(
        FlashCards.FlashCard(title: "Tort", frontPhoto: nil, frontContent: "three elements of tort", backPhoto: nil, backContent: "hard, cause, breach of duty"))
        let thirdSet = FlashCards(name: "iOS")
        return [firstSet, secondSet, thirdSet]
    }

}
