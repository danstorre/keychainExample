import Foundation
import Security

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}



enum Services: String{
    
    case deezerService
    case cienradios
}

class Keychain {
    
    static let shared: Keychain = Keychain()
    
    
    func getTokenDeezer(fromAccount account: String) throws -> String {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrService as String: Services.deezerService.rawValue,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let passwordString = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        return passwordString
        
    }
    
    func updateDeezerToken(token: String,
                           fromAccount account: String) throws{
        
        let data = token.data(using: String.Encoding.utf8)!
        
        let queryUpdate: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: Services.deezerService.rawValue,
                                       kSecAttrAccount as String: account]
        
        let attributesUpdate: [String: Any] = [kSecAttrAccount as String: account,
                                         kSecValueData as String: data]
        
        let status = SecItemUpdate(queryUpdate as CFDictionary, attributesUpdate as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    func addDeezerToken(token: String,
                        fromAccount account: String) throws{
        
        let data = token.data(using: String.Encoding.utf8)!
        
        let queryAdd: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: Services.deezerService.rawValue,
                                       kSecAttrAccount as String: account,
                                       kSecValueData as String: data]
        
        

        let status = SecItemAdd(queryAdd as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
    }
    
}
