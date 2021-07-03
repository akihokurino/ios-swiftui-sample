//
//  TraineeMealManagementHistory.swift
//  SwiftUISample
//
//  Created by akiho on 2021/03/06.
//

import SwiftUI

struct TraineeMealManagementHistory: View {
    static let maxDays = 30
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var store: GlobalStore

    @State private var currentPage = TraineeMealManagementHistory.maxDays
    @State private var currentDate = Date()
    
    let today = Date()
    let trainee: TraineeModel

    private var details: [TraineeMealManagementHistoryDetail] = []

    init(trainee: TraineeModel) {
        self.trainee = trainee
        for i in (0 ... TraineeMealManagementHistory.maxDays).reversed() {
            details.append(TraineeMealManagementHistoryDetail(date: Calendar.current.date(byAdding: .day, value: -i, to: today)!))
        }
    }

    var body: some View {
        VStack {
            PageView(pages: details.map { AnyView($0) }, currentPage: $currentPage)
        }
        .navigationBarTitle("食事履歴", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward").frame(width: 25, height: 25, alignment: .center)
            }
        )
    }
}

struct TraineeMealManagementHistory_Previews: PreviewProvider {
    static var previews: some View {
        TraineeMealManagementHistory(trainee: TraineeModel.preview())
    }
}

struct TraineeMealManagementHistoryDetail: View {
    let date: Date

    var body: some View {
        ScrollView {
            HStack {
                Text(DateUtil.stringFromDate(date: date, format: "yyyy年MM月dd日"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50, alignment: .center)
            }
            .frame(height: 50, alignment: .center)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray),
                alignment: .bottom
            )

            HStack(alignment: .center) {
                Spacer()
                Text("合計")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
                Text("目標")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
                Text("残り")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(Color.gray.opacity(0.3))

            HStack(alignment: .center) {
                Text("炭水化物")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.gray)
                Spacer()
                Text("0")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
                Text("400")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
                Text("400g")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray),
                alignment: .bottom
            )

            HStack(alignment: .center) {
                Text("タンパク質")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.gray)
                Spacer()
                Text("0")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
                Text("200")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
                Text("200g")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray),
                alignment: .bottom
            )

            HStack(alignment: .center) {
                Text("脂質")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.gray)
                Spacer()
                Text("0")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
                Text("40")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
                Text("40g")
                    .font(Font.system(size: 14.0))
                    .foregroundColor(Color.black)
                    .frame(width: 60, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray),
                alignment: .bottom
            )
        }
    }
}

struct TraineeMealManagementHistoryDetail_Previews: PreviewProvider {
    static var previews: some View {
        TraineeMealManagementHistoryDetail(date: Date())
    }
}
