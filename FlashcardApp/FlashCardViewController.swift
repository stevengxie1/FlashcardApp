//
//  FlashCardViewController.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit

class FlashCardViewController: UIViewController {
    
    var card = FlashCards.FlashCard()
    
    @IBOutlet weak var cardTitle: UITextField!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var frontText: UITextView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backText: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardTitle.text = card.title
        frontImage.image = card.front.photo
        frontText.text = card.front.content
        backImage.image = card.back.photo
        backText.text = card.back.content
        
        saveButton.isEnabled = false
        updateSaveButtonState()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        let isPresentingInAddCardMode = presentingViewController is UINavigationController
        
        if isPresentingInAddCardMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The FlashCardViewController is not inside a navigation controller.")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        // Set using data fields
        card = FlashCards.FlashCard(title: cardTitle.text!, frontPhoto: frontImage.image, frontContent: frontText.text!, backPhoto: backImage.image, backContent: backText.text!)
    }
    
    // A Check on whether to enable saving the card
    private func updateSaveButtonState() {
        let titleText = cardTitle.text ?? ""
        let text1 = frontText.text ?? ""
        let text2 = backText.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty && !text1.isEmpty && !text2.isEmpty
    }
    

}
