//
//  QiitaArticleRowView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/06.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct QiitaArticleRowView: View {
    
    @ObservedObject var displayAuthorVM = AuthorDisplayVM()
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
                // TODO: 現在時刻との差分
                Text(self.article.updatedAt.description)
            }
            Text(self.article.title)
                .font(.title)
            HStack {
                Image(systemName: "tag.fill")
                Text(self.article.tags.map { $0.name }.joined(separator: " "))
            }
        }
        .padding()
    }
}

struct QiitaArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUI.Group {
            QiitaArticleRowView(_article: articleData[0])
                    
            QiitaArticleRowView(_article: articleData[1])
        }
        //.previewLayout(.fixed(width: 800, height: 150))
    }
}
