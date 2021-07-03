//
//  SecureFieldInput.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/26.
//

import SwiftUI

struct SecureFieldInput: View {
    @Binding var value: String

    let label: String
    let keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(Color.gray)
                .fontWeight(.bold)
                .font(.body)
            SecureField("", text: $value)
                .keyboardType(keyboardType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 45)
        }
    }
}

struct SecureFieldInput_Previews: PreviewProvider {
    static var previews: some View {
        SecureFieldInput(value: .constant(""), label: "パスワード", keyboardType: .default).frame(width: 320, height: 200)
    }
}
