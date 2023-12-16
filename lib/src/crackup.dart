import './classes.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class CrackUp {
  final String _baseUrl = "https://upjoke.com/";
  final List<String> categoryList = [];
  final Map<String, List<Joke>> jokeListMap = {};

  /// Needs to be called first, creates the base category list from [customCategories] and the website
  Future<void> initCrackUp([List<String>? customCategories]) async {
    if (customCategories != null && customCategories.isNotEmpty) {
      _addCategoriesToList(customCategories);
    }
    await getCategories();
  }

  /// Gets a copy of [categoryList]
  List<String> getCategoryList() {
    return List<String>.from(categoryList);
  }

  /// Gets a copy of [jokeListMap]
  Map<String, List<Joke>> getJokeMap() {
    return Map<String, List<Joke>>.from(jokeListMap);
  }

  /// Adds categories to category list
  void _addCategoriesToList(List<String> categories) {
    for (var category in categories) {
      // Check if the category is not already in the list
      if (!categoryList.contains(category)) {
        categoryList.add(category);
      }
    }
  }

  /// Gets a list of [categories] from the landing page
  Future<void> getCategories() async {
    Uri url = Uri.parse(_baseUrl);
    late http.Response response;

    try {
      response = await http.get(url);
      // Check if the request was successfull
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return; // Exit the method if there's an error
    }

    List<String> categories = _parseCategories(response.body);
    _addCategoriesToList(categories);
  }

  /// Parses landing page html to extract category names
  List<String> _parseCategories(String html) {
    List<String> categories = [];

    dom.Document document = parser.parse(html);

    List<dom.Element> documentData = document.getElementsByTagName("a");

    for (var data in documentData) {
      categories.add(data.innerHtml);
    }
    return categories;
  }

  /// Gets a list of jokes from the joke page of the selected [category]
  Future<void> getJokesFromCategory(String category) async {
    Uri url = Uri.parse("$_baseUrl$category-jokes");
    late http.Response response;

    try {
      response = await http.get(url);
      // Check if the request was successfull
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch jokes for category "$category". Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching jokes for category "$category": $e');
      return; // Exit the method if there's an error
    }

    List<Joke> jokes = _parseJokes(response.body);
    jokeListMap[category] = jokes;
  }

  /// Parses selected joke page html to extract joke [title] and [body]
  List<Joke> _parseJokes(String html) {
    List<Joke> jokes = [];

    dom.Document document = parser.parse(html);

    List<dom.Element> documentData = document.getElementsByClassName("joke-wrapper");

    for (var data in documentData) {
      var jokeHtml = data.getElementsByClassName("joke-content");

      // Here we are removing jokes with a read more button in the body
      if (!jokeHtml[0].children[1].innerHtml.contains("<button")) {
        String title = jokeHtml[0].children[0].innerHtml;
        String body = jokeHtml[0].children[1].innerHtml.replaceAll("<br>", "\n");
        jokes.add(Joke(title: title, body: body));
      }
    }
    return jokes;
  }
}
