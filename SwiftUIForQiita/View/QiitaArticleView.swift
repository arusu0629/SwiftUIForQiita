//
//  QiitaArticleRow.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh

struct QiitaArticleView: View {

    @State private var isShowing = false
    @State private var isFetching = false
    @ObservedObject private var qiitaListVM: QiitaListViewModel
    
    init(qiitaListVM: QiitaListViewModel) {
        self.qiitaListVM = qiitaListVM
    }

    var body: some View {
        VStack {
            if (self.qiitaListVM.articles.count <= 0) {
                ActivityIndicator(isAnimating: self.$isFetching, style: .medium)
            }
            else {
                List(self.qiitaListVM.articles) { article in
                    QiitaArticleRowView(_article: article)
                }
                .pullToRefresh(isShowing: $isShowing) {
                    self.qiitaListVM.reloadItems(onCompletion: {
                        self.isShowing = false
                    })
                }
            }
        }
        .onAppear() {
            self.fetchArticles()
        }
    }
    
    private func fetchArticles() {
        self.isFetching = true
        self.qiitaListVM.reloadItems(onCompletion: {
            self.isFetching = false
        })
    }
}

struct QiitaArticleView_Previews: PreviewProvider {
    @State static private var isHidden = false
    static var previews: some View {
        NavigationView {
            QiitaArticleView(qiitaListVM: QiitaListViewModel())
        }
    }
}
