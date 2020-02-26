//
//  Character+isEmoji.swift
//  StartWatch
//
//  Taken from the excellent article on testing for emoji
//  `Understanding Swift Strings, Emoji, Characters and Scalars
//  by Kevin Rummler
//  https://medium.com/@krmblr/understanding-swift-strings-characters-and-scalars-a4b82f2d8fde
//

import Foundation

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        return unicodeScalars.count == 1 &&
            (firstProperties.isEmojiPresentation ||
                firstProperties.generalCategory == .otherSymbol)
    }
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 &&
            unicodeScalars.contains {
                $0.properties.isJoinControl ||
                    $0.properties.isVariationSelector
        }
    }
    
    var isEmoji: Bool {
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}
