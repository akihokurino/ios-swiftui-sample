//
//  Selection.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/05.
//

import Foundation

struct SelectionMaster {
    static var gender: [PickerItem] {
        return [
            PickerItem(label: "男性", value: "男性"),
            PickerItem(label: "女性", value: "女性")
        ]
    }

    static var targetWeight: [PickerItem] {
        return [
            PickerItem(label: "60.0kg", value: "60.0kg"),
            PickerItem(label: "70.0kg", value: "70.0kg")
        ]
    }

    static var currentHeight: [PickerItem] {
        return [
            PickerItem(label: "170.0cm", value: "170.0cm"),
            PickerItem(label: "180.0cm", value: "180.0cm")
        ]
    }

    static var currentWeight: [PickerItem] {
        return [
            PickerItem(label: "60.0kg", value: "60.0kg"),
            PickerItem(label: "70.0kg", value: "70.0kg")
        ]
    }
}
