//
//  GetItemRequest.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/04.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

public extension QiitaAPI.Item {

    /// 投稿を取得します
    ///
    /// https://qiita.com/api/v2/docs#get-apiv2itemsitem_id
    struct GetItemRequest: QiitaRequest {

        public typealias Response = Item

        // MARK: Properties

        // 取得する投稿ID
        public let itemID: String

        // MARK: Initialize

        public init(itemID: String) {
            self.itemID = itemID
        }

        // MARK: QiitaRequest

        public var method: HTTPMethod {
            return .get
        }

        public var path: String {
            return "items/\(itemID)"
        }
    }
}
