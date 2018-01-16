//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation

protocol NameGameDelegate: class {
    func startNextRound()
}

final class NameGame {

    weak var delegate: NameGameDelegate?

    private let numberPeople = 6
    private var guessesLeft = 5
    private var profiles: [Profile] = []
    private var correctAnswer: Profile!
    var currentChoices: [Profile] = [Profile]()

    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        API.getProfiles { (profiles: [Profile]?, error: Error?) in
            guard let profiles = profiles, error == nil else {
                NSLog("Failed to get list of people")
                return
            }

            self.profiles = profiles
            completion()
        }
    }

    func startGame() {
        createNewRound()
        delegate?.startNextRound()
    }

    private func createNewRound() {
        var currentChoiceIndexes = [Int]()
        currentChoices = [Profile]()
        guessesLeft = numberPeople
        for _ in 0..<numberPeople {

            var newPersonIndex = Int(arc4random_uniform(UInt32(profiles.count)))
            while currentChoiceIndexes.contains(newPersonIndex) {
                newPersonIndex = Int(arc4random_uniform(UInt32(profiles.count)))
            }

            currentChoiceIndexes.append(newPersonIndex)
            currentChoices.append(profiles[newPersonIndex])
        }

        correctAnswer = profiles[currentChoiceIndexes[Int(arc4random_uniform(UInt32(currentChoiceIndexes.count - 1)))]]
    }

    func questionForRound() -> String {
        return "Who is \(correctAnswer.fullName)?"
    }

    func profileFor(choice choiceIndex: Int) -> Profile {
        guard choiceIndex < currentChoices.count else {
            fatalError("The specified choice index is out of bounds")
        }

        return currentChoices[choiceIndex]
    }
    
    func checkAnswer(index: Int) -> Bool {
        let profile = currentChoices[index]
        if correctAnswer == profile {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.createNewRound()
                self.delegate?.startNextRound()
            }
            return true
        } else {
            guessesLeft -= 1
            if guessesLeft <= 0 {
                createNewRound()
                self.delegate?.startNextRound()
            }
            return false
        }
    }
}
