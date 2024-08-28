import Foundation
import NetKit

class HomeServicesMapper: BaseMapper<[Service]> {
    private struct HomeServicesResponse: Decodable {
        let servicesResponseData: ServicesResponseData?
    }
    private struct ServicesResponseData: Decodable {
        let services: [ServiceModel]?
    }
    private struct ServiceModel: Decodable {
        let serviceId: Int?
        let name: String?
        let image: String?
        let price: Double?
        let description: String?
    }
    
    override func parse(_ data: Data) throws -> [Service] {
        let response: HomeServicesResponse = try decode(data: data)
        let mappedResult = response.servicesResponseData?.services?.map {
            Service(
                id: $0.serviceId ?? 0,
                name: $0.name ?? "",
                image: $0.image ?? ""
            )
        }
        return mappedResult ?? []
    }
}
