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
    @ObservedObject var historyManager = QiitaHistoryManager.sharedManager
    
    @State private var showingLogoutAlert = false
    @State private var isPushedLogout = false

    init() {
        // 記事を取得する
        if (qiitaListVM.articles.count <= 0) {
            qiitaListVM.fetchGetItems(type: .query(query: "Swift"), page: 1, perPage: 50)
        }
    }

    var body: some View {
        NavigationView {
            // ログアウトボタンを押したら最初のビューに戻る
            if (isPushedLogout) {
                RootView()
            } else {
                TabView {
                    // RecentlyView
                    QiitaArticleView(_articles: qiitaListVM.articles)
                        .tabItem {
                            Image(systemName: "1.square.fill")
                            Text("Recently")
                        }
                    // FavoriteView
                    Text("お気に入り")
                        .tabItem {
                            Image(systemName: "2.square.fill")
                            Text("Favorite")
                        }
                    // HistoryView
                    if (QiitaHistoryManager.sharedManager.recentlyQiitaListItems.count <= 0) {
                        Text("履歴はまだありません")
                        .tabItem {
                            Image(systemName: "3.square.fill")
                            Text("History")
                        }
                    }
                    else {
                        QiitaArticleView(_articles: historyManager.recentlyQiitaListItems)
                        .tabItem {
                            Image(systemName: "3.square.fill")
                            Text("History")
                        }
                    }
                }
                .navigationBarTitle("SwiftUI For Qiita", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showingLogoutAlert = true
                }) {
                    // TODO: 画像変更
                    Image(systemName: "hand.thumbsdown")
                })
                .alert(isPresented: $showingLogoutAlert) {
                    logoutAlert()
                }
            }
        }
    }
    
    func logoutAlert() -> Alert {
        let yesButton = Alert.Button.default(Text("Yes")) {
            do {
                try? self.authManager.logout()
            }
            self.isPushedLogout = true
        }
        return Alert(title: Text("Logout"), message: nil, primaryButton: yesButton, secondaryButton: .cancel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
