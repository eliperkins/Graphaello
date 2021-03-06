//
//  SubAssembler.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

protocol RequestAssembler {
    func assemble(queries: [GraphQLQuery], fragments: [GraphQLFragment], mutations: [GraphQLMutation], for api: API) throws -> ApolloCodeGenRequest
}
