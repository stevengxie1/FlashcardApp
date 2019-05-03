//
//  FlashCardTableViewCell.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit

class FlashCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flashcardTitle: UILabel!

    @IBOutlet weak var frontTextView: UILabel! 
    @IBOutlet weak var backTextView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
