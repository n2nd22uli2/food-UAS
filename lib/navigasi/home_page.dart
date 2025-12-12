// lib/navigasi/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../helpers/category_helper.dart';
import 'meal_detail_page.dart';
import 'catalog_page.dart';
import 'address_page.dart';
import '../pages/error_test_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadingMealDetail = false;

  @override
  void initState() {
    super.initState();
    // Load data saat pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    final provider = Provider.of<MealProvider>(context, listen: false);

    try {
      await Future.wait([
        provider.loadCategories(),
        provider.loadRandomMeals(count: 6),
      ]);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to load initial data. Please try again.');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: Colors.red[700],
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green[700],
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleMealTap(String mealId, String mealName) async {
    if (_isLoadingMealDetail) return;

    setState(() {
      _isLoadingMealDetail = true;
    });

    try {
      final provider = Provider.of<MealProvider>(context, listen: false);
      final detail = await provider.getMealDetail(mealId);

      if (!mounted) return;

      setState(() {
        _isLoadingMealDetail = false;
      });

      if (detail != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MealDetailPage(meal: detail),
          ),
        );
      } else {
        _showErrorSnackBar('Failed to load details for $mealName');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingMealDetail = false;
      });

      _showErrorSnackBar('Unable to load meal details. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Consumer<MealProvider>(
              builder: (context, mealProvider, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    try {
                      await mealProvider.refreshData();
                      if (mounted) {
                        _showSuccessSnackBar('Data refreshed successfully');
                      }
                    } catch (e) {
                      if (mounted) {
                        _showErrorSnackBar('Failed to refresh data');
                      }
                    }
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        _buildHeader(context, mealProvider),

                        SizedBox(height: 20),

                        // Special Offers Banner
                        _buildSpecialOffers(context),

                        SizedBox(height: 24),

                        // Popular Items
                        _buildPopularItemsHeader(context),

                        SizedBox(height: 8),

                        // Meals Grid
                        _buildMealsGrid(context, mealProvider),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading overlay
          if (_isLoadingMealDetail)
            Container(
              color: Colors.black26,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading meal details...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MealProvider mealProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E3A5F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Top Bar
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  try {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddressPage(),
                      ),
                    );
                  } catch (e) {
                    _showErrorSnackBar('Failed to open address page');
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600]),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Food Explorer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {
                  _showSuccessSnackBar('No new notifications');
                },
              ),

              // Tambahkan di _buildHeader atau dimana aja
              IconButton(
                icon: Icon(Icons.bug_report, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ErrorTestPage()),
                  );
                },
              )
            ],
          ),
          SizedBox(height: 20),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  _showErrorSnackBar('Please enter a search term');
                  return;
                }

                try {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CatalogPage(),
                    ),
                  );
                } catch (e) {
                  _showErrorSnackBar('Failed to open catalog');
                }
              },
            ),
          ),
          SizedBox(height: 20),

          // Categories
          _buildCategories(context, mealProvider),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context, MealProvider mealProvider) {
    if (mealProvider.isLoadingCategories) {
      return SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (mealProvider.categoriesError != null) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white70,
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                'Failed to load categories',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  try {
                    await mealProvider.loadCategories();
                  } catch (e) {
                    _showErrorSnackBar('Failed to reload categories');
                  }
                },
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white24,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ),
      );
    }



    final categories = ['All', ...mealProvider.categories];
    final displayCategories = categories.length > 5
        ? categories.sublist(0, 5)
        : categories;

    if (displayCategories.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No categories available',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayCategories.length,
        itemBuilder: (context, idx) {
          final cat = displayCategories[idx];
          final bool isSelected = mealProvider.selectedCategory == cat;

          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                try {
                  mealProvider.setSelectedCategory(cat);
                  if (cat != 'All') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CatalogPage(initialCategory: cat),
                      ),
                    );
                  }
                } catch (e) {
                  _showErrorSnackBar('Failed to load category');
                }
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                          : null,
                    ),
                    child: Icon(
                      CategoryHelper.getIcon(cat),
                      color: isSelected
                          ? CategoryHelper.getColor(cat)
                          : Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    cat.length > 8 ? cat.substring(0, 8) : cat,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialOffers(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Offers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8FD14F), Color(0xFF6AB73D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6AB73D).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '35% Discount',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Explore delicious meals\nfrom around the world',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          try {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CatalogPage(),
                              ),
                            );
                          } catch (e) {
                            _showErrorSnackBar('Failed to open catalog');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF6AB73D),
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          elevation: 4,
                        ),
                        child: Text(
                          'Shop Now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItemsHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Popular Items',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              try {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CatalogPage(),
                  ),
                );
              } catch (e) {
                _showErrorSnackBar('Failed to open catalog');
              }
            },
            child: Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsGrid(BuildContext context, MealProvider mealProvider) {
    if (mealProvider.isLoadingRandomMeals) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading meals...',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    if (mealProvider.randomMealsError != null) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'Failed to load meals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                mealProvider.randomMealsError!,
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await mealProvider.loadRandomMeals(count: 6);
                  } catch (e) {
                    _showErrorSnackBar('Failed to reload meals');
                  }
                },
                icon: Icon(Icons.refresh),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E3A5F),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final meals = mealProvider.randomMeals;

    if (meals.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.restaurant,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No meals available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  try {
                    await mealProvider.loadRandomMeals(count: 6);
                  } catch (e) {
                    _showErrorSnackBar('Failed to load meals');
                  }
                },
                child: Text('Reload'),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: meals.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 260,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (ctx, idx) {
          final m = meals[idx];
          return GestureDetector(
            onTap: () => _handleMealTap(m.id, m.name),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        m.thumbnail,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Image not available',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              m.category ?? 'Meal',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Color(0xFF6AB73D),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}