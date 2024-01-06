import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    app.views.use(.leaf)
    try routes(app)
}
