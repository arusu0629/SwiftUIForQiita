//
//  LoginView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: AuthorizedView(request: AuthorizedView_Previews.TestAuthrizedRequest())) {
                Text("Qiitaアカウントでログイン")
            }
        }
        .hideNavigationBar()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
