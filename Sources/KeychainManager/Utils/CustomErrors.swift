//
//  CustomErrors.swift
//  KeychainManager
//
//  Created by Jefferson Barbosa Puchalski on 17/07/20.
//  Copyright © 2020 Interloper. All rights reserved.
//

import Foundation
/// A custom implementation of error to keychain manager.
public struct KeychainError: Error {
    /// A generic error key
    var error: AnyObject?
}
