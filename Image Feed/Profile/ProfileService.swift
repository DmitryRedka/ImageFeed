import Foundation

final class ProfileService {

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        
        lastToken = token
        let request = profileRequest(authToken: token)
        
        let task = getObject (for: request) { [weak self] result in
            guard let self = self  else {return}
            switch result {
            case .success(let body):
                let profile = Profile(username: body.username,
                                      firstName: body.firstName,
                                      lastName: body.lastName,
                                      bio: body.bio)
                completion(.success(profile))
                self.task = nil

            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
}

func profileRequest (authToken: String ) -> URLRequest {

    let url = URL(string: "https://api.unsplash.com/me")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    return request
}

extension ProfileService {
    private func getObject (for request: URLRequest,
                            completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.getData(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(ProfileResult.self,
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

extension ProfileService {
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
