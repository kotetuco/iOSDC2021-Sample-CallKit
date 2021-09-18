//
//  UserDefaultsDriver.swift
//  UserDefaultsUtilities
//
//  Created by kotetu on 2021/07/25.
//

import Foundation

public protocol UserDefaultsDriverInterface {
    func set(string: String, forKey: String)
    func string(forKey: String) -> String?
}

public final class UserDefaultsDriver: UserDefaultsDriverInterface {
    private let suiteName: String?

    public init(suiteName: String? = nil) {
        self.suiteName = suiteName
    }

    public func set(string: String, forKey: String) {
        guard let suiteName = suiteName else {
            UserDefaults.standard.setValue(string, forKey: forKey)
            return
        }
        UserDefaults(suiteName: suiteName)?.setValue(string, forKey: forKey)
    }

    public func string(forKey: String) -> String? {
        guard let suiteName = suiteName else {
            return UserDefaults.standard.string(forKey: forKey)
        }
        return UserDefaults(suiteName: suiteName)?.string(forKey: forKey)
    }
}
