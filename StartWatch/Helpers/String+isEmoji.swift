//
//  String+isEmoji.swift
//  StartWatch
//
//  Taken from the excellent article on testing for emoji
//  `Understanding Swift Strings, Emoji, Characters and Scalars
//  by Kevin Rummler
//  https://medium.com/@krmblr/understanding-swift-strings-characters-and-scalars-a4b82f2d8fde
//

import Foundation

extension String {
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }
    var containsEmoji: Bool {
        return contains { $0.isEmoji }
    }
    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains { !$0.isEmoji }
    }
    var emojiString: String {
        return emojis.map { String($0) }.reduce("", +)
    }
    var emojis: [Character] {
        return filter { $0.isEmoji }
    }
    var emojiScalars: [UnicodeScalar] {
        return filter { $0.isEmoji }.flatMap { $0.unicodeScalars }
    }
}
