//
//  CommonKeys.swift
//  KeychainManager
//
//  Created by Jefferson Barbosa Puchalski on 17/07/20.
//  Copyright © 2020 Interloper. All rights reserved.
//

import Foundation

/// Common keys for keychain
public enum CommonKeys: String {
    /// Key for a user name.
    case userName  = "user_name"
    /// Key for a password name.
    case passsword  = "password"
    /// Key for a first name.
    case firstName  = "first_name"
    /// Key for a last name.
    case lastName  = "last_name"
    /// Key for a preffered  name or  can be a niclkname.
    case preferedName  = "prefered_name"
}
