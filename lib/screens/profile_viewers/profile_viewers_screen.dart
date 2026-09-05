
import 'package:active_matrimonial_flutter_app/redux/app/app_state.dart';
import 'package:active_matrimonial_flutter_app/screens/profile_viewers/viewers_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/profile_viewers/viewers_state.dart';
import 'package:active_matrimonial_flutter_app/repository/profile_viewers_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

import '../../components/common_app_bar.dart';
import '../../helpers/aiz_route.dart';
import '../../l10n/app_localizations.dart';
import '../../models_response/profile/profile_viewers_respons.dart';
import '../user_pages/user_public_profile.dart';
class ViewersPage extends StatefulWidget {
  const ViewersPage({Key? key}) : super(key: key);

  @override
  _ViewersPageState createState() => _ViewersPageState();
}

class _ViewersPageState extends State<ViewersPage> {
  late final ProfileViewersRepositoryImpl _repository;

  @override
  void initState() {
    super.initState();
    _repository = ProfileViewersRepositoryImpl(client: http.Client());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context, listen: false);
      store.dispatch(fetchViewersThunk(_repository, page: 1, append: false));
    });
  }

  @override
  void dispose() {
    try {
      _repository.client.close();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _onRefresh(Store<AppState> store) async {
    store.dispatch(fetchViewersThunk(_repository, page: 1, append: false));
    await Future.delayed(const Duration(milliseconds: 400));
  }

  void _loadNextPage(Store<AppState> store, ProfileViewersState state) {
    final current = state.meta?.currentPage ?? 1;
    final last = state.meta?.lastPage ?? 1;
    if (current < last) {
      store.dispatch(fetchViewersThunk(_repository, page: current + 1, append: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
      converter: (Store<AppState> store) {
        final pvState = store.state.profileViewersState ?? ProfileViewersState.initial();
        return _VM(profileViewersState: pvState, store: store);
      },
      distinct: true,
      builder: (context, vm) {
        final state = vm.profileViewersState;

        return Scaffold(
          appBar: CommonAppBar(
            text:
            AppLocalizations.of(
              context,
            )!.profile_view_screen_appbar_title,
          ).build(context),
          body: _body(vm.store, state),
        );
      },
    );
  }

  Widget _body(Store<AppState> store, ProfileViewersState state) {
    if (state.loadingState == LoadingState.loading && state.viewers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.loadingState == LoadingState.failure && state.viewers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: ${state.error ?? "Something went wrong"}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => store.dispatch(fetchViewersThunk(_repository, page: 1, append: false)),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _onRefresh(store),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        itemCount: state.viewers.length + 1,
        itemBuilder: (context, index) {
          // footer
          if (index == state.viewers.length) {
            final hasMore = (state.meta?.currentPage ?? 1) < (state.meta?.lastPage ?? 1);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: hasMore
                    ? ElevatedButton(
                  onPressed: () => _loadNextPage(store, state),
                  child: const Text('Load more'),
                )
                    : const Text('No more', style: TextStyle(color: Colors.grey)),
              ),
            );
          }

          final v = state.viewers[index];
          return _ViewerCard(
            viewer: v,
            onHeart: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${v.name} added to shortlist')),
              );
            },
            onCross: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${v.name} removed')),
              );
            },
            onTap: () {
              AIZRoute.push(
                context,
                UserPublicProfile(
                  userId: v.userId,

                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ViewerCard extends StatelessWidget {
  final Viewer viewer;
  final VoidCallback? onHeart;
  final VoidCallback? onCross;
  final VoidCallback? onTap;

  const _ViewerCard({
    Key? key,
    required this.viewer,
    this.onHeart,
    this.onCross,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 6)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                child: Container(
                  width: 110,
                  color: Colors.grey[100],
                  child: viewer.photo.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: viewer.photo,
                    fit: BoxFit.cover,
                    width: 110,
                    placeholder: (c, u) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (c, u, e) => const Icon(Icons.person, size: 48),
                  )
                      : const Icon(Icons.person, size: 48),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(viewer.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Text('${viewer.age} years', style: TextStyle(color: Colors.grey[800])),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(viewer.country.isNotEmpty ? viewer.country : '',
                                style: TextStyle(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if ((viewer.religion ?? '').isNotEmpty)
                        Text(viewer.religion ?? '', style: TextStyle(color: Colors.grey[700])),
                      if ((viewer.religion ?? '').isNotEmpty) const SizedBox(height: 8),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// View model to extract the profile viewers state from AppState
class _VM {
  final ProfileViewersState profileViewersState;
  final Store<AppState> store;

  _VM({required this.profileViewersState, required this.store});
}
