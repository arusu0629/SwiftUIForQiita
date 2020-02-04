//
//  ContentView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var qiitaListVM = QiitaListViewModel()
    @ObservedObject var authManager = AuthManager.sharedManager

    init() {
        // 記事を取得する
        if (qiitaListVM.articles.count <= 0) {
            qiitaListVM.fetchGetItems(type: .query(query: "Swift"), page: 1, perPage: 50)
        }
    }

    var body: some View {
        NavigationView {
            List(qiitaListVM.articles) { article in
                NavigationLink(destination: SafariView(url: article.URL)) {
                    QiitaArticleRow(_article: article)
                }
            }
            .navigationBarTitle("SwiftUI For Qiita", displayMode: .inline)
        }.hideNavigationBar()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public struct NavigationBarHider: ViewModifier {
    @State var isHidden: Bool = false

    public func body(content: Content) -> some View {
        content
            .navigationBarTitle("")
            .navigationBarHidden(isHidden)
            .onAppear { self.isHidden = true }
    }
}

extension View {
    public func hideNavigationBar() -> some View {
        modifier(NavigationBarHider())
    }
}
