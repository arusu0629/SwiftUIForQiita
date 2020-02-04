//
//  Group.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/04.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

/// Qiita:Teamのグループを表します
///
/// https://qiita.com/api/v2/docs#グループ
public struct Group: Codable, CustomStringConvertible {

    /// データが作成された日時
    public let createdAt: Date

    /// グループの一意なIDを表します
    public let id: Int

    /// グループに付けられた表示用の名前を表します
    public let name: String

    /// グループに付けられた表示用の名前を表します
    public let privated: Bool

    /// データが最後に更新された日時
    public let updatedAt: Date

    /// グループのチーム上での一意な名前を表します
    public let urlName: String

}

extension Group {

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id        = "id"
        case name      = "name"
        case privated  = "private"
        case updatedAt = "updated_at"
        case urlName   = "url_name"
    }

}
