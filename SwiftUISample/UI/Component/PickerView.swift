//
//  PickerView.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/28.
//

import SwiftUI

struct PickerItem: Hashable {
    let label: String
    let value: String
}

struct PickerView: View {
    @Binding var selectIndex: Int
    
    let selection: [PickerItem]
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
            
            Picker(selection: $selectIndex, label: Text("")) {
                ForEach(selection.indices, id: \.self) { index in
                    Text(selection[index].label).tag(index)
                }
            }
            .frame(width: 300)
            .labelsHidden()
        }
        .background(Color.white)
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(selectIndex: .constant(1), selection: []) {}
    }
}
