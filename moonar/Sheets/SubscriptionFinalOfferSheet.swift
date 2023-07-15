//
//  SubscriptionFinalOfferSheet.swift
//  moonar
//
//  Created by Владислав Калиниченко on 14.08.2022.
//

import SwiftUI
import StoreKit

struct SubscriptionFinalOfferSheet: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var storeController: Subscription
	
	var daysRemained: Int

	@State var isMonthly = true
	@State var showAlert = false
	@State var Dismiss = false
	
//	product: Product.products(for: ProductIdentifiers)[isMonthly ? 0 : 2]
	
	@MainActor
	func purchase() async {
		do {
			if try await storeController.purchase(productID: isMonthly ? ProductIdentifiers[0] : ProductIdentifiers[1]) != nil {
				storeController.isUserSubscribed = true
				
				Dismiss = true
				
				return
			}
		} catch Subscription.StoreError.failedVerification {
			showAlert = true
		} catch {
			print("Failed purchase: \(error)")
		}
	}
	
	var body: some View {
		ZStack {
			Background(color: Color.black)
			
			ScrollView(showsIndicators: false) {
				VStack {
					VStack(alignment: .leading, spacing: 0) {
						HStack {
							Text(daysRemained <= 0 ? "Your trial has ended" : "Talk with moonar whenever you want")
								.gradientForeground(gradient: whiteGradient)
								.font(.system(size: 30).weight(.bold))
								.padding(20)
								.padding(.top, 20)
							
							Spacer()
						}
						
						HStack {
							Spacer()
							
							Text("Get moonar access for just \(isMonthly ? 16 : 10) cents each day")
								.gradientForeground(gradient: greenGradient)
								.font(.system(size: 30).weight(.bold))
								.multilineTextAlignment(.trailing)
								.padding(20)
						}
						
						HStack {
							Button(action: {
								withAnimation(.linear(duration: 0.1)) {
									isMonthly = true
								}
							}) {
								ZStack(alignment: .topLeading) {
									RoundedRectangle(cornerRadius: 15)
										.strokeBorder(lineWidth: 8)
										.gradientForeground(gradient: isMonthly ? greenGradient : whiteGradient)
										.background(Color.black)
									
									VStack(alignment: .leading) {
										Text("Monthly")
											.gradientForeground(gradient: whiteGradient)
											.font(.system(size: 30).weight(.heavy))
											.padding([.horizontal, .top], 20)
											.padding(.bottom, 8)
										
										Text("for $4.99")
											.gradientForeground(gradient: whiteGradient)
											.font(.system(size: 25).weight(.medium))
											.padding(.horizontal, 20)
									}
								}
							}
							.buttonStyle(OnTapButtonState(newTextColor: Color.white))
							
							Button(action: {
								withAnimation(.linear(duration: 0.1)) {
									isMonthly = false
								}
							}) {
								ZStack(alignment: .topLeading) {
									RoundedRectangle(cornerRadius: 15)
										.strokeBorder(lineWidth: 8)
										.gradientForeground(gradient: isMonthly ? whiteGradient : greenGradient)
										.background(Color.black)
									
									VStack(alignment: .leading) {
										Text("Yearly")
											.gradientForeground(gradient: whiteGradient)
											.font(.system(size: 30).weight(.heavy))
											.padding([.horizontal, .top], 20)
											.padding(.bottom, 8)
										
										Text("for $39.99")
											.gradientForeground(gradient: whiteGradient)
											.font(.system(size: 25).weight(.medium))
											.padding(.horizontal, 20)
										
										Spacer()
										
										Text("Save 30%")
											.foregroundColor(Color.gray)
											.font(.system(size: 25).weight(.medium))
											.padding(20)
									}
								}
							}
							.buttonStyle(OnTapButtonState(newTextColor: Color.white))
						}
						.padding(20)
						
						Text("Your subscription auto-renews for \(isMonthly ? "$4.99/month" : "$39.99/year") until canceled")
							.foregroundColor(Color.white)
							.font(.system(size: 20).weight(.medium))
							.padding(20)
					}
					
					VStack(alignment: .center) {
						Button(action: storeController.restorePurchases) {
							Text("Restore purchases")
								.foregroundColor(greenColor)
								.font(.system(size: 20).weight(.medium))
								.padding(20)
						}
						
						Color(.clear)
							.frame(height: 250)
					}
				}
			}
			
			VStack{
				Spacer()
				
				InFormGradientButtonForm(
					color: greenGradient,
					textColor: Color.white,
					text: "Subscribe",
					action: {
						Task {
							await purchase()
						}
						
						
						if Dismiss {
							dismiss()
						}
					}
				)
			}
		}
		.interactiveDismissDisabled(daysRemained <= 0)
		.alert("Purchase failed", isPresented: $showAlert) {
			Button("Cancel", role: .cancel) {}
		}
	}
}

struct SubscriptionFinalOfferSheet_Previews: PreviewProvider {
    static var previews: some View {
		SubscriptionFinalOfferSheet(daysRemained: 7)
    }
}
