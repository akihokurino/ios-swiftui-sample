//
//  WorkoutMenuRegistration.swift
//  SwiftUISample
//
//  Created by akiho on 2021/02/13.
//

import Combine
import SwiftUI

struct WorkoutMenuRegisteration: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var isLoading: Bool = false
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                TextFieldInput(value: $name, label: "名前", keyboardType: .default)
                    .padding(.bottom, 20)
                
                TextFieldInput(value: $description, label: "説明", keyboardType: .default)
                    .padding(.bottom, 20)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
        .navigationBarTitle("メニュー登録", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
            }, trailing: Button(action: {
                registration()
            }) {
                Text("登録")
                    .foregroundColor(Color.blue)
                    .fontWeight(.bold)
            }
        )
        .alert(isPresented: $errorAlert.isShowAlert) {
            Alert(title: Text(errorAlert.message))
        }
        .overlay(Group {
            if isLoading {
                HUD(isLoading: $isLoading)
            }
        }, alignment: .center)
    }

    private func registration() {
        if name.isEmpty {
            errorAlert.validationError("入力が正しくありません")
            return
        }
        
        isLoading = true

        store.addWorkoutMenu(name: name, description: description) { error in
            self.errorAlert.appError(error)
            self.isLoading = false

            guard error == nil else {
                return
            }

            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct WorkoutMenuRegisteration_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutMenuRegisteration()
            .environmentObject(GlobalStore())
    }
}
