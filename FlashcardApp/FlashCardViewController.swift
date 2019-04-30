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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardTitle.text = card.title
        frontImage.image = card.front.photo
        frontText.text = card.front.content
        backImage.image = card.back.photo
        backText.text = card.back.content
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
