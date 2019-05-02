//
//  FlashcardTableViewController.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit
import os.log
import MultipeerConnectivity

class FlashcardTableViewController: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    @IBAction func shareSet(_ sender: Any) {
        if mcSession.connectedPeers.count > 0 {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: set, requiringSecureCoding: false)
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                fatalError("Unable to compress data")
            }
        } else {
            print("you are not connected to another device")
        }
    }
    
    // func loadSets() -> [FlashCards]? {
   //     let fullPath = getDocumentsDirectory().appendingPathComponent("sets")
   //     if let nsData = NSData(contentsOf: fullPath) {
   //         do {
   //             let data = Data(referencing: nsData)
   //             if let loadSets = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [FlashCards] {
   //                 return loadSets
   //             }
   //         } catch {
   //             print("Couldn't read file.")
   //             return nil
   //         }
   //     }
   //     return nil
   // }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            if let newSet = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? FlashCards {
                if let pvc = vc {
                    pvc.flashcardSets.append(newSet)
                    letTableSave()
                }
            }
        } catch {
            fatalError("Unable to process recieved data")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    @IBAction func showConnectivityAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "ToDo Exchange", message: "Do you want to Host or Join a session?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action:UIAlertAction) in
            
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { (action:UIAlertAction) in
            let mcBrowser = MCBrowserViewController(serviceType: "ba-td", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!

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
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self
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
