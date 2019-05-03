//
//  SetTableViewController.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit
import os.log
import MultipeerConnectivity

class SetTableViewController: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, SetCellDelegate {
    
    func didShare(_ cell: SetTableViewCell) {
        print("didShare called")
        if let indexPath = tableView.indexPath(for: cell){
            let sendItem = flashcardSets[indexPath.row]
            if mcSession.connectedPeers.count > 0 {
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: sendItem, requiringSecureCoding: false)
                    try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    fatalError("Unable to compress data")
                }
            } else {
                print("you are not connected to another device")
            }
        }
    }
    
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
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            if let newSet = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? FlashCards {
                flashcardSets.append(newSet)
                saveSets()
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
                    
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
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
        let actionSheet = UIAlertController(title: "Share Flashcard Sets", message: "Do you want to Host or Join a session?", preferredStyle: .actionSheet)
        
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
    
    // MARK: - Data structures
    var flashcardSets = [FlashCards]()
    // MARK: - References to Cell
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        //flashcardSets = sampleSetsOfFlashCards()
        
        let savedSets = loadSets()
        if let s = savedSets {
            print(s.count)
        }
        
        if savedSets?.count ?? 0 > 0 {
            flashcardSets = savedSets ?? [FlashCards]()
        } else {
            flashcardSets = sampleSetsOfFlashCards()
        }
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self

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
        cell.delegate = self
        // Configure the cell...
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
            saveSets()
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
                self.saveSets()
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
            vc.vc = self
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveSets() {
        do{
            let fullPath = getDocumentsDirectory().appendingPathComponent("sets")
            let data = try NSKeyedArchiver.archivedData(withRootObject: flashcardSets, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Successfully saved.", log: OSLog.default, type: .debug)
            print("Successfully saved.")
        }
        catch {
            os_log("Failed to save", log: OSLog.default, type: .error)
            print("Failed to save")
        }
    }
    
    func loadSets() -> [FlashCards]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("sets")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing: nsData)
                if let loadSets = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [FlashCards] {
                    return loadSets
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
}
