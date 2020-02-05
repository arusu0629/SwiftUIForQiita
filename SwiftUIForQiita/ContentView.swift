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
            if (isPushedLogout) {
                RootView()
            } else {
                List(qiitaListVM.articles) { article in
                    NavigationLink(destination: SafariView(url: article.URL)) {
                        QiitaArticleRow(_article: article)
                    }
                }
                .navigationBarTitle("SwiftUI For Qiita", displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showingLogoutAlert = true
                }) {
                    Image(systemName: "hand.thumbsdown")
                })
                .alert(isPresented: $showingLogoutAlert) {
                    logoutAlert()
                }
            }
        }
        .hideNavigationBar()
        .onAppear {
            self.isPushedLogout = false
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
