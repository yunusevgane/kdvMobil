import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

var kdvDahilRenk = const Color.fromARGB(255, 40, 52, 58);
var kdvHaricRenk = const Color(0xff8C3037);

int kdvDurum = 1;
double kdvOrani = 20;
double tutar = 0;
double kdvOranInput = kdvOrani;

String label1 = "Tutar";
String label2 = "Toplam";

TextEditingController tutarController = TextEditingController();
TextEditingController kdvController = TextEditingController();
TextEditingController kdvToplamController = TextEditingController();
TextEditingController toplamController = TextEditingController();

class _AnasayfaState extends State<Anasayfa> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    tutarController.dispose();
    kdvController.dispose();
    kdvToplamController.dispose();
    toplamController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  void hesapla() {
    setState(() {
      _isCalculating = true;
    });

    try {
      if (kdvOrani != 0) {
        kdvOranInput = kdvOrani;
      }

      if (tutar <= 0) {
        _showSnackBar('Lütfen geçerli bir tutar giriniz');
        return;
      }

      if (kdvDurum == 1) {
        kdvController.text = ((tutar * kdvOranInput) / 100).toStringAsFixed(2);
        kdvToplamController.text = ((tutar * kdvOranInput) / 100).toStringAsFixed(2);
        toplamController.text = (tutar + ((tutar * kdvOranInput) / 100)).toStringAsFixed(2);
      } else {
        kdvController.text = ((tutar * kdvOranInput) / 100).toStringAsFixed(2);
        kdvToplamController.text = (tutar - (tutar / (1 + (kdvOranInput / 100)))).toStringAsFixed(2);
        toplamController.text = (tutar / (1 + (kdvOranInput / 100))).toStringAsFixed(2);
      }

      _controller.forward(from: 0.0);
    } catch (e) {
      _showSnackBar('Hesaplama sırasında bir hata oluştu');
    } finally {
      setState(() {
        _isCalculating = false;
      });
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isEnabled,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: isEnabled,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          border: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white60,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white60,
            size: 22,
          ),
          suffixIcon: isEnabled ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.white60),
            onPressed: () {
              controller.clear();
              setState(() {
                tutar = 0;
                hesapla();
              });
            },
          ) : null,
        ),
        validator: isEnabled ? (value) {
          if (value == null || value.isEmpty) {
            return 'Bu alan boş bırakılamaz';
          }
          if (double.tryParse(value) == null) {
            return 'Geçerli bir sayı giriniz';
          }
          return null;
        } : null,
      ),
    );
  }

  Widget _buildModeButton(String text, int mode) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (mode == 0) {
              label1 = "Toplam";
              label2 = "Tutar";
              kdvDurum = 0;
            } else {
              label1 = "Tutar";
              label2 = "Toplam";
              kdvDurum = 1;
            }
            hesapla();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: kdvDurum == mode ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: kdvDurum == mode ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKDVButton(double rate, String label) {
    final isSelected = kdvOrani == rate;
    return ScaleTransition(
      scale: isSelected ? Tween(begin: 1.0, end: 1.1).animate(_controller) : const AlwaysStoppedAnimation(1.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            kdvOrani = rate;
            hesapla();
          });
          HapticFeedback.lightImpact();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF8C3037) : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(
                color: const Color(0xFF8C3037).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8C3037), Color(0xFF455A64)],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              const Text(
                                "KDV Hesaplama",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 24),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildModeButton("KDV DAHİL", 0),
                                    _buildModeButton("KDV HARİÇ", 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              _buildInputField(
                                controller: tutarController,
                                label: label1,
                                icon: Icons.account_balance_wallet,
                                isEnabled: true,
                                onChanged: (value) {
                                  setState(() {
                                    if (double.tryParse(value) == null) {
                                      tutar = 0;
                                      kdvToplamController.text = "0";
                                      toplamController.text = "0";
                                    } else {
                                      tutar = double.parse(value);
                                      hesapla();
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: kdvToplamController,
                                label: "KDV Tutarı",
                                icon: Icons.calculate,
                                isEnabled: false,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                controller: toplamController,
                                label: label2,
                                icon: Icons.payments,
                                isEnabled: false,
                              ),
                              if (kdvOrani == 0) ...[
                                const SizedBox(height: 16),
                                _buildInputField(
                                  controller: TextEditingController(),
                                  label: "KDV Oranı",
                                  icon: Icons.percent,
                                  isEnabled: true,
                                  onChanged: (value) {
                                    setState(() {
                                      if (double.tryParse(value) != null) {
                                        kdvOranInput = double.parse(value);
                                        hesapla();
                                      }
                                    });
                                  },
                                ),
                              ],
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "KDV Oranı Seçin",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: [
                                        _buildKDVButton(1, "%1"),
                                        _buildKDVButton(8, "%8"),
                                        _buildKDVButton(18, "%18"),
                                        _buildKDVButton(20, "%20"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
