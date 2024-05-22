import SwiftUI

struct ContentView: View {
    @StateObject var networkManager = NetworkManager()
    @State private var showEditView = false
    @State private var selectedPost: Post?

    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .font(.subheadline)
                    }
                    .onTapGesture {
                        selectedPost = post
                        showEditView.toggle()
                    }
                }
                .onDelete(perform: deletePost)
            }
            .navigationTitle("Posts")
            .navigationBarItems(trailing: Button(action: addPost) {
                Image(systemName: "plus")
            })
            .onAppear {
                networkManager.fetchPosts()
            }
            .sheet(isPresented: $showEditView) {
                if let selectedPost = selectedPost {
                    EditPostView(networkManager: networkManager, post: selectedPost)
                }
            }
        }
    }

    func addPost() {
        let newPost = Post(id: nil, title: "New Post", body: "This is a new post.")
        networkManager.addPost(newPost)
    }

    func deletePost(at offsets: IndexSet) {
        for index in offsets {
            let post = networkManager.posts[index]
            networkManager.deletePost(post)
        }
    }
}


