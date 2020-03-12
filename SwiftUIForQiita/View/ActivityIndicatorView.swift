//
//  ActivityIndicatorView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/03/12.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

 import SwiftUI
 import UIKit

 struct ActivityIndicator: UIViewRepresentable {
     typealias UIViewType = UIActivityIndicatorView

     @Binding var isAnimating: Bool
     let style: UIActivityIndicatorView.Style

     func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> ActivityIndicator.UIViewType {
         UIActivityIndicatorView(style: style)
     }

     func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
         isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
     }
 }
