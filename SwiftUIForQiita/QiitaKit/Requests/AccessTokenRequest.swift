//
//  AccessTokenRequest.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

public extension QiitaAPI.Authorization {
    
    // 与えられた認証情報をもとに新しいアクセストークンを発行する
    // https://qiita.com/api/v2/docs#post-apiv2access_tokens

    struct AccessTokenRequest: QiitaRequest {
        
        // MARK: Types
        
        public typealias Response = AccessToken
        
        // MARK: Properties
        
        let clientID:     String
        let clientSecret: String
        let code:         String
        
        // MARK: Initialize
        
        public init(clientID: String, clientSecret: String, code: String) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.code = code
        }
        
        // MARK: QiitaRequest
        
        public var method: HTTPMethod {
            return .post
        }
        
        public var path: String {
            return "access_tokens"
        }
        
        public var bodyParams: [String : Any]? {
            return [
                "client_id"     : clientID,
                "client_secret" : clientSecret,
                "code"          : code
            ]
        }
    }
}
