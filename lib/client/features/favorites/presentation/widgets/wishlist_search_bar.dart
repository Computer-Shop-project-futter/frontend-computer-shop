// lib/features/wishlist/presentation/widgets/wishlist_search_bar.dart

import 'package:flutter/material.dart';

class WishlistSearchBar extends StatefulWidget {
  final String? initialQuery;
  final Function(String) onSearch;

  const WishlistSearchBar({
    super.key,
    this.initialQuery,
    required this.onSearch,
  });

  @override
  State<WishlistSearchBar> createState() => _WishlistSearchBarState();
}

class _WishlistSearchBarState extends State<WishlistSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            hintText: 'Search your wishlist...',
            hintStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9AA6B5),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 20,
              color: Color(0xFF9AA6B5),
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      _controller.clear();
                      widget.onSearch('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}