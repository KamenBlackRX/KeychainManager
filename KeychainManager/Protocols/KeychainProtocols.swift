//
//  KeychainProtocols.swift
//  KeychainManager
//
//  Created by Jefferson Barbosa Puchalski on 17/07/20.
//  Copyright © 2020 Interloper. All rights reserved.
//

import Foundation

/**
 Protocols for keychain manager.
*/
public protocol KeychainProtocol {
    var bundleName: String { get set }
    func save(_ value: String, forKey key: String) -> Bool
    func load( forKey key: String) -> String
    
    func saveCrypto(_ value: String, forKey key: String)throws -> Bool
    func loadCrypto<T: AnyObject>(forKey key: String)throws -> T?
}
