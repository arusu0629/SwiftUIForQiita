//
//  QiitaResponse.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

// QiitaAPIレスポンス用のプロトコル
public protocol QiitaResponse {
    
    init(response: HTTPURLResponse, json: Data) throws
    
}

extension QiitaResponse where Self: Decodable {
    
    public init(response: HTTPURLResponse, json: Data) throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        self = try jsonDecoder.decode(Self.self, from: json)
    }
}

//extension Array: QiitaResponse {
//
//}
