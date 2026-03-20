//
//  AccountView.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import SwiftUI
import CoreData

struct AccountView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var vm: AccountViewModel = AccountViewModel()
    @ObservedObject private var auth = AuthService.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                profileCard
                bookingOverviewCard
                hotelBookingsSection
                flightBookingsSection
                actionSection
                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.configure(holder: holder, context: context)
            vm.refreshUser()
            vm.loadBookings()
        }
        .onChange(of: auth.currentUser?.id) { _ in
            vm.refreshUser()
            vm.loadBookings()
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Account")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Manage your profile, bookings, and travel activity.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color("PrimaryColor").opacity(0.12))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: vm.isSignedIn ? "person.crop.circle.fill" : "person.crop.circle.badge.exclamationmark")
                        .font(.system(size: 28))
                        .foregroundStyle(Color("PrimaryColor"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.isSignedIn ? vm.fullName : "Guest User")
                        .font(.headline)
                    
                    Text(vm.isSignedIn ? vm.emailText : "Sign in to manage your trips and bookings.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            if vm.isSignedIn {
                Divider()
                
                HStack {
                    statItem(title: "Bookings", value: "\(vm.totalBookingsCount)")
                    Spacer()
                    statItem(title: "Hotels", value: "\(vm.hotelBookings.count)")
                    Spacer()
                    statItem(title: "Flights", value: "\(vm.flightBookings.count)")
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
    
    private var bookingOverviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Travel Activity")
                    .font(.headline)
                
                Spacer()
                
                if vm.isLoadingBookings {
                    ProgressView()
                        .scaleEffect(0.9)
                }
            }
            
            if let error = vm.bookingErrorMessage, vm.isSignedIn {
                Text(error)
                    .font(.subheadline)
                    .foregroundStyle(.red)
            } else if !vm.isSignedIn {
                Text("Sign in to see your hotel and flight bookings.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else if vm.totalBookingsCount == 0 {
                Text("You do not have any bookings yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text("View your latest hotel stays and flight reservations below.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
    
    private var hotelBookingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hotel Bookings")
                .font(.headline)
            
            if !vm.isSignedIn {
                emptyStateCard(
                    title: "No hotel bookings available",
                    subtitle: "Sign in to view your hotel reservations.",
                    systemImage: "bed.double.fill"
                )
            } else if vm.hotelBookings.isEmpty {
                emptyStateCard(
                    title: "No hotel bookings yet",
                    subtitle: "Your reserved stays will appear here.",
                    systemImage: "bed.double.fill"
                )
            } else {
                ForEach(vm.hotelBookings) { booking in
                    hotelBookingCard(booking)
                }
            }
        }
    }
    
    private var flightBookingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Flight Bookings")
                .font(.headline)
            
            if !vm.isSignedIn {
                emptyStateCard(
                    title: "No flight bookings available",
                    subtitle: "Sign in to view your flight reservations.",
                    systemImage: "airplane"
                )
            } else if vm.flightBookings.isEmpty {
                emptyStateCard(
                    title: "No flight bookings yet",
                    subtitle: "Your booked flights will appear here.",
                    systemImage: "airplane"
                )
            } else {
                ForEach(vm.flightBookings) { booking in
                    flightBookingCard(booking)
                }
            }
        }
    }
    
    @ViewBuilder
    private var actionSection: some View {
        if !vm.isSignedIn {
            NavigationLink {
                SignInView()
            } label: {
                Label("Sign In", systemImage: "person.crop.circle.badge.plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("PrimaryColor"))
        } else {
            Button(role: .destructive) {
                vm.logOut()
            } label: {
                Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func statItem(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private func emptyStateCard(title: String, subtitle: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(Color("PrimaryColor"))
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    private func hotelBookingCard(_ booking: HotelBooking) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.hotelName)
                        .font(.headline)
                    
                    Text(booking.city)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                statusBadge(booking.status.rawValue.capitalized)
            }
            
            Divider()
            
            HStack {
                Label(booking.roomType.capitalized, systemImage: "bed.double.fill")
                Spacer()
                Text("× \(booking.quantity)")
                    .fontWeight(.semibold)
            }
            .font(.subheadline)
            
            HStack {
                Label(
                    booking.checkInDate.formatted(date: .abbreviated, time: .omitted),
                    systemImage: "calendar"
                )
                
                Spacer()
                
                Text(booking.checkOutDate.formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            
            HStack {
                Text("Total")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(String(format: "$%.0f", booking.total))
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
    
    private func flightBookingCard(_ booking: FlightBooking) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.airlineName)
                        .font(.headline)
                    
                    Text("\(booking.departureCode) → \(booking.arrivalCode)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                statusBadge(booking.status.rawValue.capitalized)
            }
            
            Divider()
            
            HStack {
                Label(booking.cabinClass, systemImage: "airplane")
                Spacer()
                Text("× \(booking.passengerCount)")
                    .fontWeight(.semibold)
            }
            .font(.subheadline)
            
            if let departureTime = booking.departureTime {
                HStack {
                    Label(
                        departureTime.formatted(date: .abbreviated, time: .shortened),
                        systemImage: "clock"
                    )
                    
                    Spacer()
                }
                .font(.subheadline)
            }
            
            HStack {
                Text("Total")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(String(format: "$%.0f", booking.total))
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
    
    private func statusBadge(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color("PrimaryColor").opacity(0.12))
            .foregroundStyle(Color("PrimaryColor"))
            .clipShape(Capsule())
    }
}

