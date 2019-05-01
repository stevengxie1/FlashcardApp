//
//  PPModels.swift
//  PP
//
//  Created by Kevin Qian on 4/28/19.
//  Copyright © 2019 Kevin Qian. All rights reserved.
//

import Foundation
import UIKit

class FlashCards: NSObject, NSCoding{
    @objc(_TtCC12FlashcardApp10FlashCards9FlashCard)class FlashCard: NSObject, NSCoding{
        func encode(with aCoder: NSCoder) {
            aCoder.encode(title, forKey: PropertyKey.title)
            aCoder.encode(front, forKey: PropertyKey.front)
            aCoder.encode(back, forKey: PropertyKey.back)
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
                print("name decoding failed")
                return nil
            }
            guard let front = aDecoder.decodeObject(forKey: PropertyKey.front) as? CardFace else {
                print("front decoding failed")
                return nil
            }
            guard let back = aDecoder.decodeObject(forKey: PropertyKey.back) as? CardFace else {
                print("back decoding failed")
                return nil
            }
            self.init(title: title, front: front, back: back)
        }
        
        struct PropertyKey {
            static let title = "title"
            static let front = "front"
            static let back = "back"
        }
        
        @objc(_TtCCC12FlashcardApp10FlashCards9FlashCard8CardFace)class CardFace: NSObject, NSCoding{
            func encode(with aCoder: NSCoder) {
                aCoder.encode(photo, forKey: PropertyKey.photo)
                aCoder.encode(content, forKey: PropertyKey.content)
            }
            
            required convenience init?(coder aDecoder: NSCoder) {
                let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
                let content = aDecoder.decodeObject(forKey: PropertyKey.content) as? String
                self.init(photo: photo, content: content)
            }
            
            var photo: UIImage?
            var content: String?
            init(photo: UIImage?, content: String?) {
                self.photo = photo
                self.content = content
            }
            
            struct PropertyKey {
                static let photo = "photo"
                static let content = "content"
            }
            
        }
        
        var title: String
        var front: CardFace
        var back: CardFace
        
        init(title: String, front: CardFace, back: CardFace) {
            self.title = title
            self.front = front
            self.back = back
        }
        
        convenience init(title: String, frontPhoto: UIImage?, frontContent: String?, backPhoto: UIImage?, backContent: String?) {
            self.init(title: title, front: CardFace(photo: frontPhoto, content: frontContent), back: CardFace(photo: backPhoto, content: backContent))
        }
        
        convenience override init() {
            self.init(title: "Default Name", frontPhoto: nil, frontContent: nil, backPhoto: nil, backContent: nil)
        }
    }
    
    struct PropertyKey {
        static let name = "name"
        static let cards = "cards"
    }
    
    var name: String
    var cards: [FlashCard]
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(cards, forKey: PropertyKey.cards)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            print("name decoding failed")
            return nil
        }
        guard let cards = aDecoder.decodeObject(forKey: PropertyKey.cards) as? [FlashCard] else {
            print("cards decoding failed")
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
    
   //enum CodingKeys: String, CodingKey {
   //    case name
   //    case cards
   //}
   //
   //required convenience init(from decoder: Decoder) throws {
   //    let container = try decoder.container(keyedBy: CodingKeys.self)
   //    name = try container.decode(String.self, forKey: .name)
   //
   //    let cardsData = try container.decode(Data.self, forKey: .cards)
   //    cards = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardsData) as! [FlashCard]
   //}
   //
   //func encode(to encoder: Encoder) throws {
   //    var container = encoder.container(keyedBy: CodingKeys.self)
   //    try container.encode(name, forKey: .name)
   //
   //    let cardData = try NSKeyedArchiver.archivedData(withRootObject: cards, requiringSecureCoding: false)
   //    try container.encode(cardData, forKey: .cards)
   //}

}
