// import 'package:consultant/cubits/app/app_cubit.dart';
// import 'package:consultant/cubits/auth/auth_cubit.dart';
// import 'package:consultant/cubits/chat_rooms/chat_room_cubit.dart';
// import 'package:consultant/cubits/home/home_cubit.dart';
// import 'package:consultant/cubits/messages/messages_cubit.dart';
// import 'package:consultant/cubits/searching/searching_cubit.dart';
// import 'package:consultant/cubits/settings/settings_cubit.dart';
// import 'package:consultant/main.dart';
// import 'package:consultant/repositories/chat_room_repository.dart';
// import 'package:consultant/repositories/comment_repository.dart';
// import 'package:consultant/repositories/consultant_repository.dart';
// import 'package:consultant/repositories/message_repository.dart';
// import 'package:consultant/repositories/settings_repository.dart';
// import 'package:consultant/services/auth_service.dart';
// import 'package:consultant/services/chat_room_service.dart';
// import 'package:consultant/services/consultant.dart';
// import 'package:consultant/services/message_service.dart';
// import 'package:consultant/services/settings_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// final _consultantService = ConsultantService(
//   ConsultantRepository(),
//   CommentRepository(),
// );

// class CustomBlocProvider {
//   List<>
// }

//  providers = [
//   BlocProvider(create: (_) => AppCubit()),
//   BlocProvider(
//     create: (_) => HomeCubit(_consultantService),
//   ),
//   BlocProvider(
//     create: (_) => SearchingCubit(_consultantService),
//   ),
//   BlocProvider(
//     create: (_) => ChatRoomCubit(ChatRoomService(ChatRoomRepository())),
//   ),
//   BlocProvider(
//     create: (_) => MessageCubit(MessageService(MessageRepository())),
//   ),
//   BlocProvider(
//     create: (_) => SettingsCubit(SettingsService(SettingsRepository())),
//   ),
//   // BlocProvider(
//   //   create: (_) => AuthCubit(AuthService(auth)),
//   // ),
// ];

// // List<BlocProvider> get providers => _providers;