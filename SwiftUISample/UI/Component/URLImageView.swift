//
//  URLImageView.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/03.
//

import SwiftUI
import URLImage

struct URLImageView: View {
    let id: String
    let url: URL?
    
    var body: some View {
        Group {
            if let imageURL = url {
                URLImage(
                    url: imageURL,
//                    options: URLImageOptions(
//                        identifier: id,
//                        expireAfter: 300.0,
//                        cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25)
//                    ),
                    empty: {
                        EmptyView()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.6))
                    },
                    inProgress: { _ -> Text in
                        Text("")
                    },
                    failure: { _, _ in
                        EmptyView()
                    },
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                )
            } else {
                ZStack {
                    Spacer()
                }
            }
        }
    }
}

struct URLImageView_Previews: PreviewProvider {
    static var previews: some View {
        URLImageView(id: "1", url: URL(string: "http://placehold.jp/150x150.png")).frame(width: 80, height: 80)
    }
}
