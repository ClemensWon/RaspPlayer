
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Services/RestService.dart';

class DeviceOptionsScreen extends StatefulWidget {
@override
State<StatefulWidget> createState() => DeviceOptionsScreenState();
}

class DeviceOptionsScreenState extends State<DeviceOptionsScreen> {

  //variables which represents the values on the server
  double _serverVolume;
  String _serverPin;

  //variables which represents the values on the app
  String _pin;
  bool _allowMuting = true;
  bool _allowUpload = false;
  bool _limitAdding = false;
  double _skipPercentage = 20;
  double _mutingPercentage = 50;
  double _volumePercentage = 50;

  RestService _restService = new RestService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _serverPin = "4000";
    _serverVolume = 50;

    _pin = _serverPin;
    _volumePercentage = _serverVolume;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Options'),
      ),
      drawer: NavigationDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          margin:EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pin-Code",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(75,30),
                    //input field for the pin
                    child: TextFormField(
                      initialValue: _pin,
                      onFieldSubmitted: (newValue) {
                        _pin = newValue;
                      },
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusColor: Color.fromRGBO(0, 1, 49, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Align(
                child: Text(
                  'Volume',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              //slider to change the volume
              Slider(
                min: 0,
                max: 100,
                divisions: 20,
                label: _volumePercentage.toString() + "%",
                value: _volumePercentage.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    _volumePercentage = value;
                  });
                },
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Allow Upload",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  SizedBox(width: 20,),
                  Switch(value: _allowUpload, onChanged: (bool value) {
                    setState(() {
                      _allowUpload = value;
                    });
                  }),
                ],
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Limit adding of songs",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  SizedBox(width: 20,),
                  Switch(value: _limitAdding, onChanged: (bool value) {
                    setState(() {
                      _limitAdding = value;
                    });
                  }),
                ],
              ),
              //is only shown when user can only upload a limited amount of songs
              if (_limitAdding) Row(
                children: [
                  Text(
                    "Song Limit",
                  ),
                  SizedBox(width: 30),
                  SizedBox.fromSize(
                      child: TextFormField(
                        keyboardType: TextInputType.number, initialValue: '10',),
                      size: Size(100,20)
                  ),
                  Text(
                    "Song",
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Align(
                child: Text(
                  'Skip Percentage',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              Slider(
                min: 0,
                max: 100,
                divisions: 20,
                label: _skipPercentage.round().toString() + "%",
                value: _skipPercentage.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    _skipPercentage = value;
                  });
                },
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Allow Muting of User",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  SizedBox(width: 20,),
                  Switch(value: _allowMuting, onChanged: (bool value) {
                    setState(() {
                      _allowMuting = value;
                    });
                  }),
                ],
              ),
              if (_allowMuting) Divider(
                thickness: 2,
                height: 50,
              ),
              if (_allowMuting) Align(
                child: Text(
                  'Skip Percentage',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              if (_allowMuting) Slider(
                  value: _mutingPercentage.toDouble(),
                  min:0,
                  max:100,
                  divisions: 20,
                  label: _mutingPercentage.round().toString()+"%",
                  onChanged: (double value) {
                    setState(() {
                      _mutingPercentage = value;
                    });
                  }
              ),
              if (_allowMuting) SizedBox(height: 15),
              if (_allowMuting) Row(
                children: [
                  Text(
                    "Mute duration:",
                  ),
                  SizedBox(width: 30),
                  SizedBox.fromSize(
                      child: TextFormField(
                        keyboardType: TextInputType.number, initialValue: '10',),
                      size: Size(100,20)
                  ),
                  Text(
                    "min",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 1, 49, 1),
        child: Icon(
          Icons.save
        ),
        //if settings changed, send request to the server
        onPressed: () {
          if (_pin != _serverPin) {
            _restService.setSessionPin(_pin).then((newPin) {
              if (newPin != "") {
                _serverPin = newPin;
              }
            });
          }
          if (_volumePercentage != _serverVolume) {
            _restService.setVolume(_volumePercentage.floor()).then((newVolume) {

              if (newVolume != -1) {
                _serverVolume = newVolume.toDouble();
                /*ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Saved to Server'),
                    action: SnackBarAction(
                      label: 'Ok',
                      onPressed: () {
                      },
                    ),
                  ),
                );*/
              }
            });
          }

        },
      ),
    );
  }
}