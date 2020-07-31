//
//  ViewController.swift
//  ConwaysGOL
//
//  Created by scott harris on 7/27/20.
//

import UIKit

class ViewController: UIViewController {
    
    var speed: Float = 1.5
    var timer: Timer?
    var game = GamePlayground()
    var generationCounter = -1 {
        didSet {
            generationDetail.text = "\(generationCounter)"
        }
    }
    var grid: [Cell] = [] {
        didSet {
            DispatchQueue.main.async {
                self.drawCheckerboard()
                self.generationCounter += 1
            }
        }
    }
    var container = UIImageView()
    let generationDetail = UILabel()
    var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        grid = game.grid
        renderGrid()
        layoutToolBar()
//        layoutPlayButton()
        layoutGeneration()
        layoutSpeedSlider()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            let location = touch.location(in: container)
            if container.point(inside: location, with: event) {
                let calc = calcCellFromOrigin(loction: location, width: container.bounds.width / 25)
                print("You selected: \(calc)")
                grid[calc].toggleIsAlive()
                drawCheckerboard()
            }
            
        }
    }
    
    private func renderGrid() {
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true

        view.layoutSubviews()
        
        drawCheckerboard()
        
    }
    
    private func calcOrigin(num: Int, width: CGFloat) -> CGPoint {
        // first eliminate the rows you definetly done need..
        // just divide your number by cols
        //        print("the number to find is: \(num)")
        let ignore = num / 25
        // its gotta be in this row somewhere
        let y = CGFloat(ignore) * width
        
        for i in 0..<25 {
            if ((i + (ignore * 25)) == num) {
                let x = CGFloat(i) * width
                return CGPoint(x: x, y: y)
            }
        }
        
        return .zero
    }
    
    private func calcCellFromOrigin(loction: CGPoint, width: CGFloat) -> Int {
        let x = Int(loction.x / width)
        let y = Int(loction.y / width)
        
        let cellIndex = (25 * y) + x
        
        return cellIndex
    }
    
    private func layoutToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        view.addSubview(toolBar)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let playButton = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(playTapped(_:)))
        let presetButton = UIBarButtonItem(title: "Presets", style: .plain, target: self, action: #selector(presetsTapped))
        
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        let flexibleSpace2 = UIBarButtonItem.flexibleSpace()
        var items = [presetButton, flexibleSpace, playButton, flexibleSpace2]
        toolBar.items = items
    }
    
    @objc func presetsTapped() {
        let actionSheet = UIAlertController(title: nil, message: "Choose Preset", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Empty", style: .default, handler: { (alertAction) in
            self.resetState()
            self.game = GamePlayground()
            self.grid = self.game.grid
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Random", style: .default, handler: { (alertAction) in
            self.resetState()
            self.game = GamePlayground(style: 1)
            self.grid = self.game.grid
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Glider", style: .default, handler: { (alertAction) in
            self.resetState()
            self.game = GamePlayground(style: 2)
            self.grid = self.game.grid
            self.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Small Exploder", style: .default, handler: { (alertAction) in
            self.resetState()
            self.game = GamePlayground(style: 3)
            self.grid = self.game.grid
            self.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Exploder", style: .default, handler: { (alertAction) in
            self.resetState()
            self.game = GamePlayground(style: 4)
            self.grid = self.game.grid
            self.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Blinker", style: .default, handler: { (alertAction) in
            self.resetState()
            self.game = GamePlayground(style: 5)
            self.grid = self.game.grid
            self.dismiss(animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(actionSheet, animated: true) {
            
        }

    }
    
    private func layoutPlayButton() {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitle("Pause", for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(playTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func layoutGeneration() {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Generation"
        generationDetail.font = .preferredFont(forTextStyle: .subheadline)
        generationDetail.text = "0"
        view.addSubview(label)
        view.addSubview(generationDetail)
        label.translatesAutoresizingMaskIntoConstraints = false
        generationDetail.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 32).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        generationDetail.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        generationDetail.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func layoutSpeedSlider() {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Speed"
        let slider = CustomSlider()
        slider.minimumValue = 1.7
        slider.maximumValue = 3
        slider.setValue(1.7, animated: true)
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        view.addSubview(label)
        view.addSubview(slider)
        label.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: generationDetail.bottomAnchor, constant: 24).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func playTapped(_ button: UIBarButtonItem) {
        isPlaying.toggle()
        button.image = isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill")
        updateTimer()

    }
    
    func resetState() {
        isPlaying.toggle()
        invalidateTimer()
    }
    
    private func invalidateTimer() {
        if let timer = timer {
            timer.invalidate()
        }
    }

    private func updateTimer() {
        let context = ["isPlaying": isPlaying]
        invalidateTimer()
        
        timer = Timer.scheduledTimer(timeInterval: Double(speed), target: self, selector: #selector(fireTimer), userInfo: context, repeats: true)
    }
    
    @objc func sliderChanged(_ slider: UISlider) {
        let value = slider.value
        let speed = slider.maximumValue - value + 0.2
        self.speed = speed
        updateTimer()
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: container.bounds.size.width, height: container.bounds.size.height))
        
        let img = renderer.image { ctx in
            
            ctx.cgContext.setStrokeColor(UIColor(white: 0.9, alpha: 0.8).cgColor)
            ctx.cgContext.setLineWidth(1)
            
            for (index, item) in grid.enumerated() {
                let width = container.bounds.size.width / 25
                ctx.cgContext.setFillColor(item.isAlive ? UIColor.black.cgColor : UIColor.white.cgColor)
        
                let origin = calcOrigin(num: index, width: width)
                
                ctx.cgContext.fill(CGRect(x: origin.x, y: origin.y, width: width, height: width))
                ctx.cgContext.stroke(CGRect(x: origin.x, y: origin.y, width: width, height: width))
            }

        }
        
        container.image = img
    }
    
    @objc func fireTimer(timer: Timer) {
        guard let context = timer.userInfo as? [String: Bool] else { return }
        if let isPlaying = context["isPlaying"] {
            if isPlaying {
                grid = game.rotateEarth()
            } else {
                timer.invalidate()
            }
        }
    }

}

