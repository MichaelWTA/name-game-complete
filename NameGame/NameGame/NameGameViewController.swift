//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!

    let nameGame = NameGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameGame.delegate = self

        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameGame.loadGameData {
            DispatchQueue.main.async {
                self.nameGame.startGame()
            }
        }
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        if nameGame.checkAnswer(index: button.id) {
            button.answerState = .correct
            setInteractionEnabled(false)
        } else {
            button.answerState = .incorrect
            button.isUserInteractionEnabled = false
        }
    }


    func setInteractionEnabled(_ value: Bool) {
        for button in imageButtons {
            button.isUserInteractionEnabled = value
        }
    }

    func configureSubviews(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }

        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation: UIDeviceOrientation = size.height > size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
}

extension NameGameViewController: NameGameDelegate {
    func startNextRound() {
        questionLabel.text = nameGame.questionForRound()

        for index in 0..<nameGame.currentChoices.count where index < imageButtons.count {

            let imageButton = imageButtons[index]
            let profile = nameGame.profileFor(choice: index)

            imageButton.answerState = .unknown
            if let imageUrl = profile.headshot?.url {
                var cleanUrl = imageUrl.replacingOccurrences(of: "//", with: "")
                cleanUrl = cleanUrl.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
                cleanUrl = String(format: "http://%@", cleanUrl)
                imageButton.loadImage(from: cleanUrl)
            } else {
                imageButton.clearImage()
            }
            imageButton.setTitle(profile.fullName, for: UIControlState())
            imageButton.id = index

            setInteractionEnabled(true)
        }

    }
}
