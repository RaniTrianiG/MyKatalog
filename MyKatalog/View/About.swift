//
//  About.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 19/10/21.
//

import SwiftUI

struct TextFieldRow: View {
    var title: String
    @Binding var text: String
    
    var placeholder: String
    
    var body: some View {
        HStack {
            Text(title).font(.system(size: 13)).fontWeight(.bold)
            Spacer()
            TextField(title, text: $text, prompt: Text(placeholder)).font(.system(size: 14))
        }
    }
}

struct AboutUserDefaultKey {
    static let name: String = "user.preferences.name"
    static let username: String = "user.preferences.username"
    static let bio: String = "user.preferences.bio"
}

struct EditorView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile").fontWeight(.bold)) {
                    TextFieldRow(title: "Name : ", text: $name, placeholder: "Your Name Here")
                    HStack {
                        Image("ic-github")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                        TextFieldRow(title: "Username GitHub : ", text: $username, placeholder: "Your username github here")
                    }
                }
                Section(header: Text("Bio").fontWeight(.bold)) {
                    TextEditor(text: $bio).font(.system(size: 14))
                }
            }
            .onAppear(perform: {
                name = UserDefaults.standard.string(forKey: AboutUserDefaultKey.name) ?? ""
                username = UserDefaults.standard.string(forKey: AboutUserDefaultKey.username) ?? ""
                bio = UserDefaults.standard.string(forKey: AboutUserDefaultKey.bio) ?? ""
            })
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        UserDefaults.standard.setValue(name, forKey: AboutUserDefaultKey.name)
                        UserDefaults.standard.setValue(username, forKey: AboutUserDefaultKey.username)
                        UserDefaults.standard.setValue(bio, forKey: AboutUserDefaultKey.bio)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                    })
                }
            }
        }
    }
}

struct About: View {
    var katalogAbout: KatalogAbout
    @AppStorage(AboutUserDefaultKey.name) private var name: String = "Rani Triani G"
    @AppStorage(AboutUserDefaultKey.username) private var username: String = "@RaniTrianiG"
    @AppStorage(AboutUserDefaultKey.bio) private var bio: String = "Projek Akhir Katalog Game"
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading){
                    Image("photo_rani")
                        .resizable()
                        .frame(width: 130, height: 160)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading){
                    HStack {
                        Text("Name : ").fontWeight(.bold).font(.system(size: 13))
                        Text(name)
                            .font(.system(size: 15))
                            .lineLimit(3)
                    }.padding(.top, 5)
                    HStack {
                        Text("Bio : ").fontWeight(.bold).font(.system(size: 13))
                        Text(bio)
                            .font(.system(size: 15))
                            .lineLimit(3)
                    }.padding(.top, 5)
                    HStack{
                        Image("ic-github")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                        Text("Username GitHub :").fontWeight(.bold).font(.system(size: 13))
                        Text(username)
                            .font(.system(size: 15))
                    }
                }.padding(20)
            }.padding(.top, -70)
        }.navigationTitle("Profile").font(.system(size: 15))
            .padding(.bottom, 0)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = true
                    }, label: {
                        Image(systemName: "slider.horizontal.3")
                    })
                }
            }
            .sheet(isPresented: $isPresented, content: {
                EditorView()
            })
    }
}
