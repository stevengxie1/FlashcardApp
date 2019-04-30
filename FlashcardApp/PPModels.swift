//
//  PPModels.swift
//  PP
//
//  Created by Kevin Qian on 4/28/19.
//  Copyright © 2019 Kevin Qian. All rights reserved.
//

import Foundation
import UIKit

class FlashCards: NSObject, NSCoding {
    class FlashCard {
        class CardFace {
            var photo: UIImage?
            var content: String?
            init(photo: UIImage?, content: String?) {
                self.photo = photo
                self.content = content
            }
        }
        
        var title: String
        var front: CardFace
        var back: CardFace
        
        init(title: String, frontPhoto: UIImage?, frontContent: String?, backPhoto: UIImage?, backContent: String?) {
            self.title = title
            self.front = CardFace(photo: frontPhoto, content: frontContent)
            self.back = CardFace(photo: backPhoto, content: backContent)
        }
        
        convenience init() {
            self.init(title: "Default Name", frontPhoto: nil, frontContent: nil, backPhoto: nil, backContent: nil)
        }
    }
    
    struct PropertyKey {
        static let name = "name"
        static let cards = "cards"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("flashcard")
    
    var name: String
    var cards: [FlashCard]
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(cards, forKey: PropertyKey.cards)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            print("name encoding failed")
            return nil
        }
        guard let cards = aDecoder.decodeObject(forKey: PropertyKey.cards) as? [FlashCard] else {
            print("cards encoding failed")
            return nil
        }
        self.init(name: name, cards: cards)
    }
    
    init(name: String, cards: [FlashCard]) {
        self.name = name
        self.cards = cards
    }
    
    convenience init(name: String){
        self.init(name: name, cards: [FlashCard]())
    }
}
