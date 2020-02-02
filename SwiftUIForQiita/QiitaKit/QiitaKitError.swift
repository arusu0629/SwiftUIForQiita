//
//  QiitaKitError.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

// API共通のエラー
public struct APIError: Codable, CustomStringConvertible {
    
    public let message: String
    
    public let type: String

}

// QiitaAPIからのエラー
public enum QiitaKitError: Error {

    case invalidRedirectScheme
    
    case invalidState
    
    case faildToGetAccessToken
    
    case alreadyStocked
    
    case apiError(APIError)
    
    case invalidJSON(Swift.Error)
    
    case unknown
    
    case urlSessionError(Swift.Error)
    
    internal init(object: Data) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        guard let error = try? jsonDecoder.decode(APIError.self, from: object) else {
            self = .unknown
            return
        }
        
        switch error.type {
        case "already_stocked": self = .alreadyStocked
        default:                self = .apiError(error)
        }
    }
}
