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
        
    var body: some View {
        NavigationView {
            List(qiitaListVM.articles) { article in
                NavigationLink(destination: SafariView(url: URL(string: article.url))) {
                    QiitaArticleRow(_article: article)
                }
            }
            .navigationBarTitle(Text("Swift UI for Qiita"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
