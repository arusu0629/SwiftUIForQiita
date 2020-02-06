//
//  AuthorDisplayVM.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/06.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation
import UIKit

class AuthorDisplayVM : ObservableObject {

    @Published var displayImage = UIImage(systemName: "photo")!

    func loadImage(displayImageUrl: URL) {
        let task = URLSession.shared.dataTask(with: displayImageUrl) { (data, _, _) in
            guard let imageData = data else {
                return
            }
            guard let displayImage = UIImage(data: imageData) else {
                return
            }
            self.displayImage = displayImage
        }
        task.resume()
    }
}
