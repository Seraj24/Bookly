//
//  HomeView.swift
//  Bookly
//
//  Created by user938962 on 2/7/26.
//

import SwiftUI


// Since I haven't implemented the map yet, this view acts as the home view for this iteration
struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
    
                topBar
                
                categoryChips
                
                if vm.selectedCategory == .hotels {
                    searchCardHotels
                } else {
                    searchCardFlights
                }
                
                featuredSection
                
            }
            .padding()
        }
        .navigationTitle("Bookly")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
        .navigationDestination(item: $vm.route) { route in
            switch route {
            case .hotels(let destination):
                HotelsView(destination: destination)

            case .account(let user):
                AccountView(appUser: user)
            }
        }
    }
    
    private var topBar: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Find your next trip")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Search deals on hotels, flights, and more")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                let mockUser = AppUser(id: "1", email: "admin@bookly.com", displayName: "Test User")
                vm.route = .account(mockUser)
            } label: {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var searchCardHotels: some View {
        VStack(spacing: 12) {
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(.secondary)
                TextField("Where to?", text: $vm.destination)
                    .textInputAutocapitalization(.words)
                Spacer()
            }
            
            if !vm.destinationSuggestions.isEmpty {
                
                VStack(spacing: 0) {
                    
                    ForEach(vm.destinationSuggestions.prefix(5), id: \.self) { city in
                        
                        Button {
                            
                            vm.destination = city
                            
                        } label: {
                            HStack {
                                Image(systemName: "mappin")
                                    .foregroundStyle(.secondary)
                                Text(city)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                            }
                            .padding(.vertical, 8)
                        }
                        
                        if city != vm.destinationSuggestions.prefix(5).last {
                            Divider()
                        }
                    }
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Divider()
            
            HStack {
                Label("Dates", systemImage: "calendar")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Select")
                    .foregroundStyle(.blue)
            }
            
            Divider()
            
            HStack {
                Label("Guests", systemImage: "person.2")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("1 adult")
                    .foregroundStyle(.secondary)
            }
            
            Button {
                vm.searchTapped()
            } label: {
                Text("Search")
                    .frame(maxWidth: .infinity)
            }
            .fontWeight(.semibold)
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
            .disabled(!vm.canSearchHotels)
            .opacity(vm.canSearchHotels ? 1 : 0.6)
            
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(radius: 2, y: 1)
    }
    
    private var searchCardFlights: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "airplane.departure")
                    .foregroundStyle(.secondary)
                
                TextField("From", text: $vm.fromCity)
                    .textInputAutocapitalization(.words)
                
                Spacer()
            }
            Divider()
            
            HStack {
                Image(systemName: "airplane.arrival")
                    .foregroundStyle(.secondary)
                
                TextField("To", text: $vm.toCity)
                    .textInputAutocapitalization(.words)
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Label("Departure · Return", systemImage: "calendar")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Select")
                    .foregroundStyle(.blue)
            }
            
            Divider()
            
            HStack {
                Label("Passengers", systemImage: "person.2")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("1 adult · Economy")
                    .foregroundStyle(.secondary)
            }
            
            Button {
                vm.searchTapped()
            } label: {
                Text("Search Flights")
                    .frame(maxWidth: .infinity)
            }
            .fontWeight(.semibold)
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
            .disabled(!vm.canSearchFlights)
            .opacity(vm.canSearchFlights ? 1 : 0.6)
            
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(radius: 2, y: 1)
    }
    
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Category.allCases) { cat in
                    Button {
                        vm.selectCategory(cat)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.icon)
                            Text(cat.title)
                        }
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(vm.selectedCategory == cat ? Color.blue : Color(.systemBackground))
                        .foregroundColor(vm.selectedCategory == cat ? .white : .primary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 2)
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured Deals")
                    .font(.headline)
                Spacer()
                Button("See all") { }
                    .font(.subheadline)
            }
            
            VStack(spacing: 12) {
                ForEach(vm.deals) { deal in
                    DealCard(deal: deal)
                }
            }
        }
    }
}

enum HomeRoute: Hashable, Identifiable {
    case hotels(destination: String)
    case account(AppUser)

    var id: Self { self }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
