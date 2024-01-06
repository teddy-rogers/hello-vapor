//
//  File.swift
//  
//
//  Created by Teddy on 06/01/2024.
//

import Foundation
import Vapor

struct HomeContex: Encodable {
    var foo: String
}

struct ViewsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let view = routes.grouped("")
        view.get(use: index)
        view.group(":bar") {path in
            path.get(use: index_bar)
        }
        view.group("realizations") { path in
            path.get(use: realizations)
        }
        view.group("faq") { path in
            path.get(use: faq)
        }
        view.group("contact") { path in
            path.get(use: contact)
        }
    }
    
    
    func index(req: Request) async throws ->  View {
        return try await req.view.render("home")
    }
    
    func index_bar(req: Request) async throws -> View {
        let bar = req.parameters.get("bar")!
        return try await req.view.render("home", HomeContex(foo: bar))
    }
    
    func realizations(req: Request) async throws -> View {
        return try await req.view.render("realizations")
    }
    
    func faq(req:Request) async throws -> View {
        return try await req.view.render("faq")
    }
    
    func contact(req: Request) async throws -> View {
        return try await req.view.render("contact")
    }
}
