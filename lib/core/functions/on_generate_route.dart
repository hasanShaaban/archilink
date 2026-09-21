import 'dart:io';

import 'package:archilink/features/Auth/presentation/views/auth_view.dart';
import 'package:archilink/features/Chat/domain/entity/chat_args.dart';
import 'package:archilink/features/Create_Post/presentation/views/create_post_view.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/about_me_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/academic_experiance_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/add_academic_experiance_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/add_contact_info_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/contact_info_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/edit_profile_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/location_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/skills_view.dart';
import 'package:archilink/features/Profile/presentation/views/crop_image_view.dart';
import 'package:archilink/features/Profile/presentation/views/store_profile_view.dart';
import 'package:archilink/features/Profile/presentation/views/user_profile_view.dart';
import 'package:archilink/features/Search/presentation/views/search_results_view.dart';
import 'package:archilink/features/Search/presentation/views/search_view.dart';
import 'package:archilink/features/Splash/presentation/views/splash_view.dart';
import 'package:archilink/features/Chat/presentation/view/chat_list_view.dart';
import 'package:archilink/features/Chat/presentation/view/app_chat_view.dart';
import 'package:archilink/features/Post_Details/presentation/view/post_details_view.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Search/domain/repo/search_repo.dart';
import 'package:archilink/features/Search/presentation/manager/cubit/search_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/followers_and_following_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/liked_posts_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/comments_history_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/user_collections_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/collection_posts_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/customer_support_chat_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/customer_support_messages_cubit.dart';
import 'package:archilink/features/settings/presentation/views/customer_support_chat_view.dart';
import 'package:archilink/features/settings/presentation/views/customer_support_view.dart';
import 'package:archilink/features/settings/presentation/views/followers_and_following_view.dart';
import 'package:archilink/features/settings/presentation/views/my_activity_view.dart';
import 'package:archilink/features/settings/presentation/views/saved_collecation_view.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:archilink/features/Store/presentation/views/add_edit_product_view.dart';
import 'package:archilink/features/Store/presentation/views/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:archilink/features/Main/presentation/views/main_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.name:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case AuthView.name:
      return MaterialPageRoute(builder: (context) => const AuthView());
    case ChatListView.name:
      return MaterialPageRoute(builder: (context) => const ChatListView());
    case AppChatView.name:
      final args = settings.arguments as ChatArgs;
      return MaterialPageRoute(builder: (context) => AppChatView(args: args));
    case PostDetailsView.name:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => PostDetailsView(post: args['post']),
      );
    case ProductDetailsView.name:
      final product = settings.arguments is ProductEntity
          ? settings.arguments as ProductEntity
          : (settings.arguments as Map<String, dynamic>)['product']
              as ProductEntity;
      return MaterialPageRoute(
        builder: (context) => ProductDetailsView(product: product),
      );
    case AddEditProductView.name:
      ProductEntity? product;
      if (settings.arguments is ProductEntity) {
        product = settings.arguments as ProductEntity;
      } else if (settings.arguments is Map<String, dynamic>) {
        product = (settings.arguments as Map<String, dynamic>)['product']
            as ProductEntity?;
      }
      return MaterialPageRoute<bool>(
        builder: (context) => AddEditProductView(product: product),
      );
    case MainView.name:
      return MaterialPageRoute(builder: (context) => const MainView());
    case UserProfileView.name:
      return MaterialPageRoute(builder: (context) => const UserProfileView());
    case StoreProfileView.name:
      int? storeId;
      String username = '';
      if (settings.arguments is ProductStoreEntity) {
        final store = settings.arguments as ProductStoreEntity;
        storeId = store.id;
        username = store.username.isNotEmpty ? store.username : store.name;
      } else if (settings.arguments is Map<String, dynamic>) {
        final map = settings.arguments as Map<String, dynamic>;
        storeId = map['id'] as int? ?? map['storeId'] as int?;
        username = (map['username'] ?? map['handle'] ?? map['name'] ?? '') as String;
      } else if (settings.arguments is int) {
        storeId = settings.arguments as int;
      } else if (settings.arguments is String) {
        username = settings.arguments as String;
      }
      return MaterialPageRoute(
        builder: (context) => StoreProfileView(
          username: username,
          storeId: storeId,
        ),
      );
    case EditProfileView.name:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => EditProfileView(
          profileData: args['profileData'],
          isStore: args['isStore'] ?? false,
        ),
      );
    case CropImageView.name:
      final args = settings.arguments as Map<String, dynamic>;
      final dynamic rawFile = args['imageFile'];
      final File file = rawFile is File ? rawFile : File(rawFile as String);
      final CropImageType cropType =
          args['cropType'] as CropImageType? ?? CropImageType.profileImage;
      final bool isStore = args['isStore'] as bool? ?? false;
      final void Function(File)? onConfirm =
          args['onConfirm'] as void Function(File)?;
      return MaterialPageRoute<bool>(
        builder: (context) => CropImageView(
          imageFile: file,
          cropType: cropType,
          isStore: isStore,
          onConfirm: onConfirm,
        ),
      );
    case AboutMeView.name:
      return MaterialPageRoute(builder: (context) => const AboutMeView());
    case LocationView.name:
      return MaterialPageRoute(builder: (context) => const LocationView());
    case AcademicExperianceView.name:
      return MaterialPageRoute(
        builder: (context) => const AcademicExperianceView(),
      );
    case AddAcademicExperianceView.name:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (context) => AddAcademicExperianceView(
          initialExperience: args?['experience'],
          editIndex: args?['index'],
        ),
      );
    case ContactInfoView.name:
      return MaterialPageRoute(builder: (context) => const ContactInfoView());
    case AddContactInfoView.name:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (context) => AddContactInfoView(
          initialContactInfo: args?['contactInfo'],
          editIndex: args?['index'],
        ),
      );
    case SkillsView.name:
      return MaterialPageRoute(builder: (context) => const SkillsView());
    case CreatePostView.name:
      PostEntity? postToEdit;
      if (settings.arguments is PostEntity) {
        postToEdit = settings.arguments as PostEntity;
      } else if (settings.arguments is Map<String, dynamic>) {
        postToEdit = (settings.arguments as Map<String, dynamic>)['post'] as PostEntity?;
      }
      return MaterialPageRoute<bool>(
        builder: (context) => CreatePostView(postToEdit: postToEdit),
      );
    case SearchView.name:
      return MaterialPageRoute(builder: (context) => const SearchView());
    case SearchResultsView.name:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => SearchCubit(sl<SearchRepo>())..fetchSearchResults(),
          child: const SearchResultsView(),
        ),
      );
    case FollowersAndFollowingView.name:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => sl<FollowersAndFollowingCubit>()..fetchFollowers(),
          child: const FollowersAndFollowingView(),
        ),
      );
    case MyActivityView.name:
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<LikedPostsCubit>()..fetchLikedPosts(),
            ),
            BlocProvider(create: (_) => sl<CommentsHistoryCubit>()),
          ],
          child: const MyActivityView(),
        ),
      );
    case SavedCollecationView.name:
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<UserCollectionsCubit>()..fetchCollections(),
            ),
            BlocProvider(
              create: (_) => sl<CollectionPostsCubit>(),
            ),
          ],
          child: const SavedCollecationView(),
        ),
      );
    case CustomerSupportView.name:
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: sl<CustomerSupportChatCubit>()..fetchChatDetails(),
          child: const CustomerSupportView(),
        ),
      );
    case CustomerSupportChatView.name:
      final initialMessage = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: sl<CustomerSupportChatCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<CustomerSupportMessagesCubit>()..fetchMessages(),
            ),
          ],
          child: CustomerSupportChatView(initialMessage: initialMessage),
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) =>
            Scaffold(body: Center(child: Text('Page not found'))),
      );
  }
}
