//
//  Root.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/11.
//

import PartialSheet
import SwiftUI

struct Root: View {
    @EnvironmentObject private var store: GlobalStore
    @EnvironmentObject private var partialSheetManager: PartialSheetManager

    @ObservedObject var errorAlert = ErrorAlert()

    var body: some View {
        Group {
            if store.authState == .alreadyLogin {
                TabView {
                    TraineeList()
                        .environmentObject(store)
                        .environmentObject(partialSheetManager)
                        .tabItem {
                            VStack {
                                Image(systemName: "person.circle")
                                Text("トレーニー")
                            }
                        }.tag(1)
                    Setting()
                        .environmentObject(store)
                        .tabItem {
                            VStack {
                                Image(systemName: "gearshape")
                                Text("設定")
                            }
                        }.tag(2)
                }
            } else if store.authState == .notLogin {
                SignIn()
                    .environmentObject(store)
            }
        }
        .onAppear(perform: {
            store.initialize { error in
                self.errorAlert.appError(error)
            }
        })
        .alert(isPresented: $errorAlert.isShowAlert) {
            Alert(title: Text(errorAlert.message))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root()
    }
}
