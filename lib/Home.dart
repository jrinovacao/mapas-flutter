import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =  CameraPosition(
      target: LatLng(-23.563370, -46.652923),
      zoom: 16
  );



  Set<Marker> _marcadore = {};
  _onMapCreated(GoogleMapController googleMapController){

   _controller.complete( googleMapController );

  }

  _movimentarCamera()async{

   GoogleMapController googleMapController = await _controller.future;

   googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        _posicaoCamera
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


   _recuperarLocalizacaoAtual() async{


     Position position = await Geolocator().getCurrentPosition(
         desiredAccuracy: LocationAccuracy.high
     );


      setState(() {
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17
        );
        _movimentarCamera();
      });



    // print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());




   }

   _adicionarListenerLocalizacao(){

      var geolocator = Geolocator();
      var locationsOptions = LocationOptions(
         accuracy: LocationAccuracy.high,
        distanceFilter: 10
      );
      geolocator.getPositionStream(locationsOptions).listen((Position position){
        print("localizacao atual: " + position.toString());

        setState(() {
          _posicaoCamera = CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17
          );
          _movimentarCamera();
        });

      });

   }


  @override
  void initState() {
    super.initState();
    //_carregarMarcadores();
    _recuperarLocalizacaoAtual();
    //_adicionarListenerLocalizacao();
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
            initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
           myLocationEnabled: true,
          //markers: _marcadore,
        ),
      ),
    );
  }
}
