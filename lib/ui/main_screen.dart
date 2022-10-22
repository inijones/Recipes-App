import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipes_app/ui/colors.dart';
import 'package:recipes_app/ui/my_recipes/my_recipe_list.dart';
import 'package:recipes_app/ui/recipes/recipe_list.dart';
import 'package:recipes_app/ui/shopping/shopping_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> pageList = <Widget>[];
  static const String prefSelectedIndexKey = 'selectedKey';

  @override
  void initState() {
    super.initState();
    pageList.add(const RecipeList());
    pageList.add(const MyRecipeList());
    pageList.add(const ShoppingList());
    getCurrentIndex();
  }

  void saveCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefSelectedIndexKey, _selectedIndex);
  }

  void getCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefSelectedIndexKey)) {
      setState(() {
        final index = prefs.getInt(prefSelectedIndexKey);
        if (index != null) {
          _selectedIndex = index;
        }
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    saveCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    String title;

    switch (_selectedIndex) {
      case 0:
        title = 'Recipes';
        break;
      case 1:
        title = 'Bookmarks';
        break;
      case 2:
        title = 'Groceries';
        break;
      default:
        title = 'Recipes';
        break;
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // Bottom Nav Items
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon_recipe.svg',
              color: _selectedIndex == 0 ? green : Colors.grey,
              semanticsLabel: 'Recipes',
            ),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon_bookmarks.svg',
              color: _selectedIndex == 1 ? green : Colors.grey,
              semanticsLabel: 'Bookmarks',
            ),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon_shopping_list.svg',
              color: _selectedIndex == 2 ? green : Colors.grey,
              semanticsLabel: 'ShoppingList',
            ),
            label: 'ShoppingList',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: green,
        onTap: _onItemTapped,
      ),

      // App Bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.white,
          //Navgation Bar Diider Color
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),

      // App Bar - Indexed Stack
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
    );
  }
}
