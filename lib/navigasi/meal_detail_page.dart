// lib/meal_detail_page.dart
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/cart_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MealDetailPage extends StatefulWidget {
  final Meal meal;
  MealDetailPage({required this.meal});

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  int _userRating = 0;
  List<Meal> _relatedMeals = [];
  bool _isLoadingRelated = true;

  @override
  void initState() {
    super.initState();
    _loadRelatedMeals();
  }

  Future<void> _loadRelatedMeals() async {
    try {
      // Ambil meals dari kategori yang sama
      String category = widget.meal.category ?? 'Beef';
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = (data['meals'] as List?)?.map((item) {
          return Meal(
            id: item['idMeal'] ?? '',
            name: item['strMeal'] ?? '',
            thumbnail: item['strMealThumb'] ?? '',
            category: category,
          );
        }).where((meal) => meal.id != widget.meal.id).take(6).toList() ?? [];

        setState(() {
          _relatedMeals = meals;
          _isLoadingRelated = false;
        });
      }
    } catch (e) {
      print('Error loading related meals: $e');
      setState(() {
        _isLoadingRelated = false;
      });
    }
  }

  void _showAllRelatedMeals() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You Might Also Like',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoadingRelated
                    ? Center(child: CircularProgressIndicator(color: Colors.green))
                    : GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _relatedMeals.length,
                  itemBuilder: (context, index) {
                    final meal = _relatedMeals[index];
                    return _buildRelatedMealCard(meal, fullSize: true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedMealCard(Meal meal, {bool fullSize = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close current detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailPage(meal: meal),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Hero(
                tag: 'related_${meal.id}',
                child: Image.network(
                  meal.thumbnail,
                  height: fullSize ? 140 : 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: fullSize ? 140 : 100,
                      color: Colors.grey[200],
                      child: Icon(Icons.fastfood, color: Colors.grey[400], size: 40),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      if (fullSize)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            meal.category ?? 'Food',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
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
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.headset_mic, size: 64, color: Colors.green),
              SizedBox(height: 16),
              Text(
                'Customer Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Butuh bantuan dengan produk ini?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green[50],
                  child: Icon(Icons.phone, color: Colors.green),
                ),
                title: Text('Telepon'),
                subtitle: Text('+62 812-3456-7890'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Menghubungi customer service...')),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green[50],
                  child: Icon(Icons.email, color: Colors.green),
                ),
                title: Text('Email'),
                subtitle: Text('support@meals.com'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Membuka email client...')),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green[50],
                  child: Icon(Icons.chat, color: Colors.green),
                ),
                title: Text('Live Chat'),
                subtitle: Text('Online sekarang'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Membuka live chat...')),
                  );
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Rating & Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                // Overall Rating
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.star, color: Colors.amber, size: 32),
                          ],
                        ),
                        Text(
                          '135 Reviews',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        children: [
                          _buildRatingBar(5, 95),
                          _buildRatingBar(4, 60),
                          _buildRatingBar(3, 20),
                          _buildRatingBar(2, 5),
                          _buildRatingBar(1, 2),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Divider(),
                SizedBox(height: 16),

                // Your Rating
                Text(
                  'Beri Rating Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setModalState(() {
                          _userRating = index + 1;
                        });
                        setState(() {
                          _userRating = index + 1;
                        });
                      },
                      icon: Icon(
                        index < _userRating ? Icons.star : Icons.star_border,
                        size: 40,
                        color: Colors.amber,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),

                // Review Text Field
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tulis review Anda...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Terima kasih atas rating Anda!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Kirim Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          SizedBox(width: 4),
          Icon(Icons.star, size: 12, color: Colors.amber),
          SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '$percentage%',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with back button
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.meal.id,
                child: Container(
                  color: Colors.grey[50],
                  child: Image.network(
                    widget.meal.thumbnail,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.meal.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Rating and Reviews
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '4.8',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.star, color: Colors.white, size: 12),
                            ],
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '(135 Reviews)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Category and Area info
                    if (widget.meal.category != null || widget.meal.area != null)
                      Row(
                        children: [
                          if (widget.meal.area != null) ...[
                            Text(
                              'Seller: ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              widget.meal.area!,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (widget.meal.area != null && widget.meal.category != null)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('•', style: TextStyle(color: Colors.grey)),
                            ),
                          if (widget.meal.category != null) ...[
                            Text(
                              'Vendor: ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              widget.meal.category!,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    SizedBox(height: 20),

                    // Action Buttons (Details, Support, Ratings)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text('Details', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _showSupportDialog,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Support', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _showRatingsBottomSheet,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Ratings', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Description
                    if (widget.meal.instructions != null) ...[
                      Text(
                        widget.meal.instructions!.length > 150
                            ? widget.meal.instructions!.substring(0, 150) + '...'
                            : widget.meal.instructions!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],

                    // Ingredients Section
                    if (widget.meal.ingredients != null && widget.meal.ingredients!.isNotEmpty) ...[
                      Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      ...widget.meal.ingredients!.entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${e.key}${e.value.isNotEmpty ? ' — ${e.value}' : ''}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      SizedBox(height: 24),
                    ],

                    // You Might Also Like Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You Might Also Like',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: _showAllRelatedMeals,
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Related Items
                    _isLoadingRelated
                        ? Container(
                      height: 180,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      ),
                    )
                        : _relatedMeals.isEmpty
                        ? Container(
                      height: 180,
                      child: Center(
                        child: Text(
                          'Tidak ada produk terkait',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                        : Container(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _relatedMeals.length > 4 ? 4 : _relatedMeals.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 140,
                            margin: EdgeInsets.only(right: 12),
                            child: _buildRelatedMealCard(_relatedMeals[index]),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          CartService.instance.addToCart(widget.meal);
          final snack = SnackBar(
            content: Text('${widget.meal.name} ditambahkan ke keranjang'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
        },
        backgroundColor: Colors.green,
        label: Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.w600)),
        icon: Icon(Icons.add_shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}