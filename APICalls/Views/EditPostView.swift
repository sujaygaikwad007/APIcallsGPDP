import SwiftUI

struct EditPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var networkManager: NetworkManager
    @State var post: Post

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $post.title)
                }
                Section(header: Text("Body")) {
                    TextField("Body", text: $post.body)
                }
            }
            .navigationTitle("Edit Post")
            .navigationBarItems(trailing: Button("Save") {
                if let index = networkManager.posts.firstIndex(where: { $0.id == post.id }) {
                    networkManager.posts[index] = post
                    networkManager.updatePost(post)
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}


