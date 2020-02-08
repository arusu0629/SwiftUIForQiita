//
//  QiitaArticleRow.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct QiitaArticleView: View {

    private var articles: [Item]

    init(_articles: [Item]) {
        self.articles = _articles
    }

    var body: some View {
        VStack {
            List(articles) { article in
                NavigationLink(destination:
                    SafariView(url: article.URL)
                    .onAppear() {
                        // ページを開いたら履歴に登録
                        QiitaHistoryManager.sharedManager.read(readArticle: article)
                    }
                ) {
                    QiitaArticleRowView(_article: article)
                }
            }
           
        }
    }
}

struct QiitaArticleView_Previews: PreviewProvider {
    @State static private var isHidden = false
    static var previews: some View {
        NavigationView {
            QiitaArticleView(_articles: articleData)
        }
    }
}
