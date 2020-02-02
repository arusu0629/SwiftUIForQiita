//
//  NSURL+Fragments.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

internal let ISO8601DateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
}()

internal extension URL {
    
    var fragments: [String: String] {
        return URLComponents(string: absoluteString)?
            .queryItems?
            .reduce(into: [String: String]()) {
                $0[$1.name] = $1.value
            } ?? [:]
    }
}
