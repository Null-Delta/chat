//
//  RoundedCornersView.swift
//  chat
//
//  Created by Rustam Khakhuk on 25.06.2025.
//

import UIKit

struct Corners {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    init(all: CGFloat) {
        self.init(topLeft: all, topRight: all, bottomLeft: all, bottomRight: all)
    }
}

struct Border {
    var color: UIColor
    var width: CGFloat
}

final class RoundedCornersContainerView<T: UIView>: UIView {
    var corners = Corners() {
        didSet { updateCorners() }
    }

    var border: Border? {
        didSet {
            borderLayer.opacity = border == nil ? 0 : 1
            borderLayer.strokeColor = border?.color.cgColor
            borderLayer.lineWidth = border?.width ?? 0
        }
    }

    var contentView: T
    private(set) var maskLayer = CAShapeLayer()
    private var borderLayer = CAShapeLayer()

    init(contentView: T) {
        self.contentView = contentView
        super.init(frame: .zero)

        addSubview(contentView)
        contentView.layer.mask = maskLayer
        layer.addSublayer(borderLayer)

        borderLayer.opacity = 0
        borderLayer.fillColor = UIColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = bounds
        borderLayer.frame = bounds
        updateCorners()
    }

    private func updateCorners() {
        let path = createRoundedPath()
        maskLayer.path = path.cgPath
        borderLayer.path = path.cgPath
        layer.shadowPath = path.cgPath
    }
    
    private func createRoundedPath() -> UIBezierPath {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: bounds.minX + corners.topLeft, y: bounds.minY))

        path.addLine(to: CGPoint(x: bounds.maxX - corners.topRight, y: bounds.minY))
        path.addArc(
            withCenter: CGPoint(x: bounds.maxX - corners.topRight, y: bounds.minY + corners.topRight),
            radius: corners.topRight,
            startAngle: -CGFloat.pi / 2,
            endAngle: 0,
            clockwise: true
        )

        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - corners.bottomRight))
        path.addArc(
            withCenter: CGPoint(x: bounds.maxX - corners.bottomRight, y: bounds.maxY - corners.bottomRight),
            radius: corners.bottomRight,
            startAngle: 0,
            endAngle: CGFloat.pi / 2,
            clockwise: true
        )

        path.addLine(to: CGPoint(x: bounds.minX + corners.bottomLeft, y: bounds.maxY))
        path.addArc(
            withCenter: CGPoint(x: bounds.minX + corners.bottomLeft, y: bounds.maxY - corners.bottomLeft),
            radius: corners.bottomLeft,
            startAngle: CGFloat.pi / 2,
            endAngle: CGFloat.pi,
            clockwise: true
        )

        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + corners.topLeft))
        path.addArc(
            withCenter: CGPoint(x: bounds.minX + corners.topLeft, y: bounds.minY + corners.topLeft),
            radius: corners.topLeft,
            startAngle: CGFloat.pi,
            endAngle: -CGFloat.pi / 2,
            clockwise: true
        )

        path.close()

        return path
    }
}
