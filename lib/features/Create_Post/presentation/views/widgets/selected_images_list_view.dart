import 'package:archilink/features/Create_Post/presentation/manager/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class SelectedImagesListView extends StatelessWidget {
  const SelectedImagesListView({
    super.key,
    required this.height,
    required this.images,
    required this.width,
  });

  final List<AssetEntity> images;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 166 / 874,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 4),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AssetEntityImage(
                  images[index],
                  isOriginal: false,
                  fit: BoxFit.cover,
                  width: width * 150 / 402,
                  height: width * 150 / 402,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => context
                      .read<CreatePostCubit>()
                      .removeAsset(images[index]),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}