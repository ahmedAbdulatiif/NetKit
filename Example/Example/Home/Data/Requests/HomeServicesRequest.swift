import NetKit

class HomeServicesRequest: BaseAPIRequest {
    
    let numberOfItems: String

    init(numberOfItems: String) {
        self.numberOfItems = numberOfItems
        super.init()
        self.path = "/login"
        self.method = .get
//        self.authorization = .bearerToken
    }
    
    override var queryBody: Any? {
        return [
            "number_of_items": numberOfItems
        ]
    }
}
