//
//  TraineeRegisterationComplete.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/17.
//

import SwiftUI

struct TraineeRegisterationComplete: View {
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    @EnvironmentObject private var store: GlobalStore
    
    @ObservedObject var errorAlert = ErrorAlert()

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("登録が完了しました")
                    .fontWeight(.bold)
                    .font(Font.system(size: 20.0))
                    .padding(.vertical, 50)

                ActionButton(text: "リストへ", background: .primary) {
                    rootPresentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $errorAlert.isShowAlert) {
            Alert(title: Text(errorAlert.message))
        }
    }
}

struct TraineeRegisterationComplete_Previews: PreviewProvider {
    static var previews: some View {
        TraineeRegisterationComplete().environmentObject(GlobalStore())
    }
}
