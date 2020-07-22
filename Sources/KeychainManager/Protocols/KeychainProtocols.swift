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
    /**
     Load string value based in key inside keychain.
     
     Get a provied key and load a string repesentation from storage value from keychain
     - Parameters:
        - key: String representing a key value to be loaded from chain.
     - Note: If value can't be retrived as string, a empty string will be given as return.
     - Returns: A given representation for keychain.
     */
    func load<T>(forKey key: String) -> T?
    
    /**
     Load string value based in key inside keychain.
     
     Get a provied key and load a string repesentation from storage value from keychain
     - Parameters:
        - key: String representing a key value to be loaded from chain.
     - Note: If value can't be retrived as string, a empty string will be given as return.
     - Returns: If string is found, returns a given representation for keychain. Otherwise not.
     */
    func load(forKey key: String) -> String?
}

public protocol AsymetricCryptoProtocol {
    var bundleName: String { get set }
    
    func saveCrypto(_ value: String, forKey key: String)throws -> Bool
    func loadCrypto<T: AnyObject>(forKey key: String)throws -> T?
    
    func createRSAKey(name: String, size: Int, forceCreation: Bool) -> Bool?
    func loadRSAKey(name: String) throws -> SecKey?
    
    func getKey() -> SecKey?
}
