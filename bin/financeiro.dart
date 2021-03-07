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
  print('2- Registrar a cotação de hoje');

  String option = stdin.readLineSync();

  switch(int.parse(option)) {
    case 1: today(); break;
    case 2: registerData(); break;
    default: print('\n\nOpcoes invalida. Selecione uma opcao valida\n\n'); break;
  }

}

registerData() async {
   var hgData = await getData();
   dynamic fileData = readFile();
   
   fileData = (fileData != null && fileData.length > 0 ? json.decode(fileData) : []);

   bool exists = false;

   fileData.forEach((data) {
     if(data['date'] == now())
       exists = true;
   });

   if(!exists) {
     fileData.add({"date": now(), "data": "${hgData['data']}"});

     Directory dir = Directory.current;
     File file = new File(dir.path + '/meu_arquivo.txt');
     RandomAccessFile raf = file.openSync(mode: FileMode.write);

     raf.writeStringSync(json.encode(fileData).toString());
     raf.flushSync();
     raf.closeSync();

     print('\n\n############### Dados salvos com sucesso! ###############');
   }
   else
     print('\n\n############### Registro não adicionado, já existe um log financeiro de hoje cadastrado! ###############');
}

String readFile() {
  Directory dir = Directory.current;
  File file = new File(dir.path + '/meu_arquivo.txt');

  if(!file.existsSync()) {
    print('Arquivo não encontrado');
    return null;
  }

  return file.readAsStringSync();
}

today() async {
  var data = await getData();
  print('\n\n###################### HG Brasil - Cotação ######################');
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
    var gbp = data['GBP'];
    var ars = data['ARS'];
    var btc = data['BTC'];

    Map formatedData = Map();
    formatedData['date'] = now();
    formatedData['data'] =
        '${usd['name']}: ${usd['buy']} | '
        '${eur['name']}: ${eur['buy']} | '
        '${gbp['name']}: ${gbp['buy']} | '
        '${ars['name']}: ${ars['buy']} | '
        '${btc['name']}: ${btc['buy']}';

    return formatedData;
  } else
    throw('Falhou');
}

String now() {
  var now = DateTime.now();
  return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().padLeft(2, '0')}';
}
