import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  const ImageInput(this.onSelectedImage, {super.key});

  final Function onSelectedImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    //instancia responsavel por capturar ou selecionar da galeria
    final ImagePicker picker = ImagePicker();
    // recebe a imagem que vem da camera com tamanho máximo limitado
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);

    //chega se o usuario bateu a foto ou voltou sem terminar
    if (imageFile == null) return;

    //atualiza para amostrar a imagem no preview, neste momento a imagem está no cache
    setState(() {
      _storedImage = File(imageFile.path);
    });

    //pega o diretório (o caminho) aonde o app guarda arquivos de forma persistente
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    //separa apenas o nome do arquivo do path de _storedImage
    String fileName = path.basename(_storedImage!.path);
    //salva uma cópia do arquivo dentro do diretório com o nome do arquivo
    final savadeImage = await _storedImage!.copy('${appDir.path}/$fileName');
    //chama a função do widget pai enviando o arquivo
    widget.onSelectedImage(savadeImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Text('Nenhuma Imagem'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: const Icon(Icons.camera),
            label: Text(
              'Tirar Foto',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
