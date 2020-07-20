//
//  KeychainManager.swift
//  KeychainManager
//
//  Created by Jefferson Barbosa Puchalski on 14/05/20.
//  Copyright © 2020 Interloper. All rights reserved.
//

import Foundation

/**
 Keychaim manager wrapper
 
 Class responsible for save and load all configuration in encrypted keychain.
 */
public class KeychainManager: KeychainProtocol {
    
    /** Bundle name for save keys */
    public var bundleName: String
    
    public init(for bundle: Bundle) {
        self.bundleName = bundle.bundleIdentifier ?? "default"
        // TODO: Add a debug framework latter
        //Logger.shared.logDebug(message: "Initialize keymanager instance", category: .application, args: nil)
        
    }
    
    public convenience init(instance: AnyClass) {
        self.init(for: Bundle.init(for: instance))
    }
   
    /**
     Load string value based in key inside keychain.
     
     Get a provied key and load a string repesentation from storage value from keychain.
     - Note: If value can't be retrived as string, a empty string will be given as return.
     - Returns: A string representation for keychain.
     */
    public func load<T>(forKey key: String) -> T {
        let query: [String: AnyObject] = [
             kSecClass as String: kSecClassGenericPassword as NSString,
             kSecMatchLimit as String: kSecMatchLimitOne,
             kSecReturnData as String: kCFBooleanTrue,
             kSecAttrService as String: self.bundleName as AnyObject,
             kSecAttrAccount as String: key as AnyObject
           ]
            var result: AnyObject?
            let status: OSStatus = withUnsafeMutablePointer(to: &result) {
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }
        if status != noErr {
            print("Error while loading key.")
            return "" as! T
            
        }
        
        return result as! T
    }
    
    public func save(_ value: String, forKey key: String) throws -> Bool {
        // create Default dictonary for key
        let query: [String: AnyObject] = [
          kSecClass as String: (kSecClassGenericPassword as NSString),
          kSecAttrAccount as String: key as AnyObject,
          kSecAttrService as String: self.bundleName as AnyObject,
          kSecValueData as String: value.data(using: String.Encoding.utf8, allowLossyConversion: false)! as AnyObject
        ]
        // Delete previous keys if any exsist.
        _  =  SecItemDelete(query as CFDictionary)
        
        // Get result and validate if we got error.
        var result: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(to: &result) {
            SecItemAdd(query as CFDictionary, UnsafeMutablePointer($0))
        }
        if status == noErr {
            return true
        } else {
            switch status {
            case errSecMissingEntitlement:
                throw KeySecErrors.MissingEntitlement
            default:
                break;
            }
            
            return false
        }
    }
    
    @discardableResult
    public func delete(forKey key: String) -> Bool {
        // Build query for look in keychain.
        let query: [String: AnyObject] = [
            kSecClass as String: (kSecClassGenericPassword as NSString),
            kSecAttrAccount as String: key as AnyObject,
            kSecAttrService as String: self.bundleName as AnyObject
        ]
        // check if delete operation has a sucessfull result
        let response = SecItemDelete(query as CFDictionary)
        if response == noErr {
            return true
        } else {
            return false
        }
    }
    
   public func saveCrypto(_ value: String, forKey key: String) throws -> Bool {
        // Get a tag for key and create a new RSA key
        let tag = "\(bundleName).keys.password".data(using: .utf8)!
        // find created keys
        let key = try createOrLoadAsymetricKey()
        // Create a query dictonary to save key
        let addquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueRef as String: key!
        ]
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemAdd(addquery as CFDictionary, UnsafeMutablePointer($0))
        }
        guard status == errSecSuccess else {
            throw KeychainError(error: result)
        }
        return true
    }
    
   public func loadCrypto<T: AnyObject>(forKey key: String) throws -> T? {
        // Get a tag for key and create a new RSA key
        let tag = "\(bundleName).keys.password".data(using: .utf8)!
        // find created keys
        let key = try createOrLoadAsymetricKey()
        // Create a query dictonary to save key
        let loadQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueRef as String: key!
        ]
        var result: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(loadQuery as CFDictionary, UnsafeMutablePointer($0))
        }
        if status == errSecSuccess { } else {
            throw KeychainError(error: status as AnyObject)
        }
        return result as? T
    }
}

private extension KeychainManager {
    
    func createOrLoadAsymetricKey() throws -> SecKey? {
        // Get a tag for key and create a new RSA key
        let tag = "\(bundleName).keys.password".data(using: .utf8)!
        
        // Create a query dictonary for find cryto RSA key
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrService as String: self.bundleName as AnyObject,
            kSecAttrAccount as String: "keys.password"  as AnyObject
        ]
        // If we have this result delete.
        let result = SecItemDelete(query as CFDictionary)
        if result == noErr {
            print("Deleted key")
            let attributes: [String: Any] = [
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA ,
                kSecAttrKeySizeInBits as String: 2048,
                kSecPrivateKeyAttrs as String:
                    [ kSecAttrIsPermanent as String: true,
                      kSecAttrApplicationTag as String: tag ]
            ]
            var error: Unmanaged<CFError>?
            guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            let publicKey = SecKeyCopyPublicKey(privateKey)
            return publicKey
            
        } else {
            return getKey()
        }
    }
    
    func getKey() -> SecKey? {
        // Get a tag for key and create a new RSA key
        let tag = "\(bundleName).keys.password".data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        return (item as! SecKey)
    }
}
