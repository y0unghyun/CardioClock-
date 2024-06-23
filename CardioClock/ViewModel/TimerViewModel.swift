//
//  TimerViewModel.swift
//  Coach
//
//  Created by 영현 on 6/20/24.
//

import Foundation
import AVFoundation

class TimerViewModel {
    var audioPlayer = AVAudioPlayer()
    var timer = Timer()
    
    var exerciseTime: Int = 0
    var breakTime: Int = 0
    var reps: Int = 0
    var repsChecker = 1
    var timerState: TimerState = .Prepare {
        didSet {
            stateChanged?(timerState)
        }
    }
    
    var stateChanged: ((TimerState) -> Void)?
    var timerTick: ((String) -> Void)?
    var playSound: ((String) -> Void)?
    var finishRepetition: (() -> Void)?
    
    func startTimer(for state: TimerState, duration: Int) {
        let startTime = Date()
        self.timerTick?("\(String(format: "%02d", duration / 60)) : \(String(format: "%02d", duration % 60))")
        timer.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            let elapsedTime = Int(Date().timeIntervalSince(startTime))
            let remainTime = duration - elapsedTime
            
            if remainTime > 0 {
                let remainMin = remainTime / 60
                let remainSec = remainTime % 60
                
                if remainTime <= 3 && remainTime >= 1 {
                    DispatchQueue.global(qos: .userInteractive).async {
                        self.playSound?("CoachReadySound")
                    }
                }
                DispatchQueue.main.async {
                    self.timerTick?("\(String(format: "%02d", remainMin)) : \(String(format: "%02d", remainSec))")
                }
            } else {
                timer.invalidate()
                self.handleStateTransition()
            }
        }
    }
    
    private func handleStateTransition() {
        switch timerState {
        case .Prepare:
            timerState = .Exersize
        case .Exersize:
            if repsChecker < reps {
                repsChecker += 1
                timerState = .Break
            } else {
                timerState = .Finished
            }
        case .Break:
            timerState = .Exersize
        case .Finished:
            finishRepetition?()
        }
    }
    
    func playSound(for soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Failed to find sound file.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch let error {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
}
