//
//  AsymetricCrypto.swift
//  KeychainManager
//
//  Created by Jefferson Barbosa Puchalski on 17/07/20.
//  Copyright © 2020 Interloper. All rights reserved.
//

import Foundation

class AsymetricCrypto : AsymetricCryptoProtocol {

    var bundleName: String = Bundle.main.bundleIdentifier ?? ""
    
    /**
     This save a crypto key to disk.
     - Parameters:
        - value: Insert value to save key
    */
    func saveCrypto(_ value: String, forKey key: String) throws -> Bool {
        return true
    }
    
    /**
     Load information by crypto
     */
    func loadCrypto<T>(forKey key: String) throws -> T? where T : AnyObject {
        return nil;
    }
    
    func createRSAKey(name: String, size: Int, forceCreation: Bool = false) -> Bool? {
        // Create query and try find some previous key
       return true
    }
    
    func loadRSAKey(name: String) throws -> SecKey? {
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
