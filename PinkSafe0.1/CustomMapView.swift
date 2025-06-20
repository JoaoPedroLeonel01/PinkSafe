////
////  CustomMapView.swift
////  PinkSafe0.1
////
////  Created by Joao pedro Leonel on 20/06/25.
////
//
//import SwiftUI
//import MapKit
//
//struct CustomMapView: UIViewRepresentable {
//    @Binding var mapType: MKMapType
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .follow
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        uiView.mapType = mapType
//    }
//}
