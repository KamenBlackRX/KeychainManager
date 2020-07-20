//
//  KeychainProtocols.swift
//  KeychainManager
//
//  Created by Jefferson Barbosa Puchalski on 17/07/20.
//  Copyright © 2020 Interloper. All rights reserved.
//

import Foundation

enum RSABits: Int{
    case defaultBits = 2048
    case maximumBits = 4096
}

enum KeySecErrors: Error {
    case MissingEntitlement
}

/**
 Protocols for keychain manager.
*/
public protocol KeychainProtocol {
    var bundleName: String { get set }
    func save(_ value: String, forKey key: String) throws -> Bool
    func load( forKey key: String) -> String
}

public protocol AsymetricCryptoProtocol {
    var bundleName: String { get set }
    
    func saveCrypto(_ value: String, forKey key: String)throws -> Bool
    func loadCrypto<T: AnyObject>(forKey key: String)throws -> T?
    
    func createRSAKey(name: String, size: Int, forceCreation: Bool) -> Bool?
    func loadRSAKey(name: String) throws -> SecKey?
    
    func getKey() -> SecKey?
}
