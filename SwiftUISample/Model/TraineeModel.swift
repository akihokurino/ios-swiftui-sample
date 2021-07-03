//
//  TraineeModel.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/03.
//

import SwiftUI

enum Gender: String {
    case male = "男性"
    case female = "女性"
}

struct TraineeModel: Hashable, Identifiable {
    let id: String
    let name: String
    let gender: Gender
    let birthdate: Date
    let phoneNumber: String
    let exerciseHistory: String
    let exerciseGoal: String
    let targetWeight: Float
    let currentHeight: Float
    let currentWeight: Float
    let memo: String
    let profileImage: URL?
    let carbohydrateAmount: Int?
    let proteinAmount: Int?
    let lipidAmount: Int?
    let createdAt: Date
    let updatedAt: Date
    
    var birthdateString: String {
        return DateUtil.stringFromDate(date: birthdate, format: "yyyy-MM-dd")
    }
    
    var totalCalorie: Int? {
        guard let carbohydrateAmount = self.carbohydrateAmount, let lipidAmount = self.lipidAmount, let proteinAmount = self.proteinAmount else {
            return nil
        }
        
        return carbohydrateAmount * 4 + lipidAmount * 9 + proteinAmount * 4
    }
    
    var carbohydrateRatio: Float? {
        guard let totalCalorie = self.totalCalorie else {
            return nil
        }
        
        guard totalCalorie > 0 else {
            return nil
        }
        
        return ceil((Float(carbohydrateAmount! * 4) / Float(totalCalorie)) * 100)
    }
    
    var proteinRatio: Float? {
        guard let totalCalorie = self.totalCalorie else {
            return nil
        }
        
        guard totalCalorie > 0 else {
            return nil
        }
        
        return ceil((Float(proteinAmount! * 4) / Float(totalCalorie)) * 100)
    }
    
    var lipidRatio: Float? {
        guard let carbohydrateRatio = self.carbohydrateRatio, let proteinRatio = self.proteinRatio else {
            return nil
        }
    
        return 100.0 - carbohydrateRatio - proteinRatio
    }
    
    static func newID() -> String {
        return UUID().uuidString
    }
    
    static func new(
        id: String,
        name: String,
        gender: Gender,
        birthdate: Date,
        phoneNumber: String,
        exerciseHistory: String,
        exerciseGoal: String,
        rawTargetWeight: Float,
        rawCurrentHeight: Float,
        rawCurrentWeight: Float,
        memo: String,
        profileImage: URL?,
        now: Date) -> TraineeModel
    {
        return TraineeModel(
            id: id,
            name: name,
            gender: gender,
            birthdate: birthdate,
            phoneNumber: phoneNumber,
            exerciseHistory: exerciseHistory,
            exerciseGoal: exerciseGoal,
            targetWeight: floor(rawTargetWeight*10)/10,
            currentHeight: floor(rawCurrentHeight*10)/10,
            currentWeight: floor(rawCurrentWeight*10)/10,
            memo: memo,
            profileImage: profileImage,
            carbohydrateAmount: nil,
            proteinAmount: nil,
            lipidAmount: nil,
            createdAt: now,
            updatedAt: now)
    }
    
    func validate() -> Bool {
        guard !id.isEmpty, !name.isEmpty, !phoneNumber.isEmpty else {
            return false
        }
        return true
    }
    
    func update(
        name: String,
        gender: Gender,
        birthdate: Date,
        phoneNumber: String,
        exerciseHistory: String,
        exerciseGoal: String,
        rawTargetWeight: Float,
        rawCurrentHeight: Float,
        rawCurrentWeight: Float,
        memo: String,
        profileImage: URL?,
        now: Date) -> TraineeModel
    {
        return TraineeModel(
            id: id,
            name: name,
            gender: gender,
            birthdate: birthdate,
            phoneNumber: phoneNumber,
            exerciseHistory: exerciseHistory,
            exerciseGoal: exerciseGoal,
            targetWeight: floor(rawTargetWeight*10)/10,
            currentHeight: floor(rawCurrentHeight*10)/10,
            currentWeight: floor(rawCurrentWeight*10)/10,
            memo: memo,
            profileImage: profileImage != nil ? profileImage : self.profileImage,
            carbohydrateAmount: carbohydrateAmount,
            proteinAmount: proteinAmount,
            lipidAmount: lipidAmount,
            createdAt: createdAt,
            updatedAt: now)
    }
    
    func setMealManagement(
        carbohydrateAmount: Int,
        proteinAmount: Int,
        lipidAmount: Int,
        now: Date) -> TraineeModel
    {
        return TraineeModel(
            id: id,
            name: name,
            gender: gender,
            birthdate: birthdate,
            phoneNumber: phoneNumber,
            exerciseHistory: exerciseHistory,
            exerciseGoal: exerciseGoal,
            targetWeight: targetWeight,
            currentHeight: currentHeight,
            currentWeight: currentWeight,
            memo: memo,
            profileImage: profileImage,
            carbohydrateAmount: carbohydrateAmount,
            proteinAmount: proteinAmount,
            lipidAmount: lipidAmount,
            createdAt: createdAt,
            updatedAt: now)
    }
    
    func data(meID: String) -> TraineeData {
        return TraineeData(
            id: id,
            trainerId: meID,
            name: name,
            gender: gender.rawValue,
            birthdate: DateUtil.stringFromDate(date: birthdate, format: "yyyy-MM-dd"),
            phoneNumber: phoneNumber,
            exerciseHistory: exerciseHistory,
            exerciseGoal: exerciseGoal,
            targetWeight: targetWeight,
            currentHeight: currentHeight,
            currentWeight: currentWeight,
            memo: memo,
            profileImageURL: profileImage?.absoluteString ?? "",
            carbohydrateAmount: carbohydrateAmount,
            proteinAmount: proteinAmount,
            lipidAmount: lipidAmount,
            createdAt: Int(createdAt.timeIntervalSince1970),
            updatedAt: Int(updatedAt.timeIntervalSince1970))
    }
}

extension TraineeModel {
    static func preview() -> TraineeModel {
        return TraineeModel(
            id: "1",
            name: "Aさん",
            gender: .male,
            birthdate: Date(),
            phoneNumber: "08012345678",
            exerciseHistory: "運動歴なし",
            exerciseGoal: "ダイエット",
            targetWeight: 60.0,
            currentHeight: 170.0,
            currentWeight: 70.0,
            memo: "備考情報",
            profileImage: URL(string: "http://placehold.jp/150x150.png"),
            carbohydrateAmount: 400,
            proteinAmount: 200,
            lipidAmount: 40,
            createdAt: Date(),
            updatedAt: Date())
    }
}

struct TraineeData: Codable {
    let id: String
    let trainerId: String
    let name: String
    let gender: String
    let birthdate: String
    let phoneNumber: String
    let exerciseHistory: String
    let exerciseGoal: String
    let targetWeight: Float
    let currentHeight: Float
    let currentWeight: Float
    let memo: String
    let profileImageURL: String
    let carbohydrateAmount: Int?
    let proteinAmount: Int?
    let lipidAmount: Int?
    let createdAt: Int
    let updatedAt: Int

    func model() -> TraineeModel {
        return TraineeModel(
            id: id,
            name: name,
            gender: Gender(rawValue: gender) ?? Gender.male,
            birthdate: DateUtil.dateFromString(string: birthdate, format: "yyyy-MM-dd"),
            phoneNumber: phoneNumber,
            exerciseHistory: exerciseHistory,
            exerciseGoal: exerciseGoal,
            targetWeight: targetWeight,
            currentHeight: currentHeight,
            currentWeight: currentWeight,
            memo: memo,
            profileImage: URL(string: profileImageURL),
            carbohydrateAmount: carbohydrateAmount,
            proteinAmount: proteinAmount,
            lipidAmount: lipidAmount,
            createdAt: Date(timeIntervalSince1970: Double(createdAt)),
            updatedAt: Date(timeIntervalSince1970: Double(updatedAt)))
    }
}
