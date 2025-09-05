// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/account_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/auth_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/batch_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/chat_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/comment_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/quiz_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/rating_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/batches_repo.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/comment_repo.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/courses_repo.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/quiz_repo.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/rating_repo.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/wishlist_repo.dart';
import '../../../service/audio_handler.dart';
import '../../../service/page_manager.dart';
import '../../utils/app_constants.dart';
import '../api_helper/network_info.dart';
import '../api_helper/provider_helper/ask_rating _provider.dart';
import '../api_helper/provider_helper/courses_provider.dart';
import '../api_helper/provider_helper/home_provider.dart';
import '../api_helper/provider_helper/live_provider.dart';
import '../api_helper/provider_helper/root_provider.dart';
import '../api_helper/provider_helper/wishlist_provider.dart';
import '../api_helper/repository_helper/account_repo.dart';
import '../api_helper/repository_helper/auth_repo.dart';
import '../api_helper/repository_helper/chat_repo.dart';
import '../api_helper/repository_helper/home_repo.dart';
import '../api_helper/repository_helper/live_repo.dart';
import '../api_helper/repository_helper/root_repo.dart';
import 'dio_client.dart';
import 'logging_interceptor.dart';

GetIt getIt = GetIt.instance;

Future<void> getInit() async {
  //init audio player
  // services
  getIt.registerSingleton<MyAudioHandler>(await initAudioService());
  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager());

  /// Core
  // getIt.registerLazySingleton(() => NetworkInfo(getIt()));
  getIt.registerLazySingleton(
    () => DioClient(
      AppConstants.instance.baseUrl,
      getIt(),
      loggingInterceptor: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => DioClient(
      AppConstants.instance.baseTwoUrl,
      getIt(instanceName: 'two'),
      loggingInterceptor: getIt(instanceName: 'two'),
    ),
    instanceName: 'baseTwo',
  );

  /// External
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => Dio(), instanceName: 'two');
  getIt.registerLazySingleton(() => LoggingInterceptor());
  getIt.registerLazySingleton(() => LoggingInterceptor(), instanceName: 'two');
  // getIt.registerLazySingleton(() => Connectivity());

  /// Repository
  getIt.registerLazySingleton(() => AuthRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => RootRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => AccountRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => ChatRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => CoursesRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => RatingRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => QuizRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => WishListRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => HomeRepo(
        dioClient: getIt(),
        dioClientTwo: getIt(instanceName: 'baseTwo'),
      ));
  getIt.registerLazySingleton(() => CommentRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => LiveRepo(dioClient: getIt()));
  getIt.registerLazySingleton(() => BatchRepo(dioClient: getIt()));

  /// Provider
  getIt.registerFactory(() => AuthProvider(authRepo: getIt()));
  getIt.registerFactory(() => RootProvider(rootRepo: getIt()));
  getIt.registerFactory(() => AccountProvider(accountRepo: getIt()));
  getIt.registerFactory(() => ChatProvider(chatRepo: getIt()));
  getIt.registerFactory(() => AskRatingProvider(ratingRepo: getIt()));

  getIt.registerFactory(() => CourseProvider(coursesRepo: getIt()));
  getIt.registerFactory(() => RatingProvider(ratingRepo: getIt()));
  getIt.registerFactory(() => QuizProvider(quizRepo: getIt()));
  getIt.registerFactory(() => WishListProvider(wishListRepo: getIt()));
  getIt.registerFactory(() => HomeProvider(homeRepo: getIt()

      //  HomeRepo(
      //   dioClient: getIt(),
      //   dioClientTwo: getIt(instanceName: 'baseTwo'),
      // ),
      ));
  getIt.registerFactory(() => CommentProvider(commentRepo: getIt()));
  getIt.registerFactory(() => LiveProvider(liveRepo: getIt()));
  getIt.registerFactory(() => BatchProvider(batchRepo: getIt()));
}
