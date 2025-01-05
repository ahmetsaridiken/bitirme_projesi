import 'package:flutter/material.dart';

class AyarlarScreen extends StatefulWidget {
  @override
  _AyarlarScreenState createState() => _AyarlarScreenState();
}

class _AyarlarScreenState extends State<AyarlarScreen> {
  final Map<String, bool> _yasKategorileri = {
    '6-12 ay': false,
    '12-24 ay': false,
    '24-36 ay': false,
    '3-5 yaş': false,
    '6-8 yaş': false,
    '8-10 yaş': false,
    '12-15 yaş': false,
  };

  final Map<String, bool> _hayvanlar = {
    'Tilki': false,
    'Aslan': false,
    'Tavşan': false,
    'Kurt': false,
    'Fare': false,
    'Kedi': false,
    'Köpek': false,
    'Kaplumbağa': false,
    'Horoz': false,
    'Ayı': false,
    'Tavuk': false,
    'At': false,
    'Balık': false,
    'Baykuş': false,
    'Eşek': false,
    'Kaplan': false,
    'Ördek': false,
    'Maymun': false,
  };

  final Map<String, bool> _ilgiAlanlari = {
    'Müzik': false,
    'Spor': false,
    'Sanat': false,
    'Bilim': false,
    'Oyunlar': false,
    'Hayvanlar': false,
    'Süper Kahramanlar': false,
    'Arabalar': false,
    'Barbie': false,
  };

  final Map<String, bool> _temalar = {
    'Aile': false,
    'Arkadaşlık': false,
    'Cesaret': false,
    'Cömertlik': false,
    'Doğa ve Çevre': false,
    'Bilim ve Macera': false,
    'Aile Büyüklerini Dinleme': false,
  };

  String _masalOzeti = '';
  bool _isDescriptionSubmitted = false;

  void _onItemChanged(String key, Map<String, bool> map) {
    if (_isDescriptionSubmitted) {
      setState(() {
        map[key] = !(map[key] ?? false);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Önce açıklamayı onaylayın!')),
      );
    }
  }

  Widget _buildSelectableTile(String title, bool isSelected, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.blue,
          borderRadius: BorderRadius.circular(12.0),
        ),
        width: (MediaQuery.of(context).size.width - 64) / 3,
        height: (MediaQuery.of(context).size.width - 64) / 3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontFamily: 'CustomFont',
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  onTap();
                },
                activeColor: Colors.yellow,
                checkColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmitDescription() {
    setState(() {
      _isDescriptionSubmitted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Açıklama onaylandı!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ailehayvan.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AÇIKLAMA',
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Oluşturmak istediğiniz masalı kısaca özetleyiniz...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _masalOzeti = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _masalOzeti.isNotEmpty ? _onSubmitDescription : null,
                    child: Text('Tamam'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ExpansionTile(
                title: Text(
                  'YAŞ KATEGORİLERİ',
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                  ),
                ),
                leading: Icon(Icons.calendar_today),
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: _yasKategorileri.keys.map((kategori) {
                      return _buildSelectableTile(
                        kategori,
                        _yasKategorileri[kategori]!,
                        () => _onItemChanged(kategori, _yasKategorileri),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ExpansionTile(
                title: Text(
                  'SEVİLEN HAYVANLAR',
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                  ),
                ),
                leading: Icon(Icons.pets),
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: _hayvanlar.keys.map((hayvan) {
                      return _buildSelectableTile(
                        hayvan,
                        _hayvanlar[hayvan]!,
                        () => _onItemChanged(hayvan, _hayvanlar),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ExpansionTile(
                title: Text(
                  'İLGİ ALANLARI',
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                  ),
                ),
                leading: Icon(Icons.interests),
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: _ilgiAlanlari.keys.map((ilgi) {
                      return _buildSelectableTile(
                        ilgi,
                        _ilgiAlanlari[ilgi]!,
                        () => _onItemChanged(ilgi, _ilgiAlanlari),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ExpansionTile(
                title: Text(
                  'TEMALAR',
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                  ),
                ),
                leading: Icon(Icons.palette),
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: _temalar.keys.map((tema) {
                      return _buildSelectableTile(
                        tema,
                        _temalar[tema]!,
                        () => _onItemChanged(tema, _temalar),
                      );
                    }).toList(),
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