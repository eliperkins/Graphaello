//
//  Struct+Prepared+SwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension Struct: CodeTransformable where CurrentStage == Stage.Prepared { }

extension Struct: SwiftCodeTransformable where CurrentStage == Stage.Prepared { }

extension Struct: ExtraValuesSwiftCodeTransformable where CurrentStage == Stage.Prepared {
    
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "functionName" : name.camelized,
            "fragments": fragments,
            "query": query ?? false,
            "initializerArguments" : initializerArguments,
            "initializerValueAssignments" : initializerValueAssignments,
            "queryRendererArguments": queryRendererArguments,
            "queryArgumentAssignments": queryArgumentAssignments,
            "initializerArgumentAssignmentFromQueryData": initializerArgumentAssignmentFromQueryData,
            "mutationStructs": mutationStructs,
            "missingFragmentsStructs": Array(missingFragmentsStructs),
            "missingReferencedFragments": Array(missingReferencedFragments),
        ]
    }
    
}
