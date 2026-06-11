import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../data/products_repository.dart';

class MediaGallery extends StatefulWidget {
	final List<ProductMediaItem> items;

	const MediaGallery({
		super.key,
		required this.items,
	});

	@override
	State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
	int _activeIndex = 0;

	@override
	Widget build(BuildContext context) {
		if (widget.items.isEmpty) {
			return Container(
				height: 220,
				alignment: Alignment.center,
				decoration: BoxDecoration(
					color: Colors.grey.shade200,
					borderRadius: BorderRadius.circular(16),
				),
				child: const Text('No media available'),
			);
		}

		return Column(
			children: [
				CarouselSlider(
					items: widget.items.map((item) {
						return ClipRRect(
							borderRadius: BorderRadius.circular(16),
							child: Stack(
								fit: StackFit.expand,
								children: [
									Image.network(item.url, fit: BoxFit.cover),
									if (item.isVideo)
										Container(
											color: Colors.black.withOpacity(0.35),
											alignment: Alignment.center,
											child: const Icon(
												Icons.play_circle_fill,
												size: 48,
												color: Colors.white,
											),
										),
								],
							),
						);
					}).toList(),
					options: CarouselOptions(
						height: 220,
						viewportFraction: 1,
						enableInfiniteScroll: false,
						onPageChanged: (index, _) => setState(() => _activeIndex = index),
					),
				),
				const SizedBox(height: 8),
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: List.generate(widget.items.length, (index) {
						final isActive = index == _activeIndex;
						return AnimatedContainer(
							duration: const Duration(milliseconds: 200),
							margin: const EdgeInsets.symmetric(horizontal: 4),
							width: isActive ? 16 : 8,
							height: 8,
							decoration: BoxDecoration(
								color: isActive ? Colors.black87 : Colors.black26,
								borderRadius: BorderRadius.circular(8),
							),
						);
					}),
				),
			],
		);
	}
}
