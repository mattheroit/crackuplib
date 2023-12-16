import "package:crackuplib/crackuplib.dart";

CrackUp crackUp = CrackUp();

void main() async {
  await crackUp.initCrackUp();

  var categories = crackUp.getCategoryList();
  await crackUp.getJokesFromCategory(categories[0]);
  var jokes = crackUp.getJokeMap();

  for (var category in categories) {
    print(category);
  }
  print("");

  for (var entry in jokes[categories[0]]!) {
    print(entry.title);
    print(entry.body);
  }
}
