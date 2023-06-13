//
//  MapView.swift
//  InToTheSeoul
//
//  Created by KimTaeHyung on 2023/06/04.
//

import CoreLocation
import MapKit
import SwiftUI

extension MKMapView: ObservableObject { }

struct MapView: UIViewRepresentable {
    @Binding var mkMapView: MKMapView
    @Binding var showUserLocation: Bool
    
    @Binding var userLocation: CLLocationCoordinate2D?
    
    @Binding var region: MKCoordinateRegion
    
    @Binding var span: MKCoordinateSpan
    
    @Binding var toVisitPointIndex: Int
    
    @EnvironmentObject var pointsModel: PointsModel
    
//    @ObservedObject var viewPoint: ViewPoint
    
    //UIViewRepresentable이 만들 View에 대한 정의를 해줘야 함
    typealias UIViewType = MKMapView

    //MapViewCoordinator가 coordinator임을 알려줘야 함
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(userLocation: $userLocation, region: $region, span: $span)
    }
    

    func makeUIView(context: Context) -> MKMapView {
        let mapView = mkMapView
        // 어노테이션 초기화
        mapView.removeAnnotations(mapView.annotations)
        
        
        //MapViewCoordinator에게 delegate 위임
        mapView.delegate = context.coordinator
        
        //MARK: - 현재 위치 표시
        mapView.showsUserLocation = showUserLocation

        //유저 위치 설정
        mapView.showsUserLocation = true
        
        
        
        //MARK: - region 설정

        //region을 기준으로 map setting
        mapView.setRegion(region, animated: true)
        
        // MARK: - JSON을 통해 불러온 데이터 어노테이션 추가
        mapView.register(MapAnnotationView.self, forAnnotationViewWithReuseIdentifier: "annotation")
        
        //MARK: - 여러 경로

        let pointMarkers: [ViewPoint] = pointsModel.selectedPoints
        print("제발 \(pointMarkers[0].nowPoint)")

        print("확인하기 --- \(pointsModel.selectedPoints[toVisitPointIndex+1].nowPoint)")

        var start = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(pointsModel.selectedPoints[toVisitPointIndex].nowPoint.lat)!, longitude: Double(pointsModel.selectedPoints[toVisitPointIndex].nowPoint.lon)!))

        var next = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(pointsModel.selectedPoints[toVisitPointIndex+1].nowPoint.lat)!, longitude: Double(pointsModel.selectedPoints[toVisitPointIndex+1].nowPoint.lon)!))

        var placemarks = [MKPlacemark]()

        for i in 0..<Int(pointsModel.selectedPoints.count) {
            placemarks.append(MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(pointsModel.selectedPoints[i].nowPoint.lat)!, longitude: Double(pointsModel.selectedPoints[i].nowPoint.lon)!)))
        }

        print("APPEND \(placemarks)")

        //pointsModel.selectedPoint
        var directions: [MKDirections] = []

//        for i in 0..<placemarks.count {
//            let request = MKDirections.Request()
//
//            // 출발지와 목적지 설정
//            request.source = MKMapItem(placemark: placemarks[i])
//            request.destination = MKMapItem(placemark: placemarks[(i+1) % placemarks.count])
//
////            request.source = MKMapItem(placemark: start)
////            request.destination = MKMapItem(placemark: next)
//
//
//            // 경로 옵션 설정
//            request.requestsAlternateRoutes = true
//            request.transportType = .walking
//
//            let directionsRequest = MKDirections(request: request)
//            directions.append(directionsRequest)
//            print("directions --> \(directions)")
//        }


        var request = MKDirections.Request()
        request.source = MKMapItem(placemark: placemarks[toVisitPointIndex])
        request.destination = MKMapItem(placemark: placemarks[toVisitPointIndex+1])
        request.requestsAlternateRoutes = true
        request.transportType = .walking

        let directionsRequest = MKDirections(request: request)
        directions.append(directionsRequest)
        print("directions --> \(directions)")

//        for direction in directions {
//            direction.calculate { response, error in
//                guard let route = response?.routes.first else { return }
//                mapView.addOverlay(route.polyline)
//            }
//        }

        
        
//        //MARK: - 시작점
//        let start = MKPointAnnotation()
//        start.coordinate = placemarks.first!.coordinate
//
//        let annotationView = MKMarkerAnnotationView(annotation: start, reuseIdentifier: "startAnnotation")
//        annotationView.markerTintColor = .black // Set the desired color for the annotation
//
//        mapView.addAnnotation(annotationView.annotation!) // Add the customized annotation view to the mapView
        
        
        // p1, p2, p3에 어노테이션 찍기
        mapView.addAnnotations(pointsModel.annotationPoints)
        
        print("----> MapView 어노테이션들 \(mapView.annotations)")
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.setNeedsDisplay()
        
        
//        print(pointsModel.annotationPoints.first?.viewPoint)
//
//        print("업데이트 --> \(pointsModel.selectedPoints[toVisitPointIndex])")

        //MARK: - 여러 경로

        let pointMarkers: [ViewPoint] = pointsModel.selectedPoints
        print("제발 \(pointMarkers[0].nowPoint)")

        var placemarks = [MKPlacemark]()

        for i in 0..<Int(pointsModel.selectedPoints.count) {
            placemarks.append(MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(pointsModel.selectedPoints[i].nowPoint.lat)!, longitude: Double(pointsModel.selectedPoints[i].nowPoint.lon)!)))
        }

        
        print("APPEND \(placemarks)")

        //pointsModel.selectedPoint
        var directions: [MKDirections] = []
        
        var request = MKDirections.Request()
        
        
        
        if toVisitPointIndex == 0 {
            request.source = MKMapItem(placemark: placemarks[placemarks.count-1])
            request.destination = MKMapItem(placemark: placemarks[toVisitPointIndex])
        } else if toVisitPointIndex == placemarks.count {
            request.source = MKMapItem(placemark: placemarks[toVisitPointIndex])
            request.destination = MKMapItem(placemark: placemarks[placemarks.count - 1])
        } else {
            request.source = MKMapItem(placemark: placemarks[toVisitPointIndex - 1])
            request.destination = MKMapItem(placemark: placemarks[toVisitPointIndex])
        }
        request.requestsAlternateRoutes = true
        request.transportType = .walking

        let directionsRequest = MKDirections(request: request)
        directions.append(directionsRequest)
        print("directions --> \(directions)")
        print("to visit \(toVisitPointIndex)")

        
        for direction in directions {
            direction.calculate { response, error in
                guard let route = response?.routes.first else { return }
                mkMapView.removeOverlays(mkMapView.overlays)
                mkMapView.addOverlay(route.polyline)
                
                
                // Overlay를 그리는 MKPolylineRenderer 생성
                let renderer = MKPolylineRenderer(overlay: route.polyline)
                
                // Overlay의 색상 설정
                renderer.strokeColor = UIColor(Color.theme.green2)
                
                // 다른 속성들을 필요에 따라 설정
                
                // MKMapView에서 기존의 Renderer 가져오기
                if let oldRenderer = mkMapView.renderer(for: route.polyline) as? MKPolylineRenderer {
                    // 기존 Renderer의 속성을 업데이트
                    oldRenderer.strokeColor = renderer.strokeColor
                    mkMapView.setNeedsDisplay()
                } else {
                    // 기존 Renderer가 없는 경우, 새로운 Renderer로 추가
                    mkMapView.addOverlay(route.polyline)
                }
                
            }
        }
    }
    
    
    
    //MARK: - Coordinator 역할 (Delegate)
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        
        //MARK: - 위치에 대한 변수
        var locationManager: CLLocationManager?

        @Binding var userLocation: CLLocationCoordinate2D?
        
        @Binding var region: MKCoordinateRegion
        
        @Binding var span: MKCoordinateSpan
        
        init(userLocation: Binding<CLLocationCoordinate2D?>, region: Binding<MKCoordinateRegion>, span: Binding<MKCoordinateSpan>) {
            _userLocation = userLocation
            _region = region
            _span = span
            super.init()
            checkIfLocationServicesIsEnabled()
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            region = mapView.region
            span = mapView.region.span // Update the span binding when the region changes
        }
        
        //MARK: - 현재 위치 관련
        
        func checkIfLocationServicesIsEnabled() {
            if CLLocationManager.locationServicesEnabled() {
                locationManager = CLLocationManager()
                locationManager!.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            } else {
                print("Show an alert")
            }
        }
                
        func checkLocationAuthorization() {
            guard let locationManager = locationManager else { return }
            
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted, likely due to parental controls.")
            case .denied:
                print("You have denied this app location permission. Go to Settings to change it.")
            case .authorizedAlways, .authorizedWhenInUse:
                let currentCoordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
                let span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta, longitudeDelta: region.span.longitudeDelta)
                region = MKCoordinateRegion(center: currentCoordinate, span: span)
                            
//                print("PPPPPPPPP \(currentCoordinate)")
//                print("region --- \(region)")
                
            @unknown default:
                break
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
        
        //MARK: - region 업데이트
        
        
        
        //MARK: - 경로 관련
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            
            return renderer
        }
        
        
        //MARK: - Annotation
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {
                return nil
            }

            print("변환 ㄱㄱ")
            if let annotation = annotation as? AnnotationPoint {
                if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? MapAnnotationView {
                    annotationView.setupUI(annotationStyle: annotation.annotationStyle, annotationId: 1, annotation: annotation)
                    print(annotationView)
                    return annotationView
                }
            }
            
            print("변환 실패 ㅠ")
            
//            if annotationView == nil {
//                //Create the View
//                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
//                annotationView?.canShowCallout = true
//
//            } else {
//                annotationView?.annotation = annotation
//            }
            
//            annotationView?.image = UIImage(named: "StartPoint")
            return nil
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            print("왓")
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}



