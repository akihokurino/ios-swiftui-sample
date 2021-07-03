//
//  TraineeEdit.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/29.
//

import PartialSheet
import SwiftUI

struct TraineeEdit: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var partialSheetManager: PartialSheetManager
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var isLoading: Bool = false
    @State private var isShowImagePickerView: Bool = false
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

    let trainee: TraineeModel

    init(trainee: TraineeModel) {
        self.trainee = trainee

        self._name = State(initialValue: trainee.name)
        self._selectedGenderIndex = State(initialValue: trainee.gender == Gender.male ? 0 : 1)
        self._birthdate = State(initialValue: trainee.birthdate)
        self._phoneNumber = State(initialValue: trainee.phoneNumber)
        self._exerciseHistory = State(initialValue: trainee.exerciseHistory)
        self._exerciseGoal = State(initialValue: trainee.exerciseGoal)
        self._targetWeight = State(initialValue: String(trainee.targetWeight))
        self._currentHeight = State(initialValue: String(trainee.currentHeight))
        self._currentWeight = State(initialValue: String(trainee.currentWeight))
        self._memo = State(initialValue: trainee.memo)
    }

    var body: some View {
        ScrollView {
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
        .navigationBarTitle("トレーニー編集", displayMode: .inline)
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

    private func update() {
        var gender = Gender.male
        if selectedGenderIndex == 1 {
            gender = Gender.female
        }
        
        isLoading = true

        let callback: (AppError?) -> Void = { error in
            self.errorAlert.appError(error)
            self.isLoading = false

            guard error == nil else {
                return
            }

            self.presentationMode.wrappedValue.dismiss()
        }

        if let imageData = profileImageData {
            StorageUtil.upload(path: "trainee/\(trainee.id).jpeg", data: imageData) { url in
                let updateTrainee = trainee.update(
                    name: name,
                    gender: gender,
                    birthdate: birthdate,
                    phoneNumber: phoneNumber,
                    exerciseHistory: exerciseHistory,
                    exerciseGoal: exerciseGoal,
                    rawTargetWeight: Float(targetWeight) ?? 0.0,
                    rawCurrentHeight: Float(currentHeight) ?? 0.0,
                    rawCurrentWeight: Float(currentWeight) ?? 0.0,
                    memo: memo,
                    profileImage: url,
                    now: Date()
                )

                guard updateTrainee.validate() else {
                    errorAlert.validationError("入力が正しくありません")
                    return
                }
                
                store.updateTrainee(trainee: updateTrainee) { error in
                    callback(error)
                }
            }
        } else {
            let updateTrainee = trainee.update(
                name: name,
                gender: gender,
                birthdate: birthdate,
                phoneNumber: phoneNumber,
                exerciseHistory: exerciseHistory,
                exerciseGoal: exerciseGoal,
                rawTargetWeight: Float(targetWeight) ?? 0.0,
                rawCurrentHeight: Float(currentHeight) ?? 0.0,
                rawCurrentWeight: Float(currentWeight) ?? 0.0,
                memo: memo,
                profileImage: nil,
                now: Date()
            )

            guard updateTrainee.validate() else {
                errorAlert.validationError("入力が正しくありません")
                return
            }
            
            store.updateTrainee(trainee: updateTrainee) { error in
                callback(error)
            }
        }
    }
}

struct TraineeEdit_Previews: PreviewProvider {
    static var previews: some View {
        TraineeEdit(trainee: TraineeModel.preview())
            .environmentObject(PartialSheetManager())
            .environmentObject(GlobalStore())
    }
}
