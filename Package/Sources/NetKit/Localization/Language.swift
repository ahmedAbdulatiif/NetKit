//
//  Language.swift
//  El-Araby
//
//  Created by Nesreen Mamdouh on 5/17/20.
//  Copyright © 2020 Robusta. All rights reserved.
//
import UIKit

protocol LanguageProtocol {
    var code: String { get }
    var apiHeaderValue: String { get }
    var hyphenatedCode: String { get }
    var name: String { get }
    var localizedName: String { get }
    var direction: UISemanticContentAttribute { get }
    var interfaceDirection: UIUserInterfaceLayoutDirection { get }

}

enum Language: String, LanguageProtocol {

    case arabic = "ar"
    case english = "en"

    var code: String {
        switch self {
        case .arabic:
            return "ar"
        case .english:
            return "en"
        }
    }

    var apiHeaderValue: String {
        switch self {
        case .arabic:
            return "ar_EG"
        case .english:
            return "default"
        }
    }

    var hyphenatedCode: String {
        switch self {
        case .arabic:
            return "ar"
        case .english:
            return "en_US"
        }
    }

    var name: String {
        switch self {
        case .arabic:
            return "arabic"
        case .english:
            return "english"
        }
    }

    var localizedName: String {
        switch self {
        case .arabic:
            return "Arabic".localized
        case .english:
            return "English".localized
        }
    }

    var direction: UISemanticContentAttribute {
        switch self {
        case .arabic:
            return .forceRightToLeft
        case .english:
            return .forceLeftToRight
        }
    }

    var interfaceDirection: UIUserInterfaceLayoutDirection {
        switch self {
        case .arabic:
            return .rightToLeft
        case .english:
            return .leftToRight
        }
    }
}
