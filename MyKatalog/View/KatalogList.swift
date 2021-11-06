//
//  KatalogList.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 19/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

class ViewModel: ObservableObject {
    @Published var colorScheme: ColorScheme = .light
    
    @Published var favoriteKatalogIDs: Set<Int> = []
    
    @Published var displayableKatalogs: [Result] = []
    
    private var results: [Result] = []
    
    private let darkModePreferencesKey: String = "user.preferences.darkMode"
    
    @Published var isDarkMode: Bool = false {
        didSet {
            isDarkModePreferences = isDarkMode
            colorScheme = isDarkMode ? .dark : .light
        }
    }
    
    var isDarkModePreferences: Bool {
        get {
            UserDefaults.standard.bool(forKey: darkModePreferencesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: darkModePreferencesKey)
        }
    }
    
    var searchQuery: String = "" {
        didSet {
            if (searchQuery.isEmpty) {
                return displayableKatalogs = results
            } else {
                displayableKatalogs = results.filter { result in
                    result.name.contains(searchQuery) || result.released.contains(searchQuery)
                }
            }
        }
    }
    
    func isFavorite(katalogID: Int) -> Bool {
        return favoriteKatalogIDs.contains(katalogID)
    }
    
    func markAsFavorite(katalogID: Int) {
        if isFavorite(katalogID: katalogID) {
            favoriteKatalogIDs.remove(katalogID)
        } else {
            favoriteKatalogIDs.insert(katalogID)
        }
    }
    
    func loadData() {
        guard let resourceURL: URL = URL(string: "https://api.rawg.io/api/games?key=1fdf18c99ab545caba28582363571c25") else {
            return
        }
        
        URLSession.shared.dataTask(with: resourceURL) {dataOrNil, _, errorOrNil in
            if let error: Error = errorOrNil {
                fatalError(error.localizedDescription)
            }
            guard let data: Data = dataOrNil else { fatalError("Data is nil") }
            let decoder: JSONDecoder = JSONDecoder()
            //            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                print("data: \(data)")
                let popularResults : Response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    self?.results = popularResults.results
                    self?.displayableKatalogs = self?.results ?? []
                }
                print("test: \(data)")
            } catch let error as DecodingError {
                assertionFailure(error.localizedDescription)
            } catch {
                assertionFailure(error.localizedDescription)
            }
            
        }.resume()
    }
}

struct KatalogList: View {
    let coreDM: CoreDataManager
    @StateObject var viewModel: ViewModel = ViewModel()
    
    private func saveData(result: Result){
        coreDM.saveFavorite(id: Int64(result.id), name: result.name, backgroundImage: result.background_image, releasedDate: result.released, rating: Float(result.rating))
    }
    
    var body: some View {
        List(viewModel.displayableKatalogs, id: \.id) { result in
            VStack(alignment: .leading) {
                NavigationLink(destination: KatalogDetail(id: result.id)){
                    VStack(alignment: .leading) {
                        WebImage(url: URL(string: result.background_image))
                            .resizable()
                            .indicator(.activity)
                            .cornerRadius(6.0)
                            .transition(.fade(duration: 0.5))
                            .aspectRatio(contentMode: .fill)
                        HStack {
                            Text("Title : ").fontWeight(.bold).font(.system(size: 13))
                            Text(result.name).font(.system(size: 14))
                                .fontWeight(.medium)
                                .foregroundColor(viewModel.isFavorite(katalogID: result.id) ? Color.red : Color.orange)
                        }
                        HStack {
                            Text("Released : ").fontWeight(.bold).font(.system(size: 13))
                            Text(result.released).font(.system(size: 14))
                        }
                        HStack {
                            Text("Rating :").fontWeight(.bold).font(.system(size: 13))
                            Text(" \(String(result.rating)) / 5").font(.system(size: 14))
                        }
                    }
                }
            }
            .contextMenu {
                Button {
                    viewModel.markAsFavorite(katalogID: result.id)
                    saveData(result: result)
                } label: {
                    Text(viewModel.isFavorite(katalogID: result.id) ? "Unfavorite" : "Favorite")
                }
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Text("Katalog Game")).navigationBarItems(
            trailing: NavigationLink(destination: About(katalogAbout: KatalogAbout(id: 1,  photo: "photo_rani", name: "Rani Triani G", description: "Dicoding Submission Studi kasus Katalog Game"))){
                if(viewModel.isDarkMode) {
                    Image(systemName: "person.fill").foregroundColor(.white)
                } else {
                    Image(systemName: "person.fill").foregroundColor(.black)
                }
            }
        )
        .navigationTitle(Text("Favorite Game")).navigationBarItems(
            trailing: NavigationLink(destination: FavoriteList(coreDM: CoreDataManager())){
                if(viewModel.isDarkMode) {
                    Image(systemName: "heart.circle.fill").foregroundColor(.white)
                } else {
                    Image(systemName: "heart.circle.fill").foregroundColor(.black)
                }
            }
        )
        .toolbar {
            Toggle("", isOn: $viewModel.isDarkMode)
                .toggleStyle(SwitchToggleStyle())
        }
        .navigationTitle("Katalog Game")
        .searchable(text: $viewModel.searchQuery)
        .preferredColorScheme(viewModel.colorScheme)
        .onAppear{
            viewModel.loadData()
            viewModel.isDarkMode = viewModel.isDarkModePreferences
        }
    }
}
