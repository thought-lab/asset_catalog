import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokemon/pokemon.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isAppear = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: _buildPokemon(),
              ),
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: _buildDescription(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemon() {
    if (_isAppear) {
      return const RandomPokemon();
    }

    return InkWell(
      onTap: _toogle,
      borderRadius: BorderRadius.circular(200),
      child: Image.asset(
        'assets/images/pokeball.png',
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildDescription() {
    if (_isAppear) {
      return Center(
        child: InkWell(
          onTap: _toogle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Reset',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/icons/ic_reset.svg',
                  height: 14,
                  width: 14,
                )
              ],
            ),
          ),
        ),
      );
    }

    return const Text(
      'Tap pokeball to bring out random pokemon',
      textAlign: TextAlign.center,
    );
  }

  void _toogle() {
    setState(() {
      _isAppear = !_isAppear;
    });
  }
}
