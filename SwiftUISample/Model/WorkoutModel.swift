//
//  WorkoutModel.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/03.
//

import SwiftUI

typealias GroupedExecutedWorkoutMenuList = (data: [String:[ExecutedWorkoutMenuModel]], order: [String])

struct WorkoutModel: Hashable, Identifiable {
    let id: String
    let traineeId: String
    let executedList: [ExecutedWorkoutMenuModel]
    let startedAt: Date?
    let endedAt: Date?
    
    var startedAtString: String {
        guard let startedAt = self.startedAt else {
            return ""
        }
        return DateUtil.stringFromDate(date: startedAt, format: "yyyy-MM-dd")
    }
    
    var startedAtTimeString: String {
        guard let startedAt = self.startedAt else {
            return ""
        }
        return DateUtil.stringFromDate(date: startedAt, format: "HH:mm")
    }
        
    var endedAtTimeString: String {
        guard let endedAt = self.endedAt else {
            return ""
        }
        return DateUtil.stringFromDate(date: endedAt, format: "HH:mm")
    }
    
    func validate() -> Bool {
        guard !id.isEmpty && !traineeId.isEmpty && !executedList.isEmpty && startedAt != nil && endedAt != nil else {
            return false
        }
        
        guard executedList.filter({ !$0.validate() }).isEmpty else {
            return false
        }
        
        return true
    }
    
    static func start(trainee: TraineeModel, now: Date) -> WorkoutModel {
        return WorkoutModel(id: UUID().uuidString, traineeId: trainee.id, executedList: [], startedAt: now, endedAt: nil)
    }
    
    func end(executedList: [ExecutedWorkoutMenuModel], now: Date) -> WorkoutModel {
        return WorkoutModel(id: id, traineeId: traineeId, executedList: executedList, startedAt: startedAt, endedAt: now)
    }
    
    func data() -> WorkoutData {
        return WorkoutData(
            id: id,
            traineeId: traineeId,
            executedList: executedList.map { $0.data() },
            startedAt: Int(startedAt?.timeIntervalSince1970 ?? 0),
            endedAt: Int(endedAt?.timeIntervalSince1970 ?? 0))
    }
    
    var grouping: GroupedExecutedWorkoutMenuList {
        var data: [String:[ExecutedWorkoutMenuModel]] = [:]
        var order: [String] = []
        
        executedList.forEach { executed in
            let key = executed.menuName
            if let current = data[key] {
                data[key] = current + [executed]
            } else {
                data[key] = [executed]
                order.append(key)
            }
        }
        
        return GroupedExecutedWorkoutMenuList(data: data, order: order)
    }
    
    var shareText: String {        
        var detailTexts: [String] = []
        grouping.order.enumerated().forEach {
            let menuName = grouping.order[$0.offset]
            let menuTexts = grouping.data[menuName]!.enumerated().map { "\($0.offset + 1) \($0.element.kg)kg × \($0.element.numberOfTimes)" }
            detailTexts.append("\(menuName)\n\(menuTexts.joined(separator: "\n"))")
        }
        
        return """
        セッション時間: \(startedAtTimeString) 〜 \(endedAtTimeString)

        \(detailTexts.joined(separator: "\n\n"))
        """
    }
}

extension WorkoutModel {
    static func preview() -> WorkoutModel {
        return WorkoutModel(
            id: "1",
            traineeId: "1",
            executedList: [
                ExecutedWorkoutMenuModel.preview(),
                ExecutedWorkoutMenuModel.preview(),
                ExecutedWorkoutMenuModel.preview()
            ],
            startedAt: Date(),
            endedAt: Date())
    }
}

struct ExecutedWorkoutMenuModel: Hashable, Identifiable {
    let id: String
    let menuId: String
    let menuName: String
    let kg: Int
    let numberOfTimes: Int
    
    func validate() -> Bool {
        guard !id.isEmpty && !menuId.isEmpty && !menuName.isEmpty && numberOfTimes > 0 else {
            return false
        }
        return true
    }
    
    func data() -> ExecutedWorkoutMenuData {
        return ExecutedWorkoutMenuData(
            id: id,
            menuId: menuId,
            menuName: menuName,
            kg: kg,
            numberOfTimes: numberOfTimes)
    }
}

extension ExecutedWorkoutMenuModel {
    static func preview() -> ExecutedWorkoutMenuModel {
        return ExecutedWorkoutMenuModel(
            id: "1",
            menuId: "1",
            menuName: "メニュー名",
            kg: 100,
            numberOfTimes: 3)
    }
}

struct WorkoutData: Codable {
    let id: String
    let traineeId: String
    let executedList: [ExecutedWorkoutMenuData]
    let startedAt: Int
    let endedAt: Int
    
    func model() -> WorkoutModel {
        return WorkoutModel(
            id: id,
            traineeId: traineeId,
            executedList: executedList.map { $0.model() },
            startedAt: Date(timeIntervalSince1970: Double(startedAt)),
            endedAt: Date(timeIntervalSince1970: Double(endedAt)))
    }
}

struct ExecutedWorkoutMenuData: Codable {
    let id: String
    let menuId: String
    let menuName: String
    let kg: Int
    let numberOfTimes: Int
    
    func model() -> ExecutedWorkoutMenuModel {
        return ExecutedWorkoutMenuModel(
            id: id,
            menuId: menuId,
            menuName: menuName,
            kg: kg,
            numberOfTimes: numberOfTimes)
    }
}
