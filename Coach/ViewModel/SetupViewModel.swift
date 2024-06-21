//
//  SetupViewModel.swift
//  Coach
//
//  Created by 영현 on 6/13/24.
//

//import UIKit
import SnapKit

class SetupViewModel {
    let minutes = Array(0...59).map{"\($0)"}
    let seconds = Array(0...59).map{"\($0)"}
    let repetition = Array(1...20).map{"\($0)"}
    
    var exerciseMinutes = "0"
    var exerciseSeconds = "0"
    var breaktimeMinutes = "0"
    var breaktimeSeconds = "0"
    var repetitionTimes = "1"
    
    var exerciseTime: Int {
        return Int(exerciseMinutes)! * 60 + Int(exerciseSeconds)!
    }
    
    var breakTime: Int {
        return Int(breaktimeMinutes)! * 60 + Int(breaktimeSeconds)!
    }
    
    var reps: Int {
        return Int(repetitionTimes)!
    }
    
    func isValidInput() -> Bool {
        return exerciseTime != 0 && breakTime != 0 && reps != 0
    }
}
