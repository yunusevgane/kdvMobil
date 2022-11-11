import 'package:flutter/material.dart';

class anasayfa extends StatefulWidget {
  const anasayfa({Key? key}) : super(key: key);

  @override
  _anasayfaState createState() => _anasayfaState();
}

var kdvdahilrenk = const Color.fromARGB(255, 40, 52, 58);
var kdvharicrenk = const Color(0xff8C3037);

int kdvdurum = 1;
double kdvorani = 18;
double tutarim = 0;
double kdvoranim = kdvorani;

String b1 = "Tutar";
String b2 = "Toplam";

TextEditingController tutar = TextEditingController();
TextEditingController kdv = TextEditingController();
TextEditingController kdvtoplam = TextEditingController();
TextEditingController toplam = TextEditingController();

void hesapla() {
  if (kdvorani != 0) {
    kdvoranim = kdvorani;
  }

  if (kdvdurum == 1) {
    kdv.text = ((tutarim * kdvoranim) / 100).toStringAsFixed(2).toString();
    kdvtoplam.text = ((tutarim * kdvoranim) / 100).toStringAsFixed(2).toString();
    toplam.text =
        (tutarim + ((tutarim * kdvoranim) / 100)).toStringAsFixed(2).toString();
  } else {
    kdv.text = ((tutarim * kdvoranim) / 100).toStringAsFixed(2).toString();
    kdvtoplam.text = (tutarim - (tutarim / (1 + (kdvoranim / 100)))).toStringAsFixed(2).toString();
    toplam.text =
        (tutarim / (1 + (kdvoranim / 100))).toStringAsFixed(2).toString();
  }
}

class _anasayfaState extends State<anasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF455A64),
      body: SingleChildScrollView(
        // <-- wrap this around
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.28,
              child: Ink.image(
                image: const AssetImage('assets/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: tutar,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: b1,
                        labelStyle: const TextStyle(color: Color(0xffffffff)),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xFFFFFFFF),
                            )),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xffffffff),
                            ))),
                    textAlign: TextAlign.left,
                    onChanged: (value) => {
                      setState(() {
                        if (double.tryParse(value) == null) {
                          tutarim = 0;
                          kdvtoplam.text = "0";
                          toplam.text = "0";
                        } else {
                          tutarim = double.parse(value);
                          hesapla();
                        }
                      })
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: kdvtoplam,
                    enabled: false,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'KDV Tutarı',
                        labelStyle: TextStyle(color: Color(0xffffffff)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xFFFFFFFF),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xffffffff),
                            ))),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: toplam,
                    enabled: false,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: b2,
                        labelStyle: const TextStyle(color: Color(0xffffffff)),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xFFFFFFFF),
                            )),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xffffffff),
                            ))),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            b1 = "Toplam";
                            b2 = "Tutar";

                            kdvdurum = 0;
                            kdvdahilrenk = const Color(0xff8C3037);
                            kdvharicrenk =
                                const Color.fromARGB(255, 40, 52, 58);
                            hesapla();
                          });
                        },
                        child: (Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kdvdahilrenk,
                          ),
                          width: (MediaQuery.of(context).size.width * 0.5) - 40,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(child: Text("KDV DAHİL")),
                          ),
                        )),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            b1 = "Tutar";
                            b2 = "Toplam";
                            kdvdurum = 1;
                            kdvdahilrenk =
                                const Color.fromARGB(255, 40, 52, 58);
                            kdvharicrenk = const Color(0xff8C3037);
                            hesapla();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kdvharicrenk,
                          ),
                          width: (MediaQuery.of(context).size.width * 0.5) - 40,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(child: Text("KDV HARİÇ")),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (kdvorani == 0)
                    const SizedBox(
                      height: 20,
                    ),
                  if (kdvorani == 0)
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'KDV Oranı',
                          labelStyle: TextStyle(color: Color(0xffffffff)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                color: Color(0xFFFFFFFF),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                color: Color(0xffffffff),
                              ))),
                      onChanged: (value) => {
                        setState(() {
                          if (double.tryParse(value) == null) {
                          } else {
                            kdvoranim = double.parse(value);
                            hesapla();
                          }
                        })
                      },
                      textAlign: TextAlign.left,
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            kdvorani = 1;
                            hesapla();
                          });
                        },
                        child: Column(
                          children: [
                            if (kdvorani == 1)
                              const Icon(
                                Icons.radio_button_checked,
                                size: 34.0,
                              ),
                            if (kdvorani != 1)
                              const Icon(
                                Icons.radio_button_off,
                                size: 34.0,
                              ),
                            const Text("%1",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            kdvorani = 8;
                            hesapla();
                          });
                        },
                        child: Column(
                          children: [
                            if (kdvorani == 8)
                              const Icon(
                                Icons.radio_button_checked,
                                size: 34.0,
                              ),
                            if (kdvorani != 8)
                              const Icon(
                                Icons.radio_button_off,
                                size: 34.0,
                              ),
                            const Text("%8",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            kdvorani = 18;
                            hesapla();
                          });
                        },
                        child: Column(
                          children: [
                            if (kdvorani == 18)
                              const Icon(
                                Icons.radio_button_checked,
                                size: 34.0,
                              ),
                            if (kdvorani != 18)
                              const Icon(
                                Icons.radio_button_off,
                                size: 34.0,
                              ),
                            const Text("%18",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            kdvorani = 0;
                            hesapla();
                          });
                        },
                        child: Column(
                          children: [
                            if (kdvorani == 0)
                              const Icon(
                                Icons.radio_button_checked,
                                size: 34.0,
                              ),
                            if (kdvorani != 0)
                              const Icon(
                                Icons.radio_button_off,
                                size: 34.0,
                              ),
                            const Text("?",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
