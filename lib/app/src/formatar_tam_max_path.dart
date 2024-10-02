String formatarTamMaxPath(String path) {
  if (path.length > 10) {
    path = '${path.substring(0, 10)}..';
  }
  return path;
}
