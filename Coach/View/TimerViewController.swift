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
        let alert = UIAlertController(title: "🚨주의🚨",
                                      message: "루틴이 정상적이지 않습니다! \n 다시 한 번 확인해주세요.",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "뒤로가기", style: .destructive)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func finishRepetition() {
        viewModel.playSound(for: "CoachCompleteSound")
        timerLabel.text = "세트를\n완료했습니다!"
        stopButton.isHidden = true
        viewModel.timer.invalidate()
    }
    
    @objc private func didStopButtonTapped() {
        stateLabel.text = "🛑STOP🛑"
        viewModel.timer.invalidate()
        timerLabel.text = "타이머가\n종료됩니다."
        stopButton.isHidden = true
    }
}
