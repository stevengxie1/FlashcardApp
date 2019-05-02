//
//  SetTableViewCell.swift
//  FlashcardApp
//
//  Created by Steven Xie on 4/29/19.
//  Copyright © 2019 EECS392. All rights reserved.
//

import UIKit

protocol SetCellDelegate {
    func didShare(_ cell: SetTableViewCell)
}

class SetTableViewCell: UITableViewCell {

    @IBOutlet weak var setTitle: UILabel!
    @IBOutlet weak var setCardCount: UILabel!
    
    var delegate: SetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func shareCell(_ sender: Any) {
        if let delegateObject = self.delegate {
            delegateObject.didShare(self)
        }
    }

}
