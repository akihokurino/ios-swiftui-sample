//
//  TraineeMealManagementEdit.swift
//  SwiftUISample
//
//  Created by akiho on 2021/03/06.
//

import SwiftUI

struct TraineeMealManagementEdit: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var isLoading: Bool = false
    @State private var carbohydrateAmount: String = ""
    @State private var proteinAmount: String = ""
    @State private var lipidAmount: String = ""

    let trainee: TraineeModel

    init(trainee: TraineeModel) {
        self.trainee = trainee

        if let carbohydrateAmount = trainee.carbohydrateAmount {
            self._carbohydrateAmount = State(initialValue: String(carbohydrateAmount))
        }
        
        if let lipidAmount = trainee.lipidAmount {
            self._lipidAmount = State(initialValue: String(lipidAmount))
        }
        
        if let proteinAmount = trainee.proteinAmount {
            self._proteinAmount = State(initialValue: String(proteinAmount))
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                TextFieldInput(value: $carbohydrateAmount, label: "炭水化物", keyboardType: .decimalPad)
                    .padding(.bottom, 20)

                TextFieldInput(value: $proteinAmount, label: "タンパク質", keyboardType: .decimalPad)
                    .padding(.bottom, 20)

                TextFieldInput(value: $lipidAmount, label: "脂質", keyboardType: .decimalPad)
                    .padding(.bottom, 20)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
        .navigationBarTitle("食事管理", displayMode: .inline)
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
        .alert(isPresented: $errorAlert.isShowAlert) {
            Alert(title: Text(errorAlert.message))
        }
        .overlay(Group {
            if isLoading {
                HUD(isLoading: $isLoading)
            }
        }, alignment: .center)
    }
    
    private func update() {
        guard !carbohydrateAmount.isEmpty && !proteinAmount.isEmpty && !lipidAmount.isEmpty else {
            errorAlert.validationError("入力が正しくありません")
            return
        }
        
        let now = Date()
        
        let _carbohydrateAmount = Int(carbohydrateAmount) ?? 0
        let _proteinAmount = Int(proteinAmount) ?? 0
        let _lipidAmount = Int(lipidAmount) ?? 0
        
        isLoading = true

        let callback: (AppError?) -> Void = { error in
            self.errorAlert.appError(error)
            self.isLoading = false

            guard error == nil else {
                return
            }
        }
        
        store.updateTrainee(trainee: trainee.setMealManagement(
                                carbohydrateAmount: _carbohydrateAmount,
                                proteinAmount: _proteinAmount,
                                lipidAmount: _lipidAmount,
                                now: now)) { error in
            callback(error)
        }
    }
}

struct TraineeMealManagementEdit_Previews: PreviewProvider {
    static var previews: some View {
        TraineeMealManagementEdit(trainee: TraineeModel.preview())
            .environmentObject(GlobalStore())
    }
}
