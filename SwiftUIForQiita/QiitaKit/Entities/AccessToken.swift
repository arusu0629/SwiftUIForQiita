//
//  AccessToken.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

// アクセストークン情報
public struct AccessToken: Codable, CustomStringConvertible, QiitaResponse {
    
    public let clientID: String
    
    public let token: String
}

extension AccessToken {
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case token    = "token"
    }
    
}
