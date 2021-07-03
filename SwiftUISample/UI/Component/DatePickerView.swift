//
//  DatePickerView.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/28.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectDate: Date
    
    let onClose: (() -> Void)

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    onClose()
                }) {
                    Text("閉じる")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                }
            }
            .frame(height: 40)

            DatePicker("", selection: $selectDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .frame(width: 300)
                .labelsHidden()
        }
        .background(Color.white)
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(selectDate: .constant(Date())) {}
    }
}
