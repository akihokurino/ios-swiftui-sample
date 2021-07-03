//
//  TraineeList.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/17.
//

import PartialSheet
import SwiftUI

struct TraineeList: View {
    @EnvironmentObject private var store: GlobalStore
    @EnvironmentObject private var partialSheetManager: PartialSheetManager

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var proceedTraineeRegistrationFlow = false

    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(
                    destination: TraineeRegisteration()
                        .environmentObject(partialSheetManager)
                        .environmentObject(store),
                    isActive: $proceedTraineeRegistrationFlow
                ) {
                    EmptyView()
                }
                .isDetailLink(false)

                LazyVStack(spacing: 15) {
                    ForEach(store.traineeList) { trainee in
                        NavigationLink(destination: TraineeDetail(trainee: trainee)
                            .environmentObject(partialSheetManager)
                            .environmentObject(store)) {
                            TraineeItem(trainee: trainee)
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)
            }
            .navigationBarTitle("トレーニー", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    proceedTraineeRegistrationFlow = true
                }) {
                    Text("新規")
                        .foregroundColor(Color.blue)
                        .fontWeight(.bold)
                }
            )
            .alert(isPresented: $errorAlert.isShowAlert) {
                Alert(title: Text(errorAlert.message))
            }
        }
        .environment(\.rootPresentationMode, $proceedTraineeRegistrationFlow)
    }
}

struct TraineeList_Previews: PreviewProvider {
    static var previews: some View {
        TraineeList().environmentObject(GlobalStore())
    }
}

struct TraineeItem: View {
    let trainee: TraineeModel

    var body: some View {
        HStack {
            Group {
                if trainee.profileImage != nil {
                    URLImageView(id: trainee.id, url: trainee.profileImage)
                        .frame(width: 80, height: 80, alignment: .center)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 60, alignment: .center)
                }
            }
            .frame(width: 80, height: 80)

            VStack(alignment: .leading) {
                Text(trainee.name)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .font(Font.system(size: 15.0))
                    .padding(.horizontal, 15)

                Text(trainee.gender.rawValue)
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
    }
}

struct TraineeItem_Previews: PreviewProvider {
    static var previews: some View {
        TraineeItem(trainee: TraineeModel.preview())
            .frame(width: 320, height: 200)
    }
}
