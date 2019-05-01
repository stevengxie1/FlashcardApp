//
//  QuizViewController.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate {
    
    var set: FlashCards?
    
    var doneSet = [FlashCards.FlashCard]()
    
    var currentIndex = 0
    var isFront = true
    
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var quizTextView: UITextView!
    
    @IBOutlet weak var idonnoButton: UIButton!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the flashcard's image view and text accordingly
        // TODO: Add some kind of try catch in case the index is zero(?) or consider just disabling quiz mode if there's no flashcards
        quizImageView.image = set?.cards[currentIndex].front.photo
        quizTextView.text = set?.cards[currentIndex].front.content
    }
    
    @IBAction func donnoButtonAction(_ sender: Any) {
        // Move the card to the back and refresh or something
        isFront = true
        set?.cards.append((set?.cards[currentIndex])!)
        currentIndex = currentIndex + 1
        refreshImageAndText()
    }
    
    @IBAction func flipButtonAction(_ sender: Any) {
        isFront = !isFront
        refreshImageAndText()
    }
    
    // Assumes the person is clicking next because they answered correctly
    @IBAction func nextButtonAction(_ sender: Any) {
        if(currentIndex + 1 < (set?.cards.count)!){
        currentIndex = currentIndex + 1
        isFront = true
        refreshImageAndText()
        } else {
            // They're done, display an alert
            let alert = UIAlertController(title: "You've finished this set!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                let isPresentingInAddCardMode = self.presentingViewController is UINavigationController
                
                if isPresentingInAddCardMode {
                    self.dismiss(animated: true, completion: nil)
                }
                else if let owningNavigationController = self.navigationController{
                    owningNavigationController.popViewController(animated: true)
                }
            }))
            
            self.present(alert, animated: true)

        }
    }
    
    func refreshImageAndText(){
        if(isFront){
            quizImageView.image = set?.cards[currentIndex].front.photo
            quizTextView.text = set?.cards[currentIndex].front.content
        } else {
            quizImageView.image = set?.cards[currentIndex].back.photo
            quizTextView.text = set?.cards[currentIndex].back.content
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
