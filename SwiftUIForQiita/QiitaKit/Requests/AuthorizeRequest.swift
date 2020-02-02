//
//  AuthorizeRequest.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

// APIのスコープ
///
/// - ReadQiita:      Qiitaからアクセストークンに紐付いたユーザに関連したデータを読み出す
/// - ReadQiitaTeam:  Qiita:Teamからデータを読み出す
/// - WriteQiita:     Qiitaにデータを書き込む
/// - WriteQiitaTeam: Qiita:Teamにデータを書き込む

public enum Scope: String {
    case readQiita      = "read_qiita"
    case readQiitaTeam  = "read_qiita_team"
    case writeQiita     = "write_qiita"
    case writeQiitaTeam = "write_qiita_team"
}

public extension QiitaAPI.Authorization {
    
    // アプリケーションのユーザに認証画面を表示するためのリクエスト
    struct AuthorizeRequest: QiitaRequest {
        
        // MARK: Types
        
        public typealias Response = EmptyResponse
        
        // MARK: Properties
        
        // 登録されたAPIクライアントを特定するためのIDです。40桁の16進数で表現されます
        let clientID: String
        
        // アプリケーションが利用するスコープ
        let scopes: Set<Scope>
        
        // CSRF対策のため、認可後にリダイレクトするURLのクエリに含まれる値
        let state: String
        
        // MARK: Initialize
        
        public init(clientID: String, scopes: Set<Scope>, state: String) {
            self.clientID = clientID
            self.scopes   = scopes
            self.state    = state
        }
        
        // MARK: QiitaRequest
        
        public var method: HTTPMethod {
            return .get
        }
        
        public var path: String {
            return "oauth/authorize"
        }
        
        public var queries: [String: String]? {
            return [
                "client_id" : clientID,
                "scope"     : scopes.map { $0.rawValue }.joined(separator: " "),
                "state"     : state
            ]
        }
    }
}
