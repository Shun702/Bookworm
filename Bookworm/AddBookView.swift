//
//  AddBookView.swift
//  Bookworm
//
//  Created by Shun Le Yi Mon on 19/08/2023.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    @State private var showingError = false
    @State private var errorMessage = "Please make sure to fill in both the name and author of the book."
    @State private var errorTitle = "Input validation"
    
    var components = DateComponents()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }

                Section {
                    Button("Save") {
                        if inputValidation() {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.rating = Int16(rating)
                            newBook.genre = genre
                            newBook.review = review
                            newBook.date = Date.now
                            
                            try? moc.save()
                            dismiss()
                        } else {
                            showingError = true
                                }
                        }
                    .alert(errorTitle, isPresented: $showingError){
                        Button("OK", role: .cancel) {}}message: {
                            Text(errorMessage)
                    }
                }
            }
            .navigationTitle("Add Book")
            
        }
    }
    
    func inputValidation() -> Bool {
        if title.count == 0 || author.count == 0 {
            return false
        }
        else {
            return true
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
