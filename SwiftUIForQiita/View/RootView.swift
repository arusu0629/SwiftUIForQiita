
//  RootView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/04.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject var authManager = AuthManager.sharedManager
    
    var body: some View {
        VStack {
            if (self.authManager.authorized) {
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
