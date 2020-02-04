//
//  GetItemsRequest.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/04.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

public extension QiitaAPI.Item {
    
    // MARK: Types
    
    // 取得する投稿のタイプ
    
    // 取得する投稿のタイプ
    //
    // - query:               クエリにマッチする投稿一覧
    // - tag:                 指定されたタグが付けられた投稿一覧
    /// - authenticatedUser:   認証中のユーザの投稿一覧
    // - userPosted:          指定されたユーザの投稿一覧
    // - userStocks:          指定されたユーザがストックした投稿一覧
    enum ItemsType {
        case query(query: String)
        case tag(tagID: String)
        case authenticatedUser
        case userPosted(userId: String)
        case userStocks(userId: String)
    }
    
    // 投稿の一覧を作成日時の降順で返す
    // https://qiita.com/api/v2/docs#get-apiv2items
    struct GetItemsRequest: QiitaPageableRequestType {

        public typealias Response = PageableResponse<Item>
        
        // MARK: Properties
        
        // 取得する投稿のタイプ
        public let type: ItemsType
        
        // ページ番号(1から100まで)
        public var page: Int
        
        // １ページあたりに含まれる要素数(1から100まで)
        public var perPage: Int
        
        // MARK: Initialize
        
        public init(type: ItemsType, page: Int, perPage: Int) {
            self.type = type
            self.page = page
            self.perPage = perPage
        }
        
        // MARK: QiitaPageableRequestType
        
        public var method: HTTPMethod {
            return .get
        }
        
        public var path: String {
            switch type {
            case .query:                  return "items"
            case .tag(let tagID):         return "tags/\(tagID)/items"
            case .authenticatedUser:      return "authenticated_user/items"
            case .userPosted(let userID): return "users/\(userID)/items"
            case .userStocks(let userID): return "users/\(userID)/stocks"
            }
        }
        
        public var queries: [String : String]? {
            var params = pageParameters
            if case .query(let query) = type {
                params["query"] = query
            }
            return params
        }
    }
}
