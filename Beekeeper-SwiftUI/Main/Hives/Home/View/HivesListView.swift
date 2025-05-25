//
//  HivesListView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 25/05/2025.
//

import SwiftUI

struct HivesListView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var searchText = ""
    
    var filteredHives: [Hive] {
        if searchText.isEmpty {
            return viewModel.hivesArray
        } else {
            return viewModel.hivesArray.filter { hive in
                hive.name.localizedCaseInsensitiveContains(searchText) ||
                hive.address.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredHives) { hive in
                NavigationLink {
                    Text("detail view")
                } label: {
                    HiveListCell(
                        imageUrl: hive.photoUrl,
                        name: hive.name,
                        location: hive.address
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .searchable(text: $searchText, prompt: "Search hives...")
        .navigationTitle("All Hives")
        .refreshable {
            await viewModel.loadHives()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading hives...")
            } else if filteredHives.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }
}
