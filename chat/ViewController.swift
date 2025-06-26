//
//  ViewController.swift
//  chat
//
//  Created by Rustam Khakhuk on 25.06.2025.
//

import UIKit

class InputView: UIView {
    private let firstGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.type = .axial
        layer.locations = [0, 1]
        layer.colors = [
            UIColor(rgb: 0xE3ECF5).withAlphaComponent(0.7).cgColor,
            UIColor(rgb: 0xFFFFFC).withAlphaComponent(0).cgColor
        ]
        return layer
    }()

    private let secondGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.type = .axial
        layer.locations = [0, 1]
        layer.colors = [
            UIColor(rgb: 0xFFFFFC).withAlphaComponent(0).cgColor,
            UIColor(rgb: 0xFBEEEC).withAlphaComponent(1).cgColor
        ]
        return layer
    }()

    private let thirdGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.opacity = 0.45
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.type = .axial
        layer.locations = [0, 1]
        layer.colors = [
            UIColor(rgb: 0xFFF4F7).withAlphaComponent(1).cgColor,
            UIColor(rgb: 0xFFF4F7).withAlphaComponent(0).cgColor
        ]
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.addSublayer(firstGradientLayer)
        layer.addSublayer(secondGradientLayer)
        layer.addSublayer(thirdGradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        firstGradientLayer.frame = bounds
        secondGradientLayer.frame = bounds
        thirdGradientLayer.frame = bounds
    }
}

class ErrorView: UIView {
    private let imageView = UIImageView(image: UIImage(named: "warning"))

    private let errorText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2

        label.attributedText = NSAttributedString(
            string: "Sending error. The operation could not be completed.",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph
            ]
        )

        return label
    }()

    private let button: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.contentInsets = .init(top: 0, leading: 33, bottom: 0, trailing: 0)
        buttonConfig.baseForegroundColor = .white
        buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { container in
            var container = container
            container.font = UIFont.systemFont(ofSize: 12, weight: .bold)

            return container
        }

        let button = UIButton(
            configuration: buttonConfig,
            primaryAction: UIAction(handler: { _ in
                print("Tap!")
            })
        )
        button.setTitle("PRESS TO RESEND", for: .normal)
        button.contentHorizontalAlignment = .left

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(named: "error")
        addSubview(imageView)
        addSubview(errorText)
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = CGRect(x: 11, y: 6, width: 18, height: 18)
        errorText.frame = CGRect(x: imageView.frame.maxX + 4, y: 6, width: 255, height: 32)
        button.frame = CGRect(x: 0, y: bounds.height - 38, width: bounds.width, height: 38)
    }
}

class MessageView: UIView {
    private let messageContainerView: RoundedCornersContainerView = {
        let view = RoundedCornersContainerView(contentView: UIView())
        view.contentView.backgroundColor = UIColor(named: "primary")
        view.corners = Corners(topLeft: 17, topRight: 21, bottomLeft: 17, bottomRight: 2)
        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 1

        return view
    }()

    private let firstMediaView: UIView = {
        let view = RoundedCornersContainerView(
            contentView: UIImageView(image: UIImage(named: "food_1"))
        )
        view.corners = Corners(all: 2)
        view.corners.topLeft = 14
        view.border = Border(color: .black.withAlphaComponent(0.08), width: 0.5)

        view.contentView.contentMode = .scaleAspectFill

        return view
    }()

    private let secondMediaView: UIView = {
        let view = RoundedCornersContainerView(
            contentView: UIImageView(image: UIImage(named: "food_2"))
        )
        view.corners = Corners(all: 2)
        view.corners.topRight = 18
        view.border = Border(color: .black.withAlphaComponent(0.08), width: 0.5)

        view.contentView.contentMode = .scaleAspectFill

        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 1

        return view
    }()

    private let thirdMediaView: UIView = {
        let view = RoundedCornersContainerView(
            contentView: UIImageView(image: UIImage(named: "food_3"))
        )
        view.corners = Corners(all: 2)
        view.border = Border(color: .black.withAlphaComponent(0.08), width: 0.5)

        view.contentView.contentMode = .scaleAspectFill

        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 1

        return view
    }()

    private let errorView = ErrorView()

    private let textView: UILabel = {
        let label = UILabel()
        label.text = "How are you doing? I’m very ok"
        label.textColor = UIColor(named: "text_primary")
        label.font = .systemFont(ofSize: 17)

        return label
    }()

    private let timeView: UILabel = {
        let label = UILabel()
        label.text = "12:12"
        label.textColor = UIColor(named: "text_secondary")
        label.font = .systemFont(ofSize: 11, weight: .regular)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(messageContainerView)
        messageContainerView.contentView.addSubview(firstMediaView)
        messageContainerView.contentView.addSubview(secondMediaView)
        messageContainerView.contentView.addSubview(thirdMediaView)

        messageContainerView.contentView.addSubview(textView)
        messageContainerView.contentView.addSubview(timeView)

        messageContainerView.contentView.addSubview(errorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        messageContainerView.frame = bounds
        firstMediaView.frame = CGRect(x: 3, y: 3, width: 195, height: 259)
        secondMediaView.frame = CGRect(x: firstMediaView.frame.maxX + 3, y: 3, width: 96, height: 128)
        thirdMediaView.frame = CGRect(x: firstMediaView.frame.maxX + 3, y: secondMediaView.frame.maxY + 3, width: 96, height: 128)

        errorView.frame = CGRect(x: 0, y: bounds.maxY - 76, width: bounds.width, height: 76)

        textView.frame = CGRect(x: 12, y: firstMediaView.frame.maxY + 6, width: 241, height: 22)

        timeView.sizeToFit()
        timeView.frame = CGRect(x: bounds.width - timeView.bounds.width - 12, y: errorView.frame.minY - 6 - timeView.bounds.height, width: timeView.bounds.width, height: timeView.frame.height)
    }
}

class ViewController: UIViewController {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "background")
        return imageView
    }()

    private let messageView = MessageView()
    private let bottomInputView = InputView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        backgroundImageView.frame = view.bounds

        bottomInputView.frame = CGRect(x: 0, y: view.bounds.height - view.safeAreaInsets.bottom - 48, width: view.bounds.width, height: 48 + view.safeAreaInsets.bottom)

        messageView.frame = CGRect(
            x: view.bounds.width - 300 - 12,
            y: bottomInputView.frame.minY - 373 - 8,
            width: 300,
            height: 373
        )

    }

    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(messageView)
        view.addSubview(bottomInputView)
    }
}

