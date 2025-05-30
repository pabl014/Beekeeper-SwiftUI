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
    @State private var hiveToDelete: Hive?
    @State private var showDeleteAlert = false
    
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
                    HiveDetailView(hiveId: hive.hiveId)
                        .id(hive.hiveId)
                } label: {
                    HiveListCell(
                        imageUrl: hive.photoUrl,
                        name: hive.name,
                        location: hive.address
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .contextMenu {
                    Button(role: .destructive) {
                        hiveToDelete = hive
                        showDeleteAlert = true
                    } label: {
                        Label("Delete Hive", systemImage: "trash")
                    }
                    
                }
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
        .alert("Delete Hive", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                hiveToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let hive = hiveToDelete {
                    Task {
                        await viewModel.deleteHive(hive)
                    }
                }
                hiveToDelete = nil
            }
        } message: {
            if let hive = hiveToDelete {
                Text("Are you sure you want to delete '\(hive.name)'? This action cannot be undone.")
            }
        }
    }
}
