import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

main() {
  menu();
}

void menu(){
  print('########### Inicio ###############');
  print('\nSelecione uma das opcoes abaixo');
  print('1 - Ver a cotacao de hoje');

  String option = stdin.readLineSync();

  switch(int.parse(option)) {
    case 1: today(); break;
    default: print('\n\nOpcoes invalida. Selecione uma opcao valida\n\n'); break;
  }

}

today() async {
  var data = await getData();
  print('\n\n###################### HG Brasil - Cotacao ######################');
  print('${data['date']} -> ${data['data']}');
}

Future getData() async {
  String url = 'https://api.hgbrasil.com/finance?key=3b7c61b0';
  http.Response response = await http.get(url);

  if(response.statusCode  == 200) {
    var data = json.decode(response.body)['results']['currencies'];
    print(data);
    var usd = data['USD'];
    var eur = data['EUR'];

    Map formatedData = Map();
    formatedData['date'] = '25/01/2019'; //now();
    formatedData['data'] = '${usd['name']}: ${usd['buy']} | ${eur['name']}: ${eur['buy']}';

    return formatedData;

  } else {
    throw('Falhou');
  }

}