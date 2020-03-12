//
//  QiitaArticleRowView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/06.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI
import SwiftDate

struct QiitaArticleRowView: View {
    
    @ObservedObject var displayAuthorVM = AuthorDisplayVM()
    @State private var isFavorite = false
    
    var article: Item
        
    init(_article: Item) {
        self.article = _article
        displayAuthorVM.loadImage(displayImageUrl: self.article.user.profileImageURL)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(uiImage: displayAuthorVM.displayImage)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(self.article.user.name ?? "名無しさん")
                Spacer()
                // 投稿日時表示
                Text(articlePostedDateString(postedDate: self.article.createdAt))
            }
            NavigationLink(destination: getSafariView(article: self.article)) {
                Text(self.article.title)
                    .font(.title)
            }
            HStack {
                Image(systemName: "tag.fill")
                Text(self.article.tags.map { $0.name }.joined(separator: " "))
                Spacer()
                Image(systemName: "star.fill")
                    .onAppear() {
                        // State変数はinit時に初期化しても反映されないためviewのOnAppearで行う
                        self.isFavorite = self.isFavorite(id: self.article.id)
                    }
                    .imageScale(.large)
                    .foregroundColor(isFavorite ? .yellow : .black)
                    .onTapGesture(count: 1) {
                        self.isFavorite.toggle()
                        self.isFavorite ? QiitaItemStoreManager.sharedManager.addFavoriteItem(targetItem: self.article) : QiitaItemStoreManager.sharedManager.removeFavoriteItem(targetItem: self.article)
                    }
            }
        }
        .padding()
    }

    private func getSafariView(article: Item) -> some View {
        return
            SafariView(url: article.URL)
                .onAppear() {
                    QiitaItemStoreManager.sharedManager.addRecentlyItem(targetItem: article)
                }
    }
    
    private func isFavorite(id: String) -> Bool {
        return QiitaItemStoreManager.sharedManager.favoriteItems.contains { (item) in item.id == id }
    }
    
    private func articlePostedDateString(postedDate: Date) -> String {

        let now = Date()
        let diff = now - postedDate

        if let month = diff.month, month > 0 {
            return "\(month)月前"
        }
        if let day = diff.day, day > 0 {
            return "\(day)日前"
        }
        if let hour = diff.hour, hour > 0 {
            return "\(hour)時間前"
        }
        if let minute = diff.minute, minute > 0 {
            return "\(minute)分前"
        }
        return "\(diff.second ?? 1)秒前"
    }
}

struct QiitaArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        QiitaArticleRowView(_article: articleData[0])
        .previewLayout(.fixed(width: 800, height: 150))
    }
}
