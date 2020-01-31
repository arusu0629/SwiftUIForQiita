//
//  QiitaStruct.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

struct QiitaStruct : Codable, Identifiable {
    var id: String
    var title: String
    var url: String
    var user: User
    struct User: Codable {
        var name: String
    }
}
