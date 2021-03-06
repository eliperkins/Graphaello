//
//  code.swift
//  Graphaello
//
//  Created by Mathias Quintero on 10.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

func code(@CodeBuilder builder: () -> CodeTransformable) throws -> String {
    let transformable = builder()
    return try transformable.code(using: .custom)
}
