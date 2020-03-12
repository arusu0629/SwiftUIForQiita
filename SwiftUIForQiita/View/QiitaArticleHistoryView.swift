//
//  SwiftUIView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/03/12.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct QiitaArticleHistoryView: View {

    private var articles: [Item]
    
    init(_articles: [Item]) {
        self.articles = _articles
    }

    var body: some View {
        VStack {
            if (self.articles.count <= 0) {
                Text("履歴がまだありません")
            }
            else {
                List(self.articles) { article in
                    // TODO: History用のリストアイテムビューを作る
                    QiitaArticleRowView(_article: article)
                }
            }
        }
    }
}

struct QiitaArticleHistoryView_Previews: PreviewProvider {
    @State static private var isHidden = false
    static var previews: some View {
        NavigationView {
            QiitaArticleHistoryView(_articles: articleData)
        }
    }
}
