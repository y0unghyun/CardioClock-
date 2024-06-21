//
//  ExecuteViewController.swift
//  Coach
//
//  Created by 영현 on 6/18/24.
//

import UIKit
import SnapKit

class TimerViewController: UIViewController {
    
    var viewModel = TimerViewModel()
    
    var stateLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 64)
        label.textColor = .black
        return label
    }()
    
    var timerLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: Parameters.timerFont!)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CoachStopButtonImage"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let routine = RoutineManager.shared.sharedRoutine else {
            showAlert()
            return
        }
        
        viewModel.exerciseTime = routine.exerciseTime
        viewModel.breakTime = routine.breakTime
        viewModel.reps = routine.repetition
        
        setupView()
        setupBindings()
        
        viewModel.timerState = .Prepare
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(stateLabel)
        view.addSubview(timerLabel)
        view.addSubview(stopButton)
        
        stopButton.addTarget(self, action: #selector(didStopButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupBindings() {
        viewModel.stateChanged = { [weak self] state in
            guard let self = self else { return }
            self.stateLabel.text = state.rawValue
            
            switch state {
            case .Prepare:
                self.viewModel.startTimer(for: state, duration: 5)
            case .Exersize:
                self.viewModel.startTimer(for: state, duration: self.viewModel.exerciseTime)
                self.viewModel.playSound(for: "CoachStartExerciseSound")
            case .Break:
                self.viewModel.startTimer(for: state, duration: self.viewModel.breakTime)
                self.viewModel.playSound(for: "CoachStartBreaktimeSound")
            case .Finished:
                self.viewModel.finishRepetition?()
            }
        }
        
        viewModel.timerTick = { [weak self] timeString in
            self?.timerLabel.text = timeString
        }
        
        viewModel.playSound = { [weak self] soundName in
            self?.viewModel.playSound(for: soundName)
        }
        
        viewModel.finishRepetition = { [weak self] in
            self?.finishRepetition()
        }
    }
    
    private func setupConstraints() {
        if let deviceWidth = Parameters.deviceWidth, let deviceHeight = Parameters.deviceHeight {
            stateLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(deviceHeight * 0.05)
            }
            timerLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            stopButton.snp.makeConstraints {
                $0.width.height.equalTo(deviceWidth * 0.3)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(timerLabel.snp.bottom).offset(deviceHeight * 0.2)
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "🚨Caution🚨",
                                      message: "Wrong or empty input!\nCheck your input again.",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "Back", style: .destructive)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func finishRepetition() {
        viewModel.playSound(for: "CoachCompleteSound")
        timerLabel.text = "Congrats!\n"
        stopButton.isHidden = true
        viewModel.timer.invalidate()
    }
    
    @objc private func didStopButtonTapped() {
        stateLabel.text = "🛑STOP🛑"
        viewModel.timer.invalidate()
        timerLabel.text = "Stop Timer"
        stopButton.isHidden = true
    }
}
