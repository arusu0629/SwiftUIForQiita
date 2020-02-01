//
//  KeychainWrapper.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

public struct KeychainConfiguration {

    let service: String
    
    let accessGroup: String?
    
    public init(service: String = "com.t-nakandakari.QiitaKitForSwiftUI", accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
}

internal struct KeychainWrapper {
    
    // MARK: Types
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: Properties
    
    let config: KeychainConfiguration
    
    // MARK: Initalization
    
    init(config: KeychainConfiguration) {
        self.config = config
    }
    
    // MARK: Keychain access
    
    func keychainQuery(withKey key: String) -> [String : Any] {
        var query = [String : Any]()
        
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = config.service as Any?
        query[kSecAttrAccount as String] = key as Any?
        
        if let accessGroup = config.accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as Any?
        }
        
        return query
    }
    
    func read(withKey key: String) throws -> String {
        var query = keychainQuery(withKey: key)
        query[kSecMatchLimit as String]       = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String]       = kCFBooleanTrue
        
        var queryResult: AnyObject?

        // TODO: よく分からないから要復習
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw
            KeychainError.noPassword
        }
        guard status == noErr else { throw
            KeychainError.unhandledError(status: status)
        }
        
        guard let existingItem = queryResult as? [String : Any],
            let passwordData = existingItem[kSecValueData as String]   as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedPasswordData
            }
        
        return password
    }
    
    func save(_ password: String, forKey key: String) throws {
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            try _ = read(withKey: key)
            
            var attrinbutesToUpdate = [String : Any]()
            attrinbutesToUpdate[kSecValueData as String] = encodedPassword as Any?
            
            let query = keychainQuery(withKey: key)
            let status = SecItemUpdate(query as CFDictionary, attrinbutesToUpdate as CFDictionary)
            
            guard status == noErr else { throw
                KeychainError.unhandledError(status: status)
            }
        }
        catch KeychainError.noPassword {
            var newItem = keychainQuery(withKey: key)
            newItem[kSecValueData as String] = encodedPassword as Any?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw
                KeychainError.unhandledError(status: status)
            }
        }
    }
    
    func deleteItem(withKey key: String) throws {
        let query = keychainQuery(withKey: key)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw
            KeychainError.unhandledError(status: status)
        }
    }
}
