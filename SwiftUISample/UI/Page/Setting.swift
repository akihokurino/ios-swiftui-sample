//
//  Setting.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/12.
//

import SwiftUI

struct Setting: View {
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section(
                    footer: ActionButton(text: "ログアウト", background: .caution) {
                        isLoading = true
                        store.logout { error in
                            self.errorAlert.appError(error)
                            self.isLoading = false
                        }
                    }
                    .padding(.vertical, 60)
                    .padding(.horizontal, 0)
                ) {
                    MenuItem(text: "メールアドレス変更", isDetailLink: true, isActive: .constant(true)) {
                        EmailEdit().environmentObject(store)
                    }.frame(height: 40)

                    MenuItem(text: "パスワード変更", isDetailLink: true, isActive: .constant(true)) {
                        PasswordEdit().environmentObject(store)
                    }.frame(height: 40)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("設定", displayMode: .inline)
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
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}
