String limparNomeArquivo(String nomeOriginal) {
  // Caracteres inválidos no Windows
  final invalidChars = RegExp(r'[<>:"/\\|?*]');

  // Substituir caracteres inválidos por '_'
  String nomeLimpo = nomeOriginal.replaceAll(invalidChars, '_');

  // Limitar o comprimento do nome do arquivo (máximo de 255 caracteres no Windows)
  if (nomeLimpo.length > 255) {
    nomeLimpo = nomeLimpo.substring(0, 255);
  }

  return nomeLimpo;
}