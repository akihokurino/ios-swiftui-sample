//
//  PasswordEdit.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/12.
//

import SwiftUI

struct PasswordEdit: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var store: GlobalStore
    
    @ObservedObject var errorAlert = ErrorAlert()

    @State private var isLoading: Bool = false
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                SecureFieldInput(value: $currentPassword, label: "現在のパスワード", keyboardType: .default)
                    .padding(.bottom, 20)

                SecureFieldInput(value: $newPassword, label: "新しいパスワード", keyboardType: .default)
                    .padding(.bottom, 20)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
        .navigationBarTitle("パスワード変更", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
            },
            trailing: Button(action: {
                update()
            }) {
                Text("更新")
                    .foregroundColor(Color.blue)
                    .fontWeight(.bold)
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
    
    private func update() {
        isLoading = true
        
        store.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
            self.errorAlert.appError(error)
            self.isLoading = false
            
            guard error == nil else {
                return
            }
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct PasswordEdit_Previews: PreviewProvider {
    static var previews: some View {
        PasswordEdit()
    }
}
