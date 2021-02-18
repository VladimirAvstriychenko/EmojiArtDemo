//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Владимир on 05.02.2021.
//

import Foundation

struct EmojiArt: Codable{
    
    var url: URL?
    var imageData: Data?
    
    var emojis = [EmojiInfo]()
    var json:Data? {
        return try? JSONEncoder().encode(self)
    }
    
    struct EmojiInfo: Codable{
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
    
    init(imageData: Data, emojis: [EmojiInfo]) {
        self.imageData = imageData
        self.emojis = emojis
    }
    
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
}
