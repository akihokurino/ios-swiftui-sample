//
//  SignUp.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/11.
//

import SwiftUI

struct SignUp: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var isLoading: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ScrollView {
            VStack {
                TextFieldInput(value: $email, label: "メールアドレス", keyboardType: .emailAddress)
                    .padding(.bottom, 20)

                SecureFieldInput(value: $password, label: "パスワード", keyboardType: .default)
                    .padding(.bottom, 20)

                ActionButton(text: "登録", background: .primary) {
                    isLoading = true
                    store.signUp(email: email, password: password) { error in
                        self.errorAlert.appError(error)
                        self.isLoading = false
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
        .navigationBarTitle("会員登録", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
            }
        )
        .overlay(Group {
            if isLoading {
                HUD(isLoading: $isLoading)
            }
        }, alignment: .center)
        .alert(isPresented: $errorAlert.isShowAlert) {
            Alert(title: Text(errorAlert.message))
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
