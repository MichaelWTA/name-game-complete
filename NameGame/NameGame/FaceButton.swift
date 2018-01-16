//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

final class FaceButton: UIButton {

    var id: Int = 0
    private var tintView: UIView!
    private var nameLabel: UILabel!
    var answerState = AnswerState.unknown {
        didSet {
            switch answerState {
            case .correct:
                showAnswer(withColor: .green)
            case .incorrect:
                showAnswer(withColor: .red)
            case .unknown:
                hideAnswer()
            }
        }
    }

    enum AnswerState {
        case correct
        case incorrect
        case unknown
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        setTitleColor(.white, for: .normal)
        titleLabel?.alpha = 0.0

        let tintView = UIView(frame: self.bounds)
        tintView.alpha = 0.0
        tintView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tintView)

        tintView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tintView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tintView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tintView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        self.tintView = tintView
    }
    
    open func clearImage() {
        setBackgroundImage(nil, for: .normal)
    }

    open func loadImage(from url: String) {
        setBackgroundImage(nil, for: .normal)

        guard let imageURL = URL(string: url) else {
            preconditionFailure("Invalid image link")
        }

        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {
                return
            }

            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                self?.setBackgroundImage(image, for: .normal)
            }
        }).resume()
    }

    private func showAnswer(withColor color: UIColor) {
        tintView.backgroundColor = color
        if let titleLabel = titleLabel {
            bringSubview(toFront: titleLabel)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tintView?.alpha = 0.3
            self.titleLabel?.alpha = 1.0
        })
    }

    private func hideAnswer() {
        tintView.alpha = 0.0
        titleLabel?.alpha = 0.0
    }
}
