import Foundation

protocol NetworkRouting {
    func fetchAuthToken (didAuthenticateWithCode code: String, completion: @escaping (Result<Data, Error>) -> Void)
}
    
class OAuth2Service: NetworkRouting {
    private enum NetworkError: Error {
        case codeError
    }
    func fetchAuthToken (didAuthenticateWithCode code: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let parameters: [String: Any] = ["client_id" : accessKey,
                                         "client_secret" : secretKey,
                                         "redirect_uri" : redirectURI,
                                         "code" : code,
                                         "grant_type" : "authorization_code"]
        let url = URL(string: "https://unsplash.com/oauth/token")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.codeError))
            }
            guard let data = data else { return}
            completion(.success(data))
        }
        task.resume()
          
    }
}
