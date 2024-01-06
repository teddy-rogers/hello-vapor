import Vapor
import Leaf

struct User: Content {
    var name: String
}

struct SomeQueryType: Content {
    var lang: String?
    var age: Int?
}

struct Product: Content {
    var id:              String
    var isActive:        Bool
    var name:            String
    var description:     String
    var imageUrl:        String
    var backgroundColor: String
    var price:           Decimal
    var sale:            Decimal
}

struct WelcomeContext: Encodable {
    var title: String
    var name: String
}

func routes(_ app: Application) throws {
    
    try app.register(collection: ViewsController())
  
    
    app.group("hello") {hello in
        hello.get { req in
            return "Hello, world!"
        }
        
        hello.get(":name") {req async throws -> View in
            let name = req.parameters.get("name")!
            return try await req.view.render("hello", WelcomeContext(title:"Hey, welcome", name: name))
        }
    }
    
    app.group("users") {users in
        users.get { req in
            return "yo!"
        }
        
        users.group(":id") { user in
            user.get {req -> String in
                let id = req.parameters.get("id")!
                let query = try req.query.decode(SomeQueryType.self)
                let age: Int? =  req.query["age"]
                return "\(id), lang: \(query.lang ?? "en-GB"), age: \(age ?? 0)"
            }
            
            user.patch("upload") { req in
                let userName = try req.content.decode(User.self)
                let data = req.body.drain
                print(userName.name)
                print(data)
                return HTTPStatus.ok
            }
        }
    }
    
    app.group("products") {products in
        products.get {req async in
            do {
                let response = try await req.client.get("http://127.0.0.1:8000/product")
                return response

            } catch {
                fatalError("No products !")
            }
        }
       
    }
}
