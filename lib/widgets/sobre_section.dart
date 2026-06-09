import 'package:flutter/material.dart';

class SobreSection extends StatelessWidget {
  const SobreSection({super.key});

  static const _blue = Color(0xFF006DA6);
  static const _orange = Color(0xFFFF751F);

  static const _highlight = TextStyle(color: _orange);

  @override
  Widget build(BuildContext context) {
    const imageRadius = 12.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _blue,
            _blue.withValues(alpha: 0.5),
          ],
          stops: const [0.6, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SOBRE',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              textAlign: TextAlign.justify,
              const TextSpan(
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(text: 'O AdotaRec é uma '),
                  TextSpan(text: 'plataforma', style: _highlight),
                  TextSpan(
                    text:
                        ' que conecta animais a lares responsáveis, permitindo que ONGs e protetores cadastrem pets para ampliar suas chances de ',
                  ),
                  TextSpan(text: 'adoção.', style: _highlight),
                  TextSpan(
                    text:
                        ' Unindo tecnologia e empatia, o projeto também traz o ',
                  ),
                  TextSpan(text: 'PETKIDS,', style: _highlight),
                  TextSpan(text: ' um '),
                  TextSpan(text: 'game 3D', style: _highlight),
                  TextSpan(text: ' onde crianças simulam os '),
                  TextSpan(text: 'cuidados', style: _highlight),
                  TextSpan(
                    text:
                        ' com um animal, ajudando pais a avaliarem a maturidade dos filhos antes de uma adoção real. É a tecnologia a serviço da ',
                  ),
                  TextSpan(text: 'adoção consciente.', style: _highlight),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(imageRadius),
                border: Border.all(color: _orange, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(imageRadius - 3),
                child: Image.asset(
                  'assets/images/5-cuidados-para-quem-tem-ou-pretende-adotar-um-gato.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
