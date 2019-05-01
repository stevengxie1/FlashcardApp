//
//  FlashCardViewController.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit

class FlashCardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var card = FlashCards.FlashCard()
    var frontImageTapped = false
    
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
        if let fimage = card.front.photo{
            frontImage.image = fimage
        }
        if let bimage = card.back.photo{
            backImage.image = bimage
        }
        frontText.text = card.front.content
        backText.text = card.back.content
        frontImage.isMultipleTouchEnabled = true
        frontImage.isUserInteractionEnabled = true
        backImage.isMultipleTouchEnabled = true
        backImage.isUserInteractionEnabled = true
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
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textViewShouldReturn(_ textField: UITextView) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
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
        card = FlashCards.FlashCard(title: cardTitle.text!, frontPhoto: frontImage.image, frontContent: frontText.text, backPhoto: backImage.image, backContent: backText.text)
    }
    
    // A Check on whether to enable saving the card
    private func updateSaveButtonState() {
        let titleText = cardTitle.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        if frontImageTapped {
            frontImage.image = selectedImage
        } else {
            backImage.image = selectedImage
        }
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func frontTapped(_ sender: UITapGestureRecognizer) {
        frontImageTapped = true
        invokePicSelector()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        frontImageTapped = false
        invokePicSelector()
    }
    
    private func invokePicSelector() {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}
