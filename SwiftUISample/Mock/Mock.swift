//
//  Mock.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/05.
//

import SwiftUI

let traineeMock: [TraineeData] = load("TraineeMock.json")
let workoutMenuMock: [WorkoutMenuData] = load("WorkoutMenuMock.json")
let workoutMock: [WorkoutData] = load("WorkoutMock.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
