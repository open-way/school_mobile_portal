import 'package:flutter/cupertino.dart';

class TerminosCondiciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle styleTitle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final TextStyle styleSubTitle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    final TextStyle styleContenido = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    final String anhoEscolar = '2021';

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '''CONDICIONES DEL PROCESO DE RESERVA DE MATRÍCULA $anhoEscolar
            ''',
            style: styleTitle,
          ),
          Text(
            '''La Asociación de la Iglesia Adventista del 
Septimo día Peruana del Norte (IASD NORTE).1, 
es la Entidad Promotora de la red de Colegios 
Adventistas (en adelante la “Promotora”), en 
cumplimiento de las disposiciones legales 
vigentes y con el propósito que los padres de 
familia dispongan de toda la información respecto 
a las condiciones del proceso de admisión para 
el año escolar $anhoEscolar, ponen en conocimiento 
la siguiente información:''',
            style: styleContenido,
          ),
          Text(
            '''I.	EL PROCEDIMIENTO DE RESERVA 2021 CONSISTE EN LO SIGUIENTE
            ''',
            style: styleSubTitle,
          )
        ],
      ),
    );
  }
}
