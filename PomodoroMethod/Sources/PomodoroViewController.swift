//
//  ViewController.swift
//  PomodoroMethod
//
//  Created by Churkin Vitaly on 22.01.2024.
//

import UIKit

class PomodoroViewController: UIViewController {

    // MARK: - Properties
    private var isWorkTime: Bool = true
    private var isStarted: Bool = false
    private var timer: Timer?
    private var remainingTime: TimeInterval = PomodoroConstants.workTime

    private let playImage = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
    private let pauseImage = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)

    private let circleLayer = CAShapeLayer()

    // Constants
    private enum PomodoroConstants {
        static let mainScreenBounds = UIScreen.main.bounds
        static let screenWidth = mainScreenBounds.width
        static let screenHeight = mainScreenBounds.height
        static let workTime: TimeInterval = 25
        static let breakTime: TimeInterval = 10
        static let initialRunCount: TimeInterval = 0
        static let workTimeColor = UIColor.red
        static let breakTimeColor = UIColor.green
        static let fontSizeMultiplier: CGFloat = 0.20
        static let buttonTopMarginMultiplier: CGFloat = 0.05
        static let buttonWidthMultiplier: CGFloat = 0.15
        static let buttonHeightMultiplier: CGFloat = 0.07
        static let circularPathRadiusMultiplier: CGFloat = 0.45
        static let circleLayerLineWidthMultiplier: CGFloat = 0.015
    }

    // MARK: - UI

    private lazy var animatedCountingLabel: UILabel = {
        let label = UILabel()
        let fontSize = PomodoroConstants.fontSizeMultiplier * PomodoroConstants.screenWidth

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = formatTime(remainingTime)
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.textColor = isWorkTime ? PomodoroConstants.workTimeColor : PomodoroConstants.breakTimeColor

        return label
    }()

    private lazy var buttonPlayPause: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(isStarted ? pauseImage : playImage, for: .normal)
        button.tintColor = isWorkTime ? PomodoroConstants.workTimeColor : PomodoroConstants.breakTimeColor
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        createCircularPath()
    }

    // MARK: - Setups

    private func setupView() {
        view.backgroundColor = .white
    }

    private func setupHierarchy() {
        view.addSubview(animatedCountingLabel)
        view.addSubview(buttonPlayPause)
    }

    private func setupLayout() {
        let topArchorButton = PomodoroConstants.buttonTopMarginMultiplier * PomodoroConstants.screenWidth
        let widthButton = PomodoroConstants.buttonWidthMultiplier * PomodoroConstants.screenWidth
        let heightButton = PomodoroConstants.buttonHeightMultiplier * PomodoroConstants.screenHeight

        NSLayoutConstraint.activate([
            animatedCountingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedCountingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonPlayPause.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonPlayPause.topAnchor.constraint(equalTo: animatedCountingLabel.bottomAnchor, constant: topArchorButton),
            buttonPlayPause.heightAnchor.constraint(equalToConstant: heightButton),
            buttonPlayPause.widthAnchor.constraint(equalToConstant: widthButton)
        ])
    }

    // MARK: - Actions

    @objc func buttonAction() {
        isStarted.toggle()
        buttonPlayPause.setBackgroundImage(isStarted ? pauseImage : playImage, for: .normal)

        if isStarted {
            startTimer()
        } else {
            stopTimer()
        }
    }

    // MARK: - Func

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { [weak self] _ in
            self?.remainingTime -= 0.001
            self?.checkTimer()
            self?.updateColor()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
    }

    private func checkTimer() {
        if remainingTime <= 0 {
            isWorkTime.toggle()
            remainingTime = isWorkTime ? PomodoroConstants.workTime : PomodoroConstants.breakTime
        }

        animatedCountingLabel.text = formatTime(remainingTime)
    }

    private func updateColor() {
        animatedCountingLabel.textColor = isWorkTime ? PomodoroConstants.workTimeColor : PomodoroConstants.breakTimeColor
        buttonPlayPause.tintColor = isWorkTime ? PomodoroConstants.workTimeColor : PomodoroConstants.breakTimeColor
        circleLayer.strokeColor = isWorkTime ? PomodoroConstants.workTimeColor.cgColor : PomodoroConstants.breakTimeColor.cgColor
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func createCircularPath() {
        let center = view.center
        let radius = PomodoroConstants.circularPathRadiusMultiplier * PomodoroConstants.screenWidth
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle

        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )

        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = PomodoroConstants.workTimeColor.cgColor
        circleLayer.lineWidth = PomodoroConstants.circleLayerLineWidthMultiplier * PomodoroConstants.screenWidth
        view.layer.addSublayer(circleLayer)
    }
}
