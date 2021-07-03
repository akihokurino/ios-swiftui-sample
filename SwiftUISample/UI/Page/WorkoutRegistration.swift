//
//  WorkoutStart.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/03.
//

import Combine
import SwiftUI

struct WorkoutRegistration: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var store: GlobalStore

    @ObservedObject var errorAlert = ErrorAlert()

    @State private var isLoading: Bool = false
    @State private var isShowSelectModal: Bool = false
    @State private var inputList: [WorkoutInputItemViewModel] = []

    let trainee: TraineeModel
    let workout: WorkoutModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(inputList.indices, id: \.self) { index in
                    WorkoutInputItem(vm: inputList[index], orderIndex: index, onDelete: { menu in
                        if let index = inputList.firstIndex(where: { $0.menu.id == menu.id }) {
                            inputList.remove(at: index)
                        }
                    })
                }
                .padding(.bottom, 20)
                
                if !inputList.isEmpty {
                    ActionButton(text: "+セットを追加", background: .primary) {
                        inputList.append(inputList.last!.copy())
                    }
                    .padding(.top, 20)
                }
                
                ActionButton(text: "エクササイズを追加する", background: .primary) {
                    isShowSelectModal = true
                }
                .padding(.top, 20)
                .padding(.bottom, 20)

                ActionButton(text: "セッションを終了する", background: .primary) {
                    registration()
                }
                .padding(.bottom, 20)

                ActionButton(text: "セッションをキャンセルする", background: .caution) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .navigationBarTitle("\(trainee.name) \(DateUtil.stringFromDate(date: Date(), format: "yyyy-MM-dd"))", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowSelectModal) {
            WorkoutMenuSelect { menu in
                if let menu = menu {
                    inputList.append(WorkoutInputItemViewModel(menu: menu))
                }
                isShowSelectModal = false
            }.environmentObject(store)
        }
        .overlay(Group {
            if isLoading {
                HUD(isLoading: $isLoading)
            }
        }, alignment: .center)
        .alert(isPresented: $errorAlert.isShowAlert) {
            Alert(title: Text(errorAlert.message))
        }
    }

    private func registration() {
        let newWorkout = workout.end(
            executedList: inputList.map {
                ExecutedWorkoutMenuModel(
                    id: UUID().uuidString,
                    menuId: $0.menu.id,
                    menuName: $0.menu.name,
                    kg: Int($0.kg) ?? 0,
                    numberOfTimes: Int($0.numberOfTimes) ?? 0)
            },
            now: Date())

        guard newWorkout.validate() else {
            // TODO: Alertを出すと複数回開かれているようで何回かボタンを押さないと閉じれないようになる
            return
        }

        isLoading = true

        store.addHistory(workout: newWorkout) { error in
            self.errorAlert.appError(error)
            self.isLoading = false

            guard error == nil else {
                return
            }

            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct WorkoutRegistration_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRegistration(trainee: TraineeModel.preview(), workout: WorkoutModel.preview())
            .environmentObject(GlobalStore())
    }
}

class WorkoutInputItemViewModel: ObservableObject {
    @Published var kg: String = ""
    @Published var numberOfTimes: String = "1"

    let menu: WorkoutMenuModel

    init(menu: WorkoutMenuModel) {
        self.menu = menu
    }
    
    func copy() -> WorkoutInputItemViewModel {
        return WorkoutInputItemViewModel(menu: self.menu)
    }
}

struct WorkoutInputItem: View {
    @ObservedObject var vm: WorkoutInputItemViewModel

    let orderIndex: Int
    let onDelete: (WorkoutMenuModel) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(orderIndex + 1)")
                    .font(Font.system(size: 14.0))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding(.top, 5)
                    .frame(height: 40, alignment: .leading)
            }
            .frame(width: 10, height: 30, alignment: .leading)
            .padding(.leading, 5)
            .padding(.trailing, 15)

            VStack(alignment: .leading) {
                Text("メニュー")
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .font(Font.system(size: 15.0))
                    .frame(height: 20, alignment: .leading)

                Text(vm.menu.name)
                    .font(Font.system(size: 14.0))
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                    .padding(.top, 5)
                    .frame(height: 40, alignment: .leading)
            }
            .frame(width: 100, alignment: .leading)
            .padding(.trailing, 15)

            VStack(alignment: .leading) {
                Text("kg")
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .font(Font.system(size: 15.0))
                    .frame(height: 20)

                TextField("", text: $vm.kg, onEditingChanged: { _ in

                }, onCommit: {})
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
            }
            .frame(width: 50, alignment: .leading)
            .padding(.trailing, 15)

            VStack(alignment: .leading) {
                Text("回数")
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .font(Font.system(size: 15.0))
                    .frame(height: 20)

                TextField("", text: $vm.numberOfTimes, onEditingChanged: { _ in

                }, onCommit: {})
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
            }
            .frame(width: 50, alignment: .leading)
            .padding(.trailing, 15)
            
            Spacer()

            VStack(alignment: .leading) {
                Button(action: {
                    onDelete(vm.menu)
                }) {
                    Image(systemName: "xmark")
                }
            }
            .frame(width: 30, height: 30, alignment: .leading)
        }
    }
}

struct WorkoutInputItem_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutInputItem(vm: WorkoutInputItemViewModel(menu: WorkoutMenuModel.preview()), orderIndex: 0, onDelete: { menu in })
            .frame(width: 320, height: 200)
    }
}
