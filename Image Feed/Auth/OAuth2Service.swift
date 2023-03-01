import Foundation

protocol NetworkRouting {
    func fetchAuthToken (didAuthenticateWithCode code: String, completion: @escaping (Result<String, Error>) -> Void)
}
    
final class OAuth2Service: NetworkRouting {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private (set) var bearerToken: String? {
        get {
            return OAuth2TokenStorage().token
         }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }

    func fetchAuthToken (didAuthenticateWithCode code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = authTokenRequest(code: code)
        
        let task = getObject (for: request) { [weak self] result in
            guard let self = self  else {return}
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.bearerToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
         
          
    }
}
func authTokenRequest (code: String ) -> URLRequest {
    let parameters: [String: Any] = ["client_id" : accessKey,
                                     "client_secret" : secretKey,
                                     "redirect_uri" : redirectURI,
                                     "code" : code,
                                     "grant_type" : "authorization_code"]
    let url = URL(string: "https://unsplash.com/oauth/token")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
      // convert parameters to Data and assign dictionary to httpBody of request
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch let error {
      print(error.localizedDescription)
    }
    return request
}

extension OAuth2Service {
    private func getObject (for request: URLRequest,
                            completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.getData(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(OAuthTokenResponseBody.self,
                                                    from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension URLSession {
    private enum NetworkError: Error {
        case codeError
    }
    func getData(for request: URLRequest,
               completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let mainCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                mainCompletion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                mainCompletion(.failure(NetworkError.codeError))
            }
            guard let data = data else { return}
            mainCompletion(.success(data))
        }
        task.resume()
        return task
    }
}
