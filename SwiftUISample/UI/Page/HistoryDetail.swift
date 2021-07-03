//
//  HistoryDetail.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/09.
//

import SwiftUI

struct HistoryDetail: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var showShareSheet = false

    let trainee: TraineeModel
    let workout: WorkoutModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("セッション時間")
                        .font(Font.system(size: 14.0))
                        .foregroundColor(Color.gray)
                        .frame(width: 140, alignment: .leading)
                    Text("\(workout.startedAtTimeString) 〜 \(workout.endedAtTimeString)")
                        .font(Font.system(size: 14.0))
                        .foregroundColor(Color.black)
                        .frame(alignment: .leading)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)

                VStack {
                    ForEach(workout.grouping.order.indices, id: \.self) { index in
                        let menuName = workout.grouping.order[index]

                        Text(menuName)
                            .font(Font.system(size: 14.0))
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                            .padding(.vertical, 10)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: .infinity,
                                   alignment: .topLeading)

                        if let data = workout.grouping.data[menuName] {
                            ForEach(data.indices, id: \.self) { index in
                                ExecutedWorkoutItem(orderIndex: index, executedMenu: data[index])
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("\(trainee.name) \(workout.startedAtString)", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
            },
            trailing: Button(action: {
                showShareSheet = true
            }) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 20, height: 25, alignment: .center)
                    .foregroundColor(Color.blue)
            }
        )
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(shareText: workout.shareText)
        }
        .alert(isPresented: $errorAlert.isShowAlert) {
            Alert(title: Text(errorAlert.message))
        }
    }
}

struct HistoryDetail_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetail(trainee: TraineeModel.preview(), workout: WorkoutModel.preview()).environmentObject(GlobalStore())
    }
}

struct ExecutedWorkoutItem: View {
    let orderIndex: Int
    let executedMenu: ExecutedWorkoutMenuModel

    var body: some View {
        HStack {
            Text("\(orderIndex + 1)")
                .font(Font.system(size: 14.0))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .frame(width: 10, height: 30, alignment: .leading)
                .padding(.trailing, 20)

            HStack {
                Text("\(executedMenu.kg)")
                    .font(Font.system(size: 14.0))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .frame(height: 30, alignment: .leading)

                Text("kg")
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .font(Font.system(size: 15.0))
                    .frame(height: 30)

                Text("×")
                    .font(Font.system(size: 14.0))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .frame(height: 30, alignment: .leading)

                Text("\(executedMenu.numberOfTimes)")
                    .font(Font.system(size: 14.0))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .frame(height: 30, alignment: .leading)
            }
            .frame(alignment: .leading)
            .padding(.trailing, 20)

            Spacer()
        }
    }
}

struct ExecutedWorkoutItem_Previews: PreviewProvider {
    static var previews: some View {
        ExecutedWorkoutItem(orderIndex: 0, executedMenu: ExecutedWorkoutMenuModel.preview()).frame(width: 320, height: 200)
    }
}
