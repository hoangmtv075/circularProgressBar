//
//  ViewController.swift
//  Emitter_
//
//  Created by Thanh Hoang on 15/6/24.
//

import UIKit

class ViewController: UIViewController {
    
    var displayLink: CADisplayLink!
    let trackingLayer = CALayer()
    
    let containerView = UIView()
    
    let coverView = UIView()
    let coverImageView = UIImageView()
    
    let placeholderShape = CAShapeLayer()
    let maskShape = CAShapeLayer()
    let gradient = CAGradientLayer()
    
    let pointerImageView = UIImageView()
    
    let emitter = CAEmitterLayer()
    let emitterCell = CAEmitterCell()
    
    let timeView = UIView()
    let timeLbl = UILabel()
    let startBtn = ButtonAnimation()
    
    let coverH: CGFloat = 300.0
    var rect: CGRect {
        return CGRect(x: 0.0, y: 0.0, width: coverH, height: coverH)
    }
    
    var strokeEndDr: TimeInterval = 15.0
    
    let lineWidth: CGFloat = 20.0
    var pointerH: CGFloat {
        return lineWidth - 4
    }
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        //TODO: - DisplayLink
        createDisplayLink()
        
        //TODO: - ContainerView
        createContainerView()
        
        //TODO: - CoverView
        createCoverView()
        
        //TODO: - PointerView
        createPointerImageView()
        
        //TODO: - TimeView
        createTimeView()
        
        //TODO: - StartBtn()
        createStartBtn()
        
        //TODO: - CoverImageView
        createCoverImageView()
        
        //TODO: - ShapeLayer
        createPlaceholderShape()
        
        //TODO: - MaskShape
        createMaskShape()
        
        //TODO: - GradientLayer
        createGradient()
    }
}

//MARK: - CADisplayLink

extension ViewController {
    
    private func createDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func displayLinkDidUpdate(_ sender: CADisplayLink) {
        if let layer = trackingLayer.presentation() {
            let pos = coverView.layer.convert(layer.position, from: trackingLayer)
            
            if pos != .zero {
                emitter.emitterPosition = pos
                pointerImageView.center = pos
            }
        }
    }
}

//MARK: - ContainerView

extension ViewController {
    
    private func createContainerView() {
        containerView.frame = CGRect(
            x: (view.frame.width - coverH)/2,
            y: (view.frame.height - coverH)/2,
            width: coverH,
            height: coverH
        )
        containerView.clipsToBounds = false
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
    }
}

//MARK: - CoverView

extension ViewController {
    
    private func createCoverView() {
        //TODO: - CoverView
        coverView.frame = CGRect(x: 0.0, y: 0.0, width: coverH, height: coverH)
        coverView.backgroundColor = .white
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = coverH/2
        containerView.addSubview(coverView)
    }
}

//MARK: - PointerImageView

extension ViewController {
    
    private func createPointerImageView() {
        pointerImageView.frame = CGRect(
            x: (containerView.frame.width - pointerH)/2,
            y: coverView.frame.origin.y - pointerH/4,
            width: pointerH,
            height: pointerH
        )
        pointerImageView.clipsToBounds = true
        pointerImageView.layer.cornerRadius = pointerH/2
        pointerImageView.image = UIImage(named: "flake")?.withRenderingMode(.alwaysTemplate)
        pointerImageView.tintColor = UIColor(hex: 0xFFBA14)
        pointerImageView.isHidden = true
        containerView.addSubview(pointerImageView)
    }
}

//MARK: - TimeView

extension ViewController {
    
    private func createTimeView() {
        //TODO: - TimeView
        timeView.frame = CGRect(
            x: (view.frame.width-100)/2,
            y: (view.frame.height-100)/2,
            width: 100.0,
            height: 100.0
        )
        timeView.clipsToBounds = true
        timeView.backgroundColor = .clear
        timeView.layer.cornerRadius = 50.0
        timeView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        timeView.layer.borderWidth = 3.0
        timeView.isHidden = true
        view.addSubview(timeView)
        
        //TODO: - TimeLbl
        timeLbl.frame = CGRect(
            x: (100 - 90)/2,
            y: (100 - 90)/2,
            width: 90.0,
            height: 90.0
        )
        timeLbl.font = UIFont.boldSystemFont(ofSize: 20.0)
        timeLbl.textAlignment = .center
        timeLbl.backgroundColor = .darkGray.withAlphaComponent(0.5)
        timeLbl.clipsToBounds = true
        timeLbl.layer.cornerRadius = 45.0
        timeLbl.text = "00:15"
        timeLbl.textColor = .white
        timeView.addSubview(timeLbl)
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true, block: { _ in
            self.strokeEndDr -= 1
            
            if self.strokeEndDr <= 0 {
                self.strokeEndDr = 0
                
                self.timer?.invalidate()
                self.timer = nil
            }
            
            let minutes = NSInteger(self.strokeEndDr) / 60
            let seconds = NSInteger(self.strokeEndDr) % 60
            let str = NSString(format: "%0.2d:%0.2d", minutes, seconds)
            
            self.timeLbl.text = "\(str)"
        })
    }
}

//MARK: - StartBtn

extension ViewController {
    
    private func createStartBtn() {
        startBtn.frame = CGRect(
            x: (view.frame.width-120)/2,
            y: containerView.frame.maxY+20,
            width: 120.0,
            height: 50.0
        )
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
        startBtn.clipsToBounds = true
        startBtn.layer.cornerRadius = 8.0
        startBtn.setTitle("Start", for: .normal)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.backgroundColor = UIColor(hex: 0xFFBA14)
        startBtn.addTarget(self, action: #selector(startDidTap), for: .touchUpInside)
        view.addSubview(startBtn)
    }
    
    @objc private func startDidTap() {
        pointerImageView.isHidden = false
        timeView.isHidden = false
        
        //TODO: - EmitterLayer
        createEmitter()
        
        //TODO: - Animation
        createAnimation()
        
        startBtn.isHidden = true
    }
}

//MARK: - CoverImageView

extension ViewController {
    
    private func createCoverImageView() {
        coverImageView.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: coverH,
            height: coverH
        )
        coverImageView.image = UIImage(named: "logo-new")
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = coverH/2
        coverView.addSubview(coverImageView)
    }
}

//MARK: - PlaceholderShape

extension ViewController {
    
    private func createPlaceholderShape() {
        placeholderShape.path = UIBezierPath(roundedRect: rect, cornerRadius: coverH/2).cgPath
        placeholderShape.lineWidth = lineWidth
        placeholderShape.strokeColor = UIColor.darkGray.cgColor
        placeholderShape.fillColor = UIColor.clear.cgColor

        coverView.layer.addSublayer(placeholderShape)
    }
}

//MARK: - MaskShape

extension ViewController {
    
    private func createMaskShape() {
        let maskPath = UIBezierPath(
            arcCenter: CGPoint(x: coverH/2, y: coverH/2),
            radius: (coverH-(lineWidth/2))/2,
            startAngle: -.pi/2,
            endAngle: 3*(.pi/2),
            clockwise: true
        ).cgPath

        maskShape.path = maskPath
        maskShape.lineWidth = lineWidth/2
        maskShape.strokeColor = UIColor.red.cgColor
        maskShape.fillColor = UIColor.clear.cgColor
        maskShape.lineCap = .round
        maskShape.strokeEnd = 0.0
        
        //TODO: - TrackingLayer
        maskShape.addSublayer(trackingLayer)
    }
}

//MARK: - Gradient

extension ViewController {
    
    private func createGradient() {
        gradient.frame = rect
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = coverH/2
        gradient.colors = [
            UIColor(hex: 0xFFBA14).cgColor,
            UIColor(hex: 0xAF7C09).cgColor
        ]
        gradient.mask = maskShape

        coverView.layer.addSublayer(gradient)
    }
}

//MARK: - StrokeEndAnimation

extension ViewController {
    
    private func createAnimation() {
        CATransaction.begin()
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDr
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.fillMode = .forwards
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.delegate = self
        
        let followPathAnimation = CAKeyframeAnimation(keyPath: "position")
        followPathAnimation.path = maskShape.path
        followPathAnimation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        followPathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        followPathAnimation.duration = strokeEndDr
        
        trackingLayer.add(followPathAnimation, forKey: nil)
        
        maskShape.add(strokeEndAnimation, forKey: nil)
        
        CATransaction.commit()
    }
}

//MARK: - Emitter

extension ViewController {
    
    private func createEmitter() {
        let width = lineWidth*4
        let emitterSize = CGSize(width: width, height: width)
        
        let emitterW: CGFloat = coverH + 20
        
        emitter.frame = CGRect(
            x: (view.frame.width-emitterW)/2,
            y: (view.frame.height-emitterW)/2,
            width: emitterW,
            height: emitterW
        )
        emitter.emitterShape = .circle
        emitter.emitterSize = emitterSize
        emitter.cornerRadius = emitterW/2
        
        view.layer.addSublayer(emitter)
        
        emitterCell.contents = UIImage(named: "flake")?.cgImage
        emitterCell.color = UIColor(hex: 0xFFBA14).cgColor
        emitterCell.birthRate = 10
        emitterCell.lifetime = 0.5
        emitterCell.speed = 2.5
        emitterCell.yAcceleration = 5
        emitterCell.velocity = -1
        emitterCell.emissionRange = 0.5
        
        emitter.emitterCells = [emitterCell]
    }
}

//MARK: - CAAnimationDelegate

extension ViewController: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        print("animationDidStart")
        
        //TODO: - Timer
        createTimer()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animationDidStop")
        
        pointerImageView.frame.origin = CGPoint(
            x: (containerView.frame.width - pointerH)/2,
            y: coverView.frame.origin.y - pointerH/4
        )
        pointerImageView.isHidden = true
        
        emitter.removeFromSuperlayer()
        
        displayLink?.invalidate()
        displayLink = nil
        
        timeView.isHidden = true
    }
}

internal extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
