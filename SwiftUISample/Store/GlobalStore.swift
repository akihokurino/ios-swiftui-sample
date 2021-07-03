//
//  GlobalStore.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/03.
//

import Combine
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

enum AuthState {
    case unknown
    case notLogin
    case alreadyLogin
}

final class GlobalStore: ObservableObject {
    @Published var traineeList: [TraineeModel] = []
    @Published var workoutMenuList: [WorkoutMenuModel] = []
    @Published var workoutHistoryList: [WorkoutModel] = []
    @Published var authState: AuthState = .unknown

    private var defaultWorkoutMenuList: [WorkoutMenuModel] = []
    private var defaultMyWorkoutMenuList: [WorkoutMenuModel] = []

    private let db = Firestore.firestore()
    private let traineeTableName = "trainees"
    private let workoutTableName = "workouts"
    private let workoutMenuTableName = "workoutMenus"
    private let trainerTableName = "trainers"
}

extension GlobalStore {
    func initialize(completion: @escaping (AppError?) -> Void) {
        guard let me = Auth.auth().currentUser else {
            authState = .notLogin
            completion(nil)
            return
        }

        authState = .alreadyLogin

        db.collection(traineeTableName)
            .whereField("trainerId", isEqualTo: me.uid)
            .order(by: "updatedAt", descending: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(AppError.from(error))
                    return
                }

                var items: [TraineeModel] = []
                for document in querySnapshot!.documents {
                    if !document.exists {
                        continue
                    }
                    guard let decorded = try? Firestore.Decoder().decode(TraineeData.self, from: document.data()) else {
                        continue
                    }

                    items.append(decorded.model())
                }

                self.traineeList = items

                completion(nil)
            }
    }

    func signUp(email: String, password: String, completion: @escaping (AppError?) -> Void) {
        guard Auth.auth().currentUser == nil else {
            completion(AppError.unknown)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(AppError.from(error))
                return
            }

            self.authState = .alreadyLogin
            self.initialize(completion: completion)
        }
    }

    func signIn(email: String, password: String, completion: @escaping (AppError?) -> Void) {
        guard Auth.auth().currentUser == nil else {
            completion(AppError.unknown)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(AppError.from(error))
                return
            }

            self.authState = .alreadyLogin
            self.initialize(completion: completion)
        }
    }

    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (AppError?) -> Void) {
        guard let me = Auth.auth().currentUser else {
            completion(AppError.needLogin)
            return
        }

        let cred = EmailAuthProvider.credential(withEmail: me.email ?? "", password: currentPassword)
        me.reauthenticate(with: cred) { authResult, error in
            if let error = error {
                completion(AppError.from(error))
                return
            }

            guard let me = authResult?.user else {
                completion(AppError.unknown)
                return
            }

            me.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion(AppError.from(error))
                    return
                }

                completion(nil)
            }
        }
    }

    func updateEmail(currentPassword: String, newEmail: String, completion: @escaping (AppError?) -> Void) {
        guard let me = Auth.auth().currentUser else {
            completion(AppError.needLogin)
            return
        }

        let cred = EmailAuthProvider.credential(withEmail: me.email ?? "", password: currentPassword)
        me.reauthenticate(with: cred) { authResult, error in
            if let error = error {
                completion(AppError.from(error))
                return
            }

            guard let me = authResult?.user else {
                completion(AppError.unknown)
                return
            }

            me.updateEmail(to: newEmail) { error in
                if let error = error {
                    completion(AppError.from(error))
                    return
                }

                completion(nil)
            }
        }
    }

    func logout(completion: @escaping (AppError?) -> Void) {
        guard Auth.auth().currentUser != nil else {
            completion(AppError.unknown)
            return
        }

        do {
            try Auth.auth().signOut()
            authState = .notLogin
            traineeList = []
            workoutMenuList = []
            workoutHistoryList = []
            completion(nil)
        } catch {
            completion(AppError.from(error))
        }
    }
}

extension GlobalStore {
    func addTrainee(trainee: TraineeModel, completion: @escaping (AppError?) -> Void) {
        guard let me = Auth.auth().currentUser else {
            completion(AppError.needLogin)
            return
        }

        let encoded: [String: Any] = try! Firestore.Encoder().encode(trainee.data(meID: me.uid))

        db.collection(traineeTableName).document(trainee.id).setData(encoded) { error in
            if let error = error {
                completion(AppError.from(error))
                return
            }

            self.traineeList.insert(trainee, at: 0)
            completion(nil)
        }
    }

    func updateTrainee(trainee: TraineeModel, completion: @escaping (AppError?) -> Void) {
        guard let me = Auth.auth().currentUser else {
            completion(AppError.needLogin)
            return
        }

        let encoded: [String: Any] = try! Firestore.Encoder().encode(trainee.data(meID: me.uid))

        db.collection(traineeTableName).document(trainee.id).setData(encoded) { error in
            if let error = error {
                completion(AppError.from(error))
                return
            }

            if let index = self.traineeList.firstIndex(where: { $0.id == trainee.id }) {
                self.traineeList[index] = trainee
            }
            completion(nil)
        }
    }
}

extension GlobalStore {
    func fetchWorkoutMenu(completion: @escaping (AppError?) -> Void) {
        db.collection(workoutMenuTableName)
            .order(by: "id", descending: false)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(AppError.from(error))
                    return
                }

                var items: [WorkoutMenuModel] = []
                for document in querySnapshot!.documents {
                    if !document.exists {
                        continue
                    }
                    guard let decorded = try? Firestore.Decoder().decode(WorkoutMenuData.self, from: document.data()) else {
                        continue
                    }

                    items.append(decorded.model())
                }

                self.defaultWorkoutMenuList = items
                self.workoutMenuList = self.defaultMyWorkoutMenuList + self.defaultWorkoutMenuList

                completion(nil)
            }
    }

    func fetchMyWorkoutMenu(completion: @escaping (AppError?) -> Void) {
        guard let me = Auth.auth().currentUser else {
            completion(AppError.needLogin)
            return
        }

        db.collection(trainerTableName)
            .document(me.uid)
            .collection(workoutMenuTableName)
            .order(by: "id", descending: false)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(AppError.from(error))
                    return
                }

                var items: [WorkoutMenuModel] = []
                for document in querySnapshot!.documents {
                    if !document.exists {
                        continue
                    }
                    guard let decorded = try? Firestore.Decoder().decode(WorkoutMenuData.self, from: document.data()) else {
                        continue
                    }

                    items.append(decorded.model())
                }

                self.defaultMyWorkoutMenuList = items
                self.workoutMenuList = self.defaultMyWorkoutMenuList + self.defaultWorkoutMenuList

                completion(nil)
            }
    }

    func addWorkoutMenu(name: String, description: String, completion: @escaping (AppError?) -> Void) {
        guard let me = Auth.auth().currentUser else {
            completion(AppError.needLogin)
            return
        }

        let newMenu = WorkoutMenuModel(id: UUID().uuidString, trainerId: me.uid, name: name, description: description)

        let encoded: [String: Any] = try! Firestore.Encoder().encode(newMenu.data())

        db.collection(trainerTableName)
            .document(me.uid)
            .collection(workoutMenuTableName)
            .document(newMenu.id)
            .setData(encoded) { error in
                if let error = error {
                    completion(AppError.from(error))
                    return
                }

                self.defaultMyWorkoutMenuList.insert(newMenu, at: 0)
                self.workoutMenuList = self.defaultMyWorkoutMenuList + self.defaultWorkoutMenuList

                completion(nil)
            }
    }

    func search(keyword: String) {
        if keyword.isEmpty {
            workoutMenuList = defaultMyWorkoutMenuList + defaultWorkoutMenuList
        } else {
            workoutMenuList = defaultMyWorkoutMenuList.filter { $0.name.contains(keyword) } + defaultWorkoutMenuList.filter { $0.name.contains(keyword) }
        }
    }
}

extension GlobalStore {
    func fetchHistory(trainee: TraineeModel, completion: @escaping (AppError?) -> Void) {
        guard Auth.auth().currentUser != nil else {
            completion(AppError.needLogin)
            return
        }

        workoutHistoryList = []

        db.collection(traineeTableName)
            .document(trainee.id)
            .collection(workoutTableName)
            .order(by: "startedAt", descending: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(AppError.from(error))
                    return
                }

                var items: [WorkoutModel] = []
                for document in querySnapshot!.documents {
                    if !document.exists {
                        continue
                    }
                    guard let decorded = try? Firestore.Decoder().decode(WorkoutData.self, from: document.data()) else {
                        continue
                    }

                    items.append(decorded.model())
                }

                self.workoutHistoryList = items
                completion(nil)
            }
    }

    func addHistory(workout: WorkoutModel, completion: @escaping (AppError?) -> Void) {
        guard Auth.auth().currentUser != nil else {
            completion(AppError.needLogin)
            return
        }

        let encoded: [String: Any] = try! Firestore.Encoder().encode(workout.data())

        db.collection(traineeTableName)
            .document(workout.traineeId)
            .collection(workoutTableName)
            .document(workout.id)
            .setData(encoded) { error in
                if let error = error {
                    completion(AppError.from(error))
                    return
                }

                self.workoutHistoryList.insert(workout, at: 0)
                completion(nil)
            }
    }
}
