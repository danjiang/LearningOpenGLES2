//
//  ViewController.swift
//  Triangle
//
//  Created by burt on 2016. 2. 25..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import UIKit
import GLKit

class GLKUpdater : NSObject, GLKViewControllerDelegate {
    
    weak var glkViewController : GLKViewController!
    
    init(glkViewController : GLKViewController) {
        self.glkViewController = glkViewController
    }
    
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        
    }
}


class ViewController: GLKViewController {
    
    var glkView: GLKView!
    var glkUpdater: GLKUpdater!
    
    var vertexBuffer : GLuint = 0
    var shader : BaseEffect!
        
    let vertices : [Vertex] = [
        Vertex( 0.0,  0.25, 0.0),    // TOP
        Vertex(-0.5, -0.25, 0.0),    // LEFT
        Vertex( 0.5, -0.25, 0.0),    // RIGHT

    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGLcontext()
        setupGLupdater()
        setupShader()
        setupVertexBuffer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        // shader.begin() 이 더 나은거 같다.
        shader.prepareToDraw()
        
        // turn attribute on
        glEnableVertexAttribArray(VertexAttributes.vertexAttribPosition.rawValue)
        // where is it in the vertex buffer
        glVertexAttribPointer(
            VertexAttributes.vertexAttribPosition.rawValue, // Attribute Index
            3, // 数据大小
            GLenum(GL_FLOAT), // 数据类型
            GLboolean(GL_FALSE), // 是否标准化
            GLsizei(MemoryLayout<Vertex>.size), // 步进长度也就是一个 Vertex 数据的大小
            nil) // 在 Vertex 数据结构中的 Offset
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        // turn attribute off
        glDisableVertexAttribArray(VertexAttributes.vertexAttribPosition.rawValue)
    }

}

extension ViewController {
    
    func setupGLcontext() {
        glkView = self.view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)!
        EAGLContext.setCurrent(glkView.context)
    }
    
    func setupGLupdater() {
        self.glkUpdater = GLKUpdater(glkViewController: self)
        self.delegate = self.glkUpdater
    }
    
    func setupShader() {
        self.shader = BaseEffect(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl")
    }
    
    func setupVertexBuffer() {
        // 在 GPU 中创建一个 Buffer
        glGenBuffers(GLsizei(1), &vertexBuffer)
        // GL_ARRAY_BUFFER 指向上面创建的 Buffer
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        // 给 GPU 提供 Buffer 数据，就是 GL_ARRAY_BUFFER 当前指向的 Buffer
        // 参数依次为 target、数据内存大小、数据、使用方式（因为不会变化，所以这里是 GL_STATIC_DRAW）
        let count = vertices.count
        let size =  MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
    }

    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
        let ptr: UnsafeRawPointer? = nil
        return ptr! + n * MemoryLayout<Void>.size
    }
}
