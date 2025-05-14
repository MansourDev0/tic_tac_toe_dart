// الالوان التي سنستخدمها في المصفوفة
const red = '\x1B[31m';
const blue = '\x1B[34m';
const reset = '\x1B[0m';
const gray = '\x1B[38;5;240m';

void printBoard(List<List<String>> board) {
  print('');
  for (int i = 0; i < 3; i++) {
    // يتم تجميع الصف هنا في كل دورة
    String row = '';

    for (int j = 0; j < 3; j++) {
      String value = board[i][j];
      String display;

      if (value == 'X') {
        display = '$red X $reset';
      } else if (value == 'O') {
        display = '$blue O $reset';
      } else {
        // اذا كان لا يوجد رمز يتم حساب قيمة الرقم الموجود
        int number = i * 3 + j + 1;
        display = '$gray $number $reset';
      }
      // اضافة القيمة الى الصف
      // يتم تجميع القيم هنا ورسم الخطوط
      row += display;
      // هيك مثال لنتيجة صف
      // 1 | X | 3
      // فحص اذا كان اخر الصف
      if (j < 2) row += '|';
    }
    print(row);
    if (i < 2) print('---+---+---');
  }
  print('');
}
