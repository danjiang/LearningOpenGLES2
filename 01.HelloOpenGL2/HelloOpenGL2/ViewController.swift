//
//  ViewController.swift
//  HelloOpenGL
//
//  Created by burt on 2016. 2. 23..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let openGLView = OpenGLView()
    private var displayLink: CADisplayLink?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        openGLView.frame = view.bounds
        
        view.addSubview(openGLView)
        
        displayLink = CADisplayLink(target: self, selector: #selector(drawFrame))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc private func drawFrame() {
        openGLView.display()
    }

}

