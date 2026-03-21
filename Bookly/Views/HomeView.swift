//
//  HomeView.swift
//  Bookly
//
//  Created by user938962 on 2/7/26.
//

import SwiftUI

enum ActiveField {
    case none
    case from
    case to
    case hotelDestination
}

// Since I haven't implemented the map yet, this view acts as the home view for this iteration
struct HomeView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var vm: HomeViewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                HStack {
                    Text("Bookly")
                        .font(.system(size: 34, weight: .bold))
                    
                    Spacer()
                    
                    Button {
                        vm.route = .account
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 37, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 48, height: 48)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
                
                topBar
                categoryChips
                
                if vm.selectedCategory == .hotels {
                    HotelSearchView(showHeader: false) { request in
                        vm.showHotels(request: request)
                    }
                } else {
                    FlightSearchView(showHeader: false) { request in
                        vm.showFlights(request: request)
                    }
                }
                
                featuredSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color("BackgroundColor"))
        .onAppear {
            vm.configure(holder: holder, context: context)
        }
        .navigationDestination(item: $vm.route) { route in
            switch route {
            case .hotels(let request):
                HotelsResultsView(request: request)
            case .flights(let request):
                FlightsResultsView(request: request)
            case .account:
                AccountView()
            }
        }
    }
    
    private var topBar: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Find your next trip")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Search deals on hotels, flights, and more")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(Category.allCases) { cat in
                    CategoryChip(
                        category: cat,
                        isSelected: vm.selectedCategory == cat
                    ) {
                        vm.selectCategory(cat)
                    }
                }
            }
            .padding(.vertical, 6)
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
                    .foregroundStyle(Color("PrimaryColor"))
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
    case hotels(request: HotelSearchRequest)
    case flights(request: FlightSearchRequest)
    case account
    
    var id: Self { self }
}
