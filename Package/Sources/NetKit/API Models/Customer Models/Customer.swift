//
//	Customer.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Customer: Codable {
	let email: String?
	let firstname: String?
	let lastname: String?
    var fullName: String {
        "\(firstname ?? "") \(lastname ?? "")"
    }
}
