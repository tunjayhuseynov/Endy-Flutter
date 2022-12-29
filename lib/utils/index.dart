const mainColor = 0xfff03034;
const mainColorHex = "#f03034";

bool? validationWithEmpty(String text, {int num = 3}) {
  if (text.length < num && text.isNotEmpty) return true;
  return null;
}

bool? validation(String text, {int num = 3}) {
  if (text.length < num) return true;
  return null;
}

bool? repeatPasswordValidation(String password, String repeatPass) {
  if (password != repeatPass && repeatPass.isNotEmpty) return true;
  return null;
}
