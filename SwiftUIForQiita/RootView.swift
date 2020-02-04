
//  RootView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/04.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            if (AuthManager.sharedManager.authorized) {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
