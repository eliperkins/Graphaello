//
//  CodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 10.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

protocol CodeTransformable {
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String
}

extension CodeTransformable {
    
    func code(using environment: Environment) throws -> String {
        return try environment.renderTemplate(name: "CodeTransformable.stencil", context: ["value" : self])
    }
    
}
