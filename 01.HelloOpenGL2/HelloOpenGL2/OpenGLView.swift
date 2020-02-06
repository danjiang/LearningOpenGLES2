//
//  OpenGLView.swift
//  HelloOpenGL
//
//  Created by Dan Jiang on 2020/2/6.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

class OpenGLView: UIView {
        
    private var context: EAGLContext?
    private var frameBuffer = GLuint()
    private var colorRenderBuffer = GLuint()

    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }

    private var eaglLayer: CAEAGLLayer? {
        return layer as? CAEAGLLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let eaglLayer = eaglLayer else { return }
        eaglLayer.isOpaque = true
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: false,
                                        kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]

        // 指定 OpenGL ES 版本来初始化 OpenGL Context
        guard let context = EAGLContext(api: .openGLES2) else {
            print("Could not initialize OpenGL context")
            exit(1)
        }
        self.context = context
    }
    
    private func setupFrameBuffer() {
        guard let context = context, let eaglLayer = eaglLayer else { return }
        
        // 创建 frame buffer
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)

        // 创建 render buffer
        glGenRenderbuffers(1, &colorRenderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderBuffer)
        
        // eaglLayer 和 render buffer 共享数据，才能在 layer 上显示
        if !context.renderbufferStorage(Int(GL_RENDERBUFFER), from: eaglLayer) {
            print("Could not bind a drawable object’s storage to a render buffer object")
            exit(1)
        }

        // 关联 frame buffer 和 render buffer，frame buffer 内容渲染到 render buffer
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER),
                                  GLenum(GL_COLOR_ATTACHMENT0),
                                  GLenum(GL_RENDERBUFFER),
                                  colorRenderBuffer)
        
        // 检查创建 frame buffer 有没有错误
        if glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GL_FRAMEBUFFER_COMPLETE {
            print("Could not generate frame buffer")
            exit(1)
        }
    }
    
    func display() {
        let oldContext = EAGLContext.current()
        if context != oldContext {
            if !EAGLContext.setCurrent(context) {
                print("Could not set current OpenGL context with new context")
                exit(1)
            }
        }
        
        if frameBuffer == 0 {
            setupFrameBuffer()
        }
        
        // OpenGL Context 绘制的区域大小
        glViewport(0, 0, GLint(bounds.size.width), GLint(bounds.size.height))
        // 设置 clear 的颜色
        glClearColor(0.0, 0.0, 1.0, 1.0)
        // clear color buffer，当然还有其他 buffer
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        // 将 render buffer 的内容显示到 layer 上
        context?.presentRenderbuffer(Int(GL_RENDERBUFFER))

        if oldContext != context {
            if !EAGLContext.setCurrent(oldContext) {
                print("Could not set current OpenGL context with old context")
                exit(1)
            }
        }
    }
    
}
