//
//  QiitaArticleRow.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct QiitaArticleRow: View {
    
    private var article: QiitaStruct
    
    init(
        _article: QiitaStruct) {
        article = _article
    }
    
    
    var body: some View {
        HStack {
            Text(self.article.user.name)
            Spacer()
            Text(self.article.title)
        }
        .padding()
    }
}

struct QiitaArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        QiitaArticleRow(_article: QiitaStruct(id: "1", title: "Swift初心者", url: "https://qiita.com/arusu0629/items/b0f4da429dde972b9463", user: QiitaStruct.User(name: "なやましまる")))
    }
}
