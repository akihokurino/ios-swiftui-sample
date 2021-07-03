//
//  DatePickerInput.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/29.
//

import PartialSheet
import SwiftUI

struct DatePickerInput: View {
    @EnvironmentObject private var partialSheetManager: PartialSheetManager
    
    @Binding var selectDate: Date
    
    let label: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(Color.gray)
                .fontWeight(.bold)
                .font(.body)
                .padding(.bottom, 10)
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                partialSheetManager.showPartialSheet(content: {
                    DatePickerView(
                        selectDate: $selectDate
                    ) {
                        partialSheetManager.closePartialSheet()
                    }
                    .frame(height: 220)
                })
            }) {
                Text(DateUtil.stringFromDate(date: selectDate, format: "yyyy/MM/dd"))
                    .foregroundColor(Color.black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 5)
            .frame(height: 35)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct DatePickerInput_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerInput(selectDate: .constant(Date()), label: "生年月日").environmentObject(PartialSheetManager())
    }
}
