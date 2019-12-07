//
//  InitializerValueAssignment.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct InitializerValueAssignment: SwiftCodeTransformable {
    let name: String
    let expression: String?
}

extension GraphQLStruct {
    
    var initializerValueAssignments: [InitializerValueAssignment] {
        return definition.properties.map { property in
            switch property.graphqlPath {
            case .some(let path):
                let expectedFragmentName = property.type.replacingOccurrences(of: #"[\[\]\.\?]"#, with: "", options: .regularExpression)
                let matchingFragment = allFragments.first { $0.name == expectedFragmentName }
                return InitializerValueAssignment(name: property.name,
                                                  expression: path.expression(matchingFragment: matchingFragment))
            case .none:
                return InitializerValueAssignment(name: property.name, expression: property.name)
            }
        }
    }
    
}

private struct AttributePath {
    indirect enum Kind {
        case value
        case array(Kind)
        case optional(Kind)
    }

    let name: String
    let kind: Kind
}

extension StandardComponent {

    var name: String? {
        switch self {
        case .property(let name):
            return name
        case .call(let name, _):
            return name
        case .fragment:
            return nil
        }
    }

}

extension AttributePath.Kind {

    init(from reference: Schema.GraphQLType.Field.TypeReference) {
        switch reference {
        case .concrete(_):
            self = .optional(.value)
        case .complex(let definition, let reference):
            switch (definition.kind, AttributePath.Kind(from: reference)) {
            case (.list, let value):
                self = .optional(.array(value))
            case (.nonNull, .optional(let value)):
                self = value
            default:
                self = .value
            }
        }
    }

}

extension AttributePath {

    func expression<C: Collection>(attributes: C) -> String where C.Element == AttributePath {
        guard let next = attributes.first else { return name }
        switch kind {
        case .value:
            let rest = next.expression(attributes: attributes.dropFirst())
            return "\(name).\(rest)"
        case .array(let kind):
            let subExpression = AttributePath(name: "$0", kind: kind)
            let rest = subExpression.expression(attributes: attributes)
            return "\(name).map { \(rest) }"
        case .optional(let kind):
            let subExpression = AttributePath(name: "", kind: kind)
            let rest = subExpression.expression(attributes: attributes)
            return "\(name)?\(rest)"
        }
    }

}


extension ValidatedComponent {

    fileprivate func path(matchingFragment: GraphQLFragment?) -> [AttributePath] {
        switch (component, matchingFragment) {
        case (.property(let name), _):
            return [AttributePath(name: name, kind: .init(from: fieldType))]
        case (.fragment, .some(let fragment)):
            return [AttributePath(name: "fragment", kind: .value), AttributePath(name: fragment.name.camelized, kind: .value)]
        case (.fragment, .none):
            return []
        case (.call(let name, _), _):
            return [AttributePath(name: name, kind: .init(from: fieldType))]
        }
    }

}

extension GraphQLPath where Component == ValidatedComponent {

    fileprivate func expression(matchingFragment: GraphQLFragment?) -> String {
        let first: AttributePath
        
        switch target {
        case .query:
            first = AttributePath(name: "data", kind: .value)
        case .object(let type):
            first = AttributePath(name: type.camelized, kind: .value)
        }

        let path = self.path.flatMap { $0.path(matchingFragment: matchingFragment) }
        return first.expression(attributes: path)
    }

}
