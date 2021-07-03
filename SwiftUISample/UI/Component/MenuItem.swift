//
//  MenuItem.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/12.
//

import SwiftUI

struct MenuItem<Next: View>: View {
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
                        Text(text)
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                        Spacer()
//                        Image(systemName: "chevron.forward")
                    }
                }
                .isDetailLink(true)
            } else {
                NavigationLink(
                    destination: next, isActive: $isActive
                ) {
                    HStack {
                        Text(text)
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                        Spacer()
//                        Image(systemName: "chevron.forward")
                    }
                }
                .isDetailLink(false)
            }
        }
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(text: "メニュー", isDetailLink: true, isActive: .constant(false)) {}.frame(width: 320, height: 50)
    }
}
