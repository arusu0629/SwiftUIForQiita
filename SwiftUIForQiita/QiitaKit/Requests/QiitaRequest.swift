//
//  QiitaRequest.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// QiitaAPIリクエスト用のプロトコル
public protocol QiitaRequest {

    associatedtype Response: QiitaResponse
    
    // HTTPMethod
    var method:  HTTPMethod { get }
    
    // APIパス
    var path: String { get }
    
    // URLクエリ optional
    var queries:  [String: String]? { get }
    
    // HTTPBody optional
    var bodyParams: [String: Any]? { get }

}

extension QiitaRequest {
    
    // APIバージョン
    var version: String {
        return "v2"
    }
    
    // APIホスト
    public var baseURL: URL {
        // TODO: チームドメイン処理
        let domain = "qiita.com"
        return URL(string: "https://\(domain)/api/\(version)")!
    }
    
    // HTTPHeader
    public var headerFields: [String: String] {
        var result = ["Content-Type": "application/json"]
        
        // TODO: アクセストークン処理
        guard let token = AuthManager.sharedManager.accessToken else {
            return result
        }
        
        result["Authorization"] = "Bearer \(token)"
        
        return result
    }
    
    public var queries: [String: String]? {
        return nil
    }
    
    public var bodyParams: [String: Any]? {
        return nil
    }
    
    public func asURLRequest() -> URLRequest {
        let url: URL = {
            var components = URLComponents()
            components.scheme = "https"
            // TODO: チームドメイン処理
            components.host = "qiita.com"
            components.path = "/api/\(version)/\(path)"
            components.queryItems = queries?.map { URLQueryItem(name: $0.key, value: $0.value) }
            return components.url!
        }()
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval:  30)
        request.allHTTPHeaderFields = headerFields
        request.httpBody = bodyParams.map { try!
            JSONSerialization.data(withJSONObject: $0, options: []) }
        request.httpMethod = method.rawValue
        
        return request
    }
}

// ページ可能なリクエストのプロトコル
public protocol QiitaPageableRequestType: QiitaRequest {
    
    // ページ番号(1から100まで)
    var page: Int { get set }
    
    // 1ページあたりに含まれる要素数(1から100まで
    var perPage: Int { get set }
}

public extension QiitaPageableRequestType {
    
    // ページング用パラメータ
    var pageParameters: [String: String] {
        return [
            "page"     : "\(page)",
            "per_page" : "\(perPage)"
        ]
    }
}
