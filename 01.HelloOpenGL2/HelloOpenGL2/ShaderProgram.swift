//
//  ShaderProgram.swift
//  HelloOpenGL2
//
//  Created by Dan Jiang on 2020/2/7.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

import UIKit

class ShaderProgram {
    
    private var program: GLuint = 0
    
    init(vertexShaderName: String, fragmentShaderName: String) {
        let vertexShader = compileShader(name: vertexShaderName, with: GLenum(GL_VERTEX_SHADER))
        let fragmentShader = compileShader(name: fragmentShaderName, with: GLenum(GL_FRAGMENT_SHADER))
        
        // 创建 shader program
        program = glCreateProgram()
        // 附加 vertex shader 给 program
        glAttachShader(program, vertexShader)
        // 附加 fragment shader 给 program
        glAttachShader(program, fragmentShader)
        // 连接
        glLinkProgram(program)
        
        var linkStatus = GLint()
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_FALSE {
            let bufferLength: GLsizei = 1024
            let info: [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
            glGetProgramInfoLog(program, bufferLength, nil, UnsafeMutablePointer(mutating: info))
            print("Could not link shader file \(vertexShaderName) and \(fragmentShaderName): \(String(validatingUTF8: info) ?? "")")
            exit(1)
        }
        
        if vertexShader != 0 {
            glDeleteShader(vertexShader)
        }
        if fragmentShader != 0 {
            glDeleteShader(fragmentShader)
        }
    }
    
    func use() {
        glUseProgram(program)
    }
    
    func delete() {
        if program != 0 {
            glDeleteProgram(program)
            program = 0
        }
    }
    
    func attributeLocation(for name: String) -> GLuint {
        return GLuint(glGetAttribLocation(program, name))
    }
    
    func uniformLocation(for name: String) -> GLint {
        return glGetUniformLocation(program, name)
    }
    
    // bundle 中读取 shader 文件，转换成 C 字符串，丢给 OpenGL 编译
    private func compileShader(name: String, with type: GLenum) -> GLuint {
        do {
            guard let shaderPath = Bundle.main.path(forResource: name, ofType: "glsl") else {
                print("Could not find shader file \(name)")
                exit(1)
            }
            let shaderString = try NSString(contentsOfFile: shaderPath, encoding: String.Encoding.utf8.rawValue)
            var shaderCString = shaderString.utf8String
            var shaderStringLength = GLint(shaderString.length)
            let shader = glCreateShader(type)
            glShaderSource(shader, 1, &shaderCString, &shaderStringLength)
            
            glCompileShader(shader)
            
            var compileStatus = GLint()
            glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &compileStatus)
            if compileStatus == GL_FALSE {
                let bufferLength: GLsizei = 1024
                let info: [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
                glGetShaderInfoLog(shader, bufferLength, nil, UnsafeMutablePointer(mutating: info))
                print("Could not compile shader file \(name): \(String(validatingUTF8: info) ?? "")")
                exit(1)
            }
            
            return shader
        } catch {
            print("Could not load shader file \(name)")
            exit(1)
        }
    }

}
