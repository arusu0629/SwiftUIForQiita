//
//  EmptyResponse.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

// 空のレスポンス
public struct EmptyResponse: QiitaResponse {
    
    public init(response: HTTPURLResponse, json: Data) throws {
    }
    
}
