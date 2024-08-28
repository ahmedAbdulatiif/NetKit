//
//  Localizer.swift
//  Fawry-TicketsMall
//
//  Created by Ali Hamed on 8/28/19.
//  Copyright © 2019 Robusta. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func isRTL() -> Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}

class Localizer: NSObject {

    static var specialKeywords: [String] = []

    static func start() {
        LanguageHandler.setDefaultLanguage(Language.english)
        swizzleUIMethods()
        addSpecialKeywords()
    }

    static func swizzleUIMethods() {
        methodSwizzleGivenClassName(cls: Bundle.self,
                                    originalSelector: #selector(Bundle.localizedString(forKey:value:table:)),
                                    overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
        methodSwizzleGivenClassName(cls: UIApplication.self,
                                    originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection),
                                    overrideSelector: #selector(getter: UIApplication.customUserInterfaceLayoutDirection))
        methodSwizzleGivenClassName(cls: UITextField.self,
                                    originalSelector: #selector(UITextField.layoutSubviews),
                                    overrideSelector: #selector(UITextField.cstmlayoutSubviews))
        methodSwizzleGivenClassName(cls: UILabel.self,
                                    originalSelector: #selector(UILabel.layoutSubviews),
                                    overrideSelector: #selector(UILabel.cstmlayoutSubviews))
    }

    static func addSpecialKeywords() {
        self.specialKeywords = ["Back", "Done"]
    }

    static func setSemanticContentAttribute(direction: UISemanticContentAttribute) {
        UIView.appearance().semanticContentAttribute = direction
        UICollectionView.appearance().semanticContentAttribute = direction
    }

    static func setLanguageTo(_ language: Language) {
        LanguageHandler.setLanguage(language)
        setSemanticContentAttribute(direction: language.direction)
    }
}

extension UILabel {
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.isKind(of: NSClassFromString("UITextFieldLabel")!) {
            return // handle special case with uitextfields
        }
        if self.tag <= 0 {
            if UIApplication.isRTL() {
                if self.textAlignment == .center { return }
                if self.textAlignment == .right {
                    return
                }
            } else {
                if self.textAlignment == .center { return }
                if self.textAlignment == .left {
                    return
                }
            }
        }
        if self.tag <= 0 {
            if UIApplication.isRTL() {
                self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }
        }
    }
}

extension UITextField {
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.tag <= 0 {
            if UIApplication.isRTL() {
                if self.textAlignment == .center { return }
                if self.textAlignment == .right { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .center { return }
                if self.textAlignment == .left { return }
                self.textAlignment = .left
            }
        }
    }
}

extension UIApplication {
    @objc var customUserInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        return LanguageHandler.currentLanguage().interfaceDirection
    }
}

extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        let translate = { (tableName: String?) -> String in
            let currentLanguage = LanguageHandler.currentLanguage()
            var bundle = Bundle.main
            // normal case where the language with locale working
            if let path = Bundle.main.path(forResource: LanguageHandler.currentLanguage().hyphenatedCode, ofType: "lproj") {
                bundle = Bundle(path: path)!
            } else if let path = Bundle.main.path(forResource: currentLanguage.code, ofType: "lproj") {
                bundle = Bundle(path: path)!
            } else {
                let path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                bundle = Bundle(path: path)!
            }
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
        if self == Bundle.main {
           return translate(tableName)
        } // if the external frameworks has no locale property so you have to handle switching yourself
        else if Localizer.specialKeywords.contains(key) {
            return translate("Localizable")
        } else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
}

/// Exchange the implementation of two methods of the same Class
func methodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!
    if class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
    } else {
        method_exchangeImplementations(origMethod, overrideMethod)
    }
}
