//
//  DatePickerForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 15.04.2022.
//

import SwiftUI

struct DatePickerForm: View {
	@Binding var birthDate: Date
	@Binding var color: Color
	@Binding var textColor: Color
	var action: () -> Void
	
	var body: some View {
		VStack {
			Spacer()
			HStack(spacing: 20) {
				ZStack {
					RoundedRectangle(cornerRadius: 15)
						.stroke(color, lineWidth: 7)
						.background(Color.black)
						.frame(height: 68, alignment: .center)
					HStack {
						Spacer()
						DatePicker("", selection: $birthDate, in: ...Date(), displayedComponents: .date)
							.labelsHidden()
							.datePickerStyle(.compact)
						Spacer()
					}
				}
				.padding(.leading, 20)
				
				Button(action: action) {
					HStack {
						Spacer()
						Image(systemName: "arrow.up")
							.font(.title.weight(.bold))
							.frame(width: 30, height: 30)
						Spacer()
					}
					.padding(.vertical, 20)
					.background(color)
				}
				.foregroundColor(textColor)
				.cornerRadius(15)
				.buttonStyle(OnTapButtonState(newTextColor: textColor))
				.padding(.trailing, 20)
			}
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 0)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.shadow(color: Color.black, radius: 50, x: 0, y: 150)
			.fixedSize(horizontal: false, vertical: true)
		}
		.transition(.move(edge: .bottom).combined(with: .opacity))
		.zIndex(4)
	}
}

struct DatePickerForm_Previews: PreviewProvider {
	static var previews: some View {
		DatePickerForm(birthDate: .constant(Date()), color: .constant(Color.white), textColor: .constant(Color.black), action: { () -> Void in })
	}
}
