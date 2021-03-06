//
//  Assembler.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

protocol Assembler {
    func assemble(cleaned: Project.State<Stage.Cleaned>) throws -> Project.State<Stage.Assembled>
}
