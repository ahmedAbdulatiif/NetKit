//
//  String+Extension.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

enum DateFormate: String {
    case yearMonthDay = "yyyy-MM-dd HH:mm:ss"
    case dayMonthYear = "d MMM yyyy"
    case dayMonth = "d MMM"
}

extension String {
    /// A localized value form Localizable base on current app loacl
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    /// A Boolean value indicating whether a string has no characters after removing all whitespaces and all newlines.
    var hasValue: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count != 0
    }

    func toDate(format: DateFormate) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format.rawValue
        let date = dateFormatter.date(from: self)!
        return date
    }

    func removeWhiteSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
