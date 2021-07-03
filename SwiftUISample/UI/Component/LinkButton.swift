//
//  LinkButton.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/29.
//

import SwiftUI

struct LinkButton<Next: View>: View {
    @Binding var isActive: Bool

    let text: String
    let isDetailLink: Bool
    let next: Next

    init(text: String, isDetailLink: Bool, isActive: Binding<Bool>, @ViewBuilder builder: () -> Next) {
        self.text = text
        self.isDetailLink = isDetailLink
        self.next = builder()
        self._isActive = isActive
    }

    var body: some View {
        Group {
            if isDetailLink {
                NavigationLink(
                    destination: next
                ) {
                    HStack {
                        Spacer()
                        Text(text)
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                .isDetailLink(true)
            } else {
                NavigationLink(
                    destination: next, isActive: $isActive
                ) {
                    HStack {
                        Spacer()
                        Text(text)
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                .isDetailLink(false)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color.blue)
        .clipped()
        .cornerRadius(4.0)
    }
}

struct LinkButton_Previews: PreviewProvider {
    static var previews: some View {
        LinkButton(text: "登録", isDetailLink: false, isActive: .constant(false)) {}.frame(width: 320)
    }
}
