//
//  ViewController.swift
//  HelloOpenGL
//
//  Created by burt on 2016. 2. 23..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {
    
    var glkView: GLKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        glkView = self.view as? GLKView
        // 指定 OpenGL ES 版本来初始化 OpenGL Context
        glkView.context = EAGLContext(api: .openGLES2)!
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // 设置 clear 的颜色
        glClearColor(1.0, 0.0, 0.0, 1.0)
        // clear color buffer，当然还有其他 buffer
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }

}

