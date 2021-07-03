//
//  TextAreaInput.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/29.
//

import SwiftUI

struct TextAreaInput: View {
    @Binding var value: String

    let label: String
    let height: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(Color.gray)
                .fontWeight(.bold)
                .font(.body)
            TextEditor(text: $value)
                .frame(height: height)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct TextAreaInput_Previews: PreviewProvider {
    static var previews: some View {
        TextAreaInput(value: .constant(""), label: "自由記述", height: 150).frame(width: 320, height: 200)
    }
}
