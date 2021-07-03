//
//  PickerInput.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/29.
//

import PartialSheet
import SwiftUI

struct PickerInput: View {
    @EnvironmentObject private var partialSheetManager: PartialSheetManager
    
    @Binding var selectIndex: Int
    
    let label: String
    let selection: [PickerItem]

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
                    PickerView(
                        selectIndex: $selectIndex,
                        selection: selection
                    ) {
                        partialSheetManager.closePartialSheet()
                    }
                    .frame(height: 220)
                })
            }) {
                Text(selection[selectIndex].label)
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

struct PickerInput_Previews: PreviewProvider {
    static var previews: some View {
        PickerInput(selectIndex: .constant(0), label: "性別", selection: [
            PickerItem(label: "男性", value: "1"),
            PickerItem(label: "女性", value: "2")
        ]).environmentObject(PartialSheetManager())
    }
}
