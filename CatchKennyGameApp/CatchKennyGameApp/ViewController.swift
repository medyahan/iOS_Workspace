//
//  ViewController.swift
//  CatchKennyGameApp
//
//  Created by Medya Han on 1.12.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var kennyImage: UIImageView!
    
    let gameTime: Int = 10
    let kennyTimeInterval: TimeInterval = 0.5
    
    var timer: Timer?
    var kennyTimer: Timer?
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var counter: Int = 0 {
        didSet {
            timeLabel.text = "Time: \(counter)"
        }
    }
    
    var highScore: Int = 0 {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "highScore")
            highScoreLabel.text = "Highscore: \(highScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGame()
    }
    
    func setupGame() {
        counter = gameTime
        score = 0
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        
        setupKennyGestureRecognizer()
        startTimers()
    }
    
    func setupKennyGestureRecognizer() {
        kennyImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapKenny))
        kennyImage.addGestureRecognizer(tapGesture)
    }
    
    func startTimers() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        kennyTimer = Timer.scheduledTimer(timeInterval: kennyTimeInterval, target: self, selector: #selector(moveKenny), userInfo: nil, repeats: true)
    }
    
    func stopTimers() {
        timer?.invalidate()
        kennyTimer?.invalidate()
        timer = nil
        kennyTimer = nil
    }
    
    @objc func moveKenny() {
        let randomX = CGFloat.random(in: view.bounds.width * 0.2...view.bounds.width * 0.8)
        let randomY = CGFloat.random(in: view.bounds.height * 0.3...view.bounds.height * 0.7)
        
        UIView.animate(withDuration: 0.2) {
            self.kennyImage.center = CGPoint(x: randomX, y: randomY)
        }
    }
    
    @objc func tapKenny() {
        score += 1
    }
    
    @objc func updateCounter() {
        counter -= 1
        
        if counter <= 0 {
            stopTimers()
            showGameOverAlert()
            updateHighScore(score)
        }
    }
    
    func updateHighScore(_ newScore: Int?) {
        let userDefaults = UserDefaults.standard
        
        if let score = newScore {
            if let storedHighScore = userDefaults.string(forKey: "highScore") {
                if score > Int(storedHighScore) ?? 0 {
                    userDefaults.setValue(score, forKey: "highScore")
                    highScore = score
                }
            }
        }
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Your Score: \(score)", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
            self.restartGame()
        }
        
        alert.addAction(restartAction)
        self.present(alert, animated: true)
    }
    
    func restartGame() {
        counter = gameTime
        score = 0
        startTimers()
    }
}

