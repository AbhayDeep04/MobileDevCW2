import 'package:flutter/material.dart';

void main() {
  runApp(RecipeBookApp());
}

class RecipeBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/favorites': (context) => FavoritesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final recipe = settings.arguments as Recipe;
          return MaterialPageRoute(
            builder: (context) => DetailsScreen(recipe: recipe),
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}

class Recipe {
  final String title;
  final String ingredients;
  final String instructions;
  bool isFavorite;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });
}

List<Recipe> recipes = [
  Recipe(
    title: 'Spaghetti Bolognese',
    ingredients: 'Spaghetti, Ground Beef, Tomato Sauce, Onions, Garlic',
    instructions: 'Cook spaghetti. Brown beef. Add tomato sauce and simmer.',
  ),
  Recipe(
    title: 'Chicken Curry',
    ingredients: 'Chicken, Curry Powder, Coconut Milk, Onions, Garlic',
    instructions: 'Cook chicken. Add spices and coconut milk. Simmer until done.',
  ),
  Recipe(
    title: 'Vegetable Stir Fry',
    ingredients: 'Mixed vegetables, Soy Sauce, Garlic, Ginger',
    instructions: 'Stir fry vegetables. Add soy sauce and seasonings.',
  ),
];

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Book'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe.title),
            trailing: recipe.isFavorite
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details',
                arguments: recipe,
              );
            },
          );
        },
      ),
      // Placing a button at the bottom that navigates to the FavoritesScreen.
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/favorites');
          },
          icon: Icon(Icons.favorite),
          label: Text("View Favorites"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            textStyle: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  final Recipe recipe;

  DetailsScreen({required this.recipe});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.recipe.isFavorite;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.recipe.isFavorite = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0),
            Text(widget.recipe.ingredients),
            SizedBox(height: 16.0),
            Text(
              'Instructions:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0),
            Text(widget.recipe.instructions),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                label: Text(
                  isFavorite ? 'Unmark Favorite' : 'Mark as Favorite',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteRecipes =
        recipes.where((recipe) => recipe.isFavorite).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(child: Text('No favorite recipes yet.'))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return ListTile(
                  title: Text(recipe.title),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: recipe,
                    );
                  },
                );
              },
            ),
    );
  }
}
