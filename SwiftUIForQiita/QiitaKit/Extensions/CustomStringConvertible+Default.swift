//
//  CustomStringConvertible+Default.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

public extension CustomStringConvertible {
    var description: String {
        let selfMirror = Mirror(reflecting: self)
        let property = selfMirror.children.reduce("") {
            $1.label != nil ? $0 + "    \($1.label!) = \($1.value)\n" : $0
        }
        return "<\(Self.self)> {\n\(property)\n"
    }
}
