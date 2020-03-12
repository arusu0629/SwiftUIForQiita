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
    @ObservedObject var storeManager = QiitaItemStoreManager.sharedManager

    @State private var showingLogoutAlert = false
    @State private var isPushedLogout = false

    var body: some View {
        NavigationView {
            // ログアウトボタンを押したら最初のビューに戻る
            if (isPushedLogout) {
                RootView()
            } else {
                TabView {
                    // RecentlyView
                    QiitaArticleView(qiitaListVM: qiitaListVM)
                        .tabItem {
                            Image(systemName: "1.square.fill")
                            Text("Recently")
                        }
                    // FavoriteView
                    QiitaArticleFavoriteView(_articles: storeManager.favoriteItems)
                        .tabItem {
                            Image(systemName: "2.square.fill")
                            Text("Favorite")
                        }
                    // HistoryView
                    QiitaArticleHistoryView(_articles: storeManager.recentlyItems)
                        .tabItem {
                            Image(systemName: "3.square.fill")
                            Text("History")
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
