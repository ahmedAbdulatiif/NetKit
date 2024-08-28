//
//  String+Extension.swift
//  El-Araby
//
//  Created by Nesreen Mamdouh on 6/2/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation
import UIKit
import NaturalLanguage

extension String {
    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, locale: nil, arguments: arguments)
    }

    func fromBinaryToInt() -> Int {
        return Int(strtoul(self, nil, 2))
    }

    func detectedLanguage() -> Language? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        return Language(rawValue: languageCode)
    }

}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every nOfChars: Int) {
        for index in indices.dropFirst().reversed()
            where distance(to: index).isMultiple(of: nOfChars) {
            insert(contentsOf: separator, at: index)
        }
    }
    func inserting<S: StringProtocol>(separator: S, every nOfChars: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: nOfChars)
        return string
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}
