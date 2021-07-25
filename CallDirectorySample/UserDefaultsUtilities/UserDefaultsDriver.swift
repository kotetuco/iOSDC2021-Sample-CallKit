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
    private let appGroupID: String

    public init(appGroupID: String) {
        self.appGroupID = appGroupID
    }

    public func set(string: String, forKey: String) {
        UserDefaults(suiteName: appGroupID)?.setValue(string, forKey: forKey)
    }

    public func string(forKey: String) -> String? {
        return UserDefaults(suiteName: appGroupID)?.string(forKey: forKey)
    }
}
