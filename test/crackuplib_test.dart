import 'package:crackuplib/crackuplib.dart';
import 'package:test/test.dart';

var crackUp = CrackUp();

List<String> customCategories = [
  "asphalt",
  "concrete",
  "cement",
  "pavement",
  "tarmac",
  "gravel",
  "sand",
  "granite",
  "rebar",
];

void main() {
  setUp(() async {
    await crackUp.initCrackUp(customCategories);
  });

  group('Categories:', () {
    test('Category list is not empty', () {
      List<String> categories = crackUp.getCategoryList();
      expect(categories.isNotEmpty, true);
    });

    test('Category list has at least 300 categories', () {
      List<String> categories = crackUp.getCategoryList();
      expect(300 < categories.length, true);
    });

    test('Category list contains specific categories', () {
      List<String> categories = crackUp.getCategoryList();
      expect(categories.contains("asphalt"), true);
    });
  });

  group('Jokes:', () {
    test('Category joke list is not empty', () async {
      List<String> categories = crackUp.getCategoryList();
      await crackUp.getJokesFromCategory(categories[0]);
      Map<String, List<Joke>> jokes = crackUp.getJokeMap();
      expect(jokes.isNotEmpty, true);
    });

    test('Category joke list has at least 5 jokes', () async {
      List<String> categories = crackUp.getCategoryList();
      await crackUp.getJokesFromCategory(categories[0]);
      Map<String, List<Joke>> jokes = crackUp.getJokeMap();
      expect(5 < jokes[categories[0]]!.length, true);
    });
  });
}
