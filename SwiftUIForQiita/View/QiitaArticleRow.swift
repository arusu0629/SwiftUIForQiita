//
//  QiitaArticleRow.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct QiitaArticleRow: View {
    
    private var article: Item
    
    init(_article: Item) {
        article = _article
    }
    
    
    var body: some View {
        HStack {
            Text(article.user.name ?? "")
            Spacer()
            Text(article.title)
        }
        .padding()
    }
}
