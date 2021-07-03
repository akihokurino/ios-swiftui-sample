//
//  TraineeDetail.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/17.
//

import PartialSheet
import SwiftUI

struct TraineeDetail: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var partialSheetManager: PartialSheetManager
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var proceedTraineeEditFlow = false
    
    let trainee: TraineeModel

    var body: some View {
        ScrollView {
            NavigationLink(
                destination: TraineeEdit(trainee: trainee)
                    .environmentObject(partialSheetManager)
                    .environmentObject(store),
                isActive: $proceedTraineeEditFlow
            ) {
                EmptyView()
            }
            .isDetailLink(true)
            
            VStack(alignment: .leading) {
                HStack {
                    Group {
                        if trainee.profileImage != nil {
                            URLImageView(id: trainee.id, url: trainee.profileImage)
                                .frame(width: 120, height: 120, alignment: .center)
                        } else {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100, alignment: .center)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .padding(.trailing, 20)

                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("生年月日")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.gray)
                                .frame(width: 70, alignment: .leading)
                            Text(trainee.birthdateString)
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        }
                        .padding(.top, 5)

                        HStack(alignment: .top) {
                            Text("性別")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.gray)
                                .frame(width: 70, alignment: .leading)
                            Text(trainee.gender.rawValue)
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        }
                        .padding(.top, 5)

                        HStack(alignment: .top) {
                            Text("連絡先")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.gray)
                                .frame(width: 70, alignment: .leading)
                            Text(trainee.phoneNumber)
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(.bottom, 40)

                Group {
                    HStack(alignment: .top) {
                        Text("運動歴 / 運動習慣歴")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        Text(trainee.exerciseHistory)
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.black)
                            .frame(alignment: .leading)
                    }
                    .padding(.top, 2)

                    HStack(alignment: .top) {
                        Text("運動目標")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        Text(trainee.exerciseGoal)
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.black)
                            .frame(alignment: .leading)
                    }
                    .padding(.top, 2)

                    HStack(alignment: .top) {
                        Text("目標体重")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        Text("\(NSString(format: "%.1f", trainee.targetWeight))kg")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.black)
                            .frame(alignment: .leading)
                    }
                    .padding(.top, 2)

                    HStack(alignment: .top) {
                        Text("入会時の身長 / 体重")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        Text("\(NSString(format: "%.1f", trainee.currentHeight))cm / \(NSString(format: "%.1f", trainee.currentWeight))kg")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.black)
                            .frame(alignment: .leading)
                    }
                    .padding(.top, 2)

                    HStack(alignment: .top) {
                        Text("メモ")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        Text(trainee.memo)
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.black)
                            .frame(alignment: .leading)
                    }
                    .padding(.top, 2)
                }
                
                Group {
                    HStack(alignment: .top) {
                        Text("カロリー")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        if let totalCalorie = trainee.totalCalorie {
                            Text(String(totalCalorie))
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        } else {
                            Text("未設定")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        }
                    }
                    .padding(.top, 2)
                    
                    HStack(alignment: .top) {
                        Text(String(format: "炭水化物: %.0f%%", trainee.carbohydrateRatio ?? 0.0))
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        if let carbohydrateAmount = trainee.carbohydrateAmount {
                            Text("\(String(carbohydrateAmount))g")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        } else {
                            Text("未設定")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        }
                    }
                    .padding(.top, 2)
                    
                    HStack(alignment: .top) {
                        Text(String(format: "タンパク質: %.0f%%", trainee.proteinRatio ?? 0.0))
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        if let proteinAmount = trainee.proteinAmount {
                            Text("\(String(proteinAmount))g")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        } else {
                            Text("未設定")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        }
                    }
                    .padding(.top, 2)
                    
                    HStack(alignment: .top) {
                        Text(String(format: "脂質: %.0f%%", trainee.lipidRatio ?? 0.0))
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.gray)
                            .frame(width: 140, alignment: .leading)
                        if let lipidAmount = trainee.lipidAmount {
                            Text("\(String(lipidAmount))g")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        } else {
                            Text("未設定")
                                .font(Font.system(size: 14.0))
                                .foregroundColor(Color.black)
                                .frame(alignment: .leading)
                        }
                    }
                    .padding(.top, 2)
                }

                LinkButton(text: "食事管理", isDetailLink: true, isActive: .constant(false)) {
                    TraineeMealManagementEdit(trainee: trainee)
                        .environmentObject(store)
                }
                .padding(.top, 40)
                
                LinkButton(text: "食事履歴", isDetailLink: true, isActive: .constant(false)) {
                    TraineeMealManagementHistory(trainee: trainee)
                        .environmentObject(store)
                }
                .padding(.top, 10)
                
                LinkButton(text: "セッション開始", isDetailLink: true, isActive: .constant(false)) {
                    WorkoutRegistration(trainee: trainee, workout: WorkoutModel.start(trainee: trainee, now: Date()))
                        .environmentObject(store)
                }
                .padding(.top, 40)

                Text("履歴")
                    .fontWeight(.bold)
                    .font(Font.system(size: 20.0))
                    .padding(.top, 40)

                LazyVStack(spacing: 15) {
                    ForEach(store.workoutHistoryList) { workout in
                        NavigationLink(destination: HistoryDetail(trainee: trainee, workout: workout).environmentObject(store)) {
                            HistoryItem(workout: workout)
                        }
                    }
                }
                .padding(.horizontal, 0)
                .padding(.top, 5)
            }
            .padding()
        }
        .navigationBarTitle(trainee.name, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
            },
            trailing: Button(action: {
                proceedTraineeEditFlow = true
            }) {
                Text("編集")
                    .foregroundColor(Color.blue)
                    .fontWeight(.bold)
            }
        )
        .onAppear(perform: {
            store.fetchHistory(trainee: trainee) { error in
                self.errorAlert.appError(error)
            }
        })
        .alert(isPresented: $errorAlert.isShowAlert) {
            Alert(title: Text(errorAlert.message))
        }
    }
}

struct TraineeDetail_Previews: PreviewProvider {
    static var previews: some View {
        TraineeDetail(trainee: TraineeModel.preview()).environmentObject(GlobalStore())
    }
}

struct HistoryItem: View {
    let workout: WorkoutModel

    var body: some View {
        HStack {
            Text(workout.startedAtString)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .font(Font.system(size: 15.0))

            Spacer()

            Text("\(workout.startedAtTimeString) 〜 \(workout.endedAtTimeString)")
                .font(Font.system(size: 14.0))
                .fontWeight(.bold)
                .foregroundColor(Color.gray)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}

struct HistoryItem_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItem(workout: WorkoutModel.preview())
            .frame(width: 320, height: 200)
    }
}
