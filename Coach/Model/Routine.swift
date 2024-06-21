//
//  Routine.swift
//  Coach
//
//  Created by 영현 on 6/18/24.
//

import Foundation

struct Routine: Codable {
    var exerciseTime: Int
    var breakTime: Int
    var repetition: Int
}

class RoutineManager {
    static let shared = RoutineManager()
    var sharedRoutine: Routine?
}
