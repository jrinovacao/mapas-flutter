import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadore = {};
  _onMapCreated(GoogleMapController googleMapController){

   _controller.complete( googleMapController );

  }

  _movimentarCamera()async{

   GoogleMapController googleMapController = await _controller.future;

   googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(-30.086764, -51.045771),
          zoom: 16,
          tilt: 0,
          bearing: 30
        )
      )
   );

  }

  _carregarMarcadores(){

    Set<Marker> marcadoresLocal = {};

    Marker marcadorShopping = Marker(
        markerId: MarkerId("marcador-shopping"),
        position: LatLng(-23.563370, -46.652923),
      infoWindow: InfoWindow(
        title: "Shopping Cidade de São Paulo"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
         BitmapDescriptor.hueMagenta
      ),
      onTap: (){
          print("Shopping clicado!");
      }
    );

    Marker marcadorCartorio = Marker(
        markerId: MarkerId("marcador-cartorio"),
        position: LatLng(-23.562868, -46.655874),
        infoWindow: InfoWindow(
        title: "12 Cartorio de notas"
       ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure
      ),
      //rotation: 45
    );

    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcadorCartorio);


    setState(() {
      _marcadore = marcadoresLocal;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarMarcadores();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapas e geolocalização"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
          onPressed: _movimentarCamera,
      ),
      body: Container(
        child: GoogleMap(
          //mapType: MapType.satellite,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(-23.563370, -46.652923),
              zoom: 16
            ),
          onMapCreated: _onMapCreated,
          markers: _marcadore,
        ),
      ),
    );
  }
}
