//
//  TraineeRegisteration.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/17.
//

import PartialSheet
import SwiftUI

struct TraineeRegisteration: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var partialSheetManager: PartialSheetManager
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var isLoading: Bool = false
    @State private var isShowImagePickerView: Bool = false
    @State private var proceedTraineeRegistrationFlow: Bool = false
    @State private var name: String = ""
    @State private var selectedGenderIndex: Int = 0
    @State private var birthdate = Date()
    @State private var phoneNumber: String = ""
    @State private var exerciseHistory: String = ""
    @State private var exerciseGoal: String = ""
    @State private var targetWeight: String = ""
    @State private var currentHeight: String = ""
    @State private var currentWeight: String = ""
    @State private var memo: String = ""
    @State private var profileImage: Image? = nil
    @State private var profileImageData: Data? = nil

    var body: some View {
        ScrollView {
            NavigationLink(
                destination: TraineeRegisterationComplete().environmentObject(store),
                isActive: $proceedTraineeRegistrationFlow
            ) {
                EmptyView()
            }
            .isDetailLink(true)

            VStack {
                Group {
                    TextFieldInput(value: $name, label: "氏名", keyboardType: .default)
                        .padding(.bottom, 20)

                    PickerInput(selectIndex: $selectedGenderIndex, label: "性別", selection: SelectionMaster.gender)
                        .environmentObject(partialSheetManager)
                        .padding(.bottom, 20)

                    DatePickerInput(selectDate: $birthdate, label: "生年月日")
                        .environmentObject(partialSheetManager)
                        .padding(.bottom, 20)

                    TextFieldInput(value: $phoneNumber, label: "電話番号", keyboardType: .numberPad)
                        .padding(.bottom, 20)

                    TextAreaInput(value: $exerciseHistory, label: "運動歴/運動習慣歴", height: 150)
                        .padding(.bottom, 20)

                    TextAreaInput(value: $exerciseGoal, label: "運動目標", height: 150)
                        .padding(.bottom, 20)

                    TextFieldInput(value: $targetWeight, label: "目標体重", keyboardType: .decimalPad)
                        .padding(.bottom, 20)

                    TextFieldInput(value: $currentHeight, label: "入会時の身長", keyboardType: .decimalPad)
                        .padding(.bottom, 20)

                    TextFieldInput(value: $currentWeight, label: "入会時の体重", keyboardType: .decimalPad)
                        .padding(.bottom, 20)

                    TextAreaInput(value: $memo, label: "その他メモ", height: 150)
                        .padding(.bottom, 20)
                }

                ActionButton(text: "写真の登録", background: .primary) {
                    isShowImagePickerView = true
                }
                .padding(.bottom, 20)

                profileImage?.resizable()
                    .frame(width: 250, height: 250)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
        .navigationBarTitle("トレーニー登録", displayMode: .inline)
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
        .addPartialSheet(
            style: PartialSheetStyle(
                background: .solid(Color.white),
                handlerBarColor: .white,
                enableCover: true,
                coverColor: Color.black.opacity(0.6),
                blurEffectStyle: .dark,
                cornerRadius: 10.0,
                minTopDistance: 0.0
            )
        )
        .sheet(isPresented: $isShowImagePickerView) {
            ImagePickerView(isShown: $isShowImagePickerView, image: $profileImage, data: $profileImageData)
        }
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
        var gender = Gender.male
        if selectedGenderIndex == 1 {
            gender = Gender.female
        }

        let now = Date()
        
        let _targetWeight = Float(targetWeight) ?? 0.0
        let _currentHeight = Float(currentHeight) ?? 0.0
        let _currentWeight = Float(currentWeight) ?? 0.0
        
        let newID = TraineeModel.newID()
        
        isLoading = true

        let callback: (AppError?) -> Void = { error in
            self.errorAlert.appError(error)
            self.isLoading = false

            guard error == nil else {
                return
            }

            self.proceedTraineeRegistrationFlow = true
        }
        
        if let imageData = profileImageData {
            StorageUtil.upload(path: "trainee/\(newID).jpeg", data: imageData) { url in
                let newTrainee = TraineeModel.new(
                    id: newID,
                    name: name,
                    gender: gender,
                    birthdate: birthdate,
                    phoneNumber: phoneNumber,
                    exerciseHistory: exerciseHistory,
                    exerciseGoal: exerciseGoal,
                    rawTargetWeight: _targetWeight,
                    rawCurrentHeight: _currentHeight,
                    rawCurrentWeight: _currentWeight,
                    memo: memo,
                    profileImage: url,
                    now: now
                )
                
                guard newTrainee.validate() else {
                    errorAlert.validationError("入力が正しくありません")
                    return
                }
                
                store.addTrainee(trainee: newTrainee) { error in
                    callback(error)
                }
            }
        } else {
            let newTrainee = TraineeModel.new(
                id: newID,
                name: name,
                gender: gender,
                birthdate: birthdate,
                phoneNumber: phoneNumber,
                exerciseHistory: exerciseHistory,
                exerciseGoal: exerciseGoal,
                rawTargetWeight: _targetWeight,
                rawCurrentHeight: _currentHeight,
                rawCurrentWeight: _currentWeight,
                memo: memo,
                profileImage: nil,
                now: now
            )
            
            guard newTrainee.validate() else {
                errorAlert.validationError("入力が正しくありません")
                return
            }
            
            store.addTrainee(trainee: newTrainee) { error in
                callback(error)
            }
        }
    }
}

struct TraineeRegisteration_Previews: PreviewProvider {
    static var previews: some View {
        TraineeRegisteration()
            .environmentObject(PartialSheetManager())
            .environmentObject(GlobalStore())
    }
}
