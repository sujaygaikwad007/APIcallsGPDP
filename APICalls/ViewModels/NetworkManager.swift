import Foundation

class NetworkManager: ObservableObject {
    @Published var posts: [Post] = []

    let baseURL = "https://jsonplaceholder.typicode.com/posts"

    // Fetch posts
    func fetchPosts() {
        guard let url = URL(string: baseURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                do {
                    let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                    DispatchQueue.main.async {
                        self.posts = decodedPosts
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }

    // Add a new post
    func addPost(_ post: Post) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONEncoder().encode(post)
            request.httpBody = data
        } catch {
            print("Error encoding post: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data = data {
                do {
                    var newPost = try JSONDecoder().decode(Post.self, from: data)
                    DispatchQueue.main.async {
                        newPost.id = (self.posts.last?.id ?? 0) + 1
                        self.posts.append(newPost)
                    }
                } catch {
                    print("Error decoding new post: \(error)")
                }
            }
        }.resume()
    }

    // Update an existing post
    func updatePost(_ post: Post) {
        guard let id = post.id, let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONEncoder().encode(post)
            request.httpBody = data
        } catch {
            print("Error encoding post: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data = data {
                do {
                    let updatedPost = try JSONDecoder().decode(Post.self, from: data)
                    DispatchQueue.main.async {
                        if let index = self.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                            self.posts[index] = updatedPost
                        }
                    }
                } catch {
                    print("Error decoding updated post: \(error)")
                }
            }
        }.resume()
    }

    // Delete a post
    func deletePost(_ post: Post) {
        guard let id = post.id, let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            DispatchQueue.main.async {
                self.posts.removeAll { $0.id == post.id }
            }
        }.resume()
    }
}
