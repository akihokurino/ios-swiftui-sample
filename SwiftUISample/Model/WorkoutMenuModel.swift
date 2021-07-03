//
//  WorkoutMenuModel.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/03.
//

import SwiftUI

struct WorkoutMenuModel: Hashable, Identifiable {
    let id: String
    let trainerId: String?
    let name: String
    let description: String
    
    func data() -> WorkoutMenuData {
        return WorkoutMenuData(id: id, trainerId: trainerId, name: name, description: description)
    }
}

extension WorkoutMenuModel {
    static func preview() -> WorkoutMenuModel {
        return WorkoutMenuModel(
            id: "1",
            trainerId: "",
            name: "メニュー",
            description: "説明文")
    }
}

struct WorkoutMenuData: Codable {
    let id: String
    let trainerId: String?
    let name: String
    let description: String
    
    func model() -> WorkoutMenuModel {
        return WorkoutMenuModel(id: id, trainerId: trainerId, name: name, description: description)
    }
}
