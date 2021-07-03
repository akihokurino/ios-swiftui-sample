//
//  WorkoutMenuSelect.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/10.
//

import SwiftUI
import Combine

struct WorkoutMenuSelect: View {
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var keyword: String = ""
    @State private var proceedWorkoutMenuRegistrationFlow = false

    let onSelect: (_ menu: WorkoutMenuModel?) -> Void

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: WorkoutMenuRegisteration()
                        .environmentObject(store),
                    isActive: $proceedWorkoutMenuRegistrationFlow
                ) {
                    EmptyView()
                }
                .isDetailLink(false)
                
                HStack {
                    TextField("名前で検索", text: $keyword, onEditingChanged: { _ in
                    }, onCommit: {
                        self.store.search(keyword: keyword)
                    })
                        .keyboardType(.default)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 45)
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(store.workoutMenuList) { menu in
                            WorkoutMenuSelectionItem(menu: menu)
                                .onTapGesture {
                                    onSelect(menu)
                                }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.vertical, 10)
            }
            .navigationBarTitle("メニュー選択", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    onSelect(nil)
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(Color.black)
                },
                trailing: Button(action: {
                    proceedWorkoutMenuRegistrationFlow = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(Color.blue)
                }
            )
            .alert(isPresented: $errorAlert.isShowAlert) {
                Alert(title: Text(errorAlert.message))
            }
            .onAppear(perform: {
                store.fetchWorkoutMenu { error in
                    self.errorAlert.appError(error)
                }
                
                store.fetchMyWorkoutMenu { error in
                    self.errorAlert.appError(error)
                }
            })
        }
    }
}

struct WorkoutMenuSelect_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutMenuSelect { _ in }.environmentObject(GlobalStore())
    }
}

struct WorkoutMenuSelectionItem: View {
    let menu: WorkoutMenuModel

    var body: some View {
        HStack {
            Image(systemName: "wallet.pass")
                .resizable()
                .foregroundColor(Color.black)
                .frame(width: 35, height: 40, alignment: .center)

            VStack(alignment: .leading) {
                Text(menu.name)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .font(Font.system(size: 15.0))
                    .padding(.horizontal, 15)

                Text(menu.description)
                    .font(Font.system(size: 14.0))
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct WorkoutMenuSelectionItem_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutMenuSelectionItem(menu: WorkoutMenuModel.preview())
            .frame(width: 320, height: 200)
    }
}
