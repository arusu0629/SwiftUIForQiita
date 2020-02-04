//
//  File.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/04.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

/// 投稿に付けられた個々のタグを表します
public struct Tag: Codable, CustomStringConvertible, QiitaResponse {

    /// タグを特定するための一意な名前
    public let id: String

    /// このタグをフォローしているユーザの数
    public let followersCount: Int

    /// このタグが付けられた投稿の数
    public let itemsCount: Int

    /// このタグに設定されたアイコン画像のURL
    public let iconURL: URL?

}

extension Tag {

    enum CodingKeys: String, CodingKey {
        case id             = "id"
        case followersCount = "followers_count"
        case itemsCount     = "items_count"
        case iconURL        = "icon_url"
    }

}
