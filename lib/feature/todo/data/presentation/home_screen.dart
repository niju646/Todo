import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/interceptor/network_provider.dart';
import 'package:to_do/core/routes/router_constants.dart';
import 'package:to_do/core/shared/common_shimmer_list.dart';
import 'package:to_do/core/shared/common_shimmer_tile.dart';
import 'package:to_do/core/shared/custom_snackbar.dart';
import 'package:to_do/core/shared/widgets/common_card.dart';
import 'package:to_do/core/shared/widgets/empty_screen.dart';
import 'package:to_do/feature/todo/data/provider/todo_provider.dart';
import 'package:to_do/feature/todo/widgets/home_header_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshAllData();
    });

    _scrollController.addListener(() {
      final pos = _scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(todoProvider.notifier).fetchTodos(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> refreshAllData() async {
    await ref.read(todoProvider.notifier).fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkProvider, (previous, next) {
      if (previous == null) return;

      next.whenData((isConnected) {
        if (!isConnected) {
          CustomSnackbar.show(
            context,
            message: "No Internet Connection",
            type: SnackbarType.failure,
          );
        } else {
          CustomSnackbar.show(
            context,
            message: "Back Online",
            type: SnackbarType.success,
          );
        }
      });
    });
    final state = ref.watch(todoProvider);

    final filteredTodos = _searchQuery.isEmpty
        ? state.todos
        : state.todos
              .where(
                (t) =>
                    (t.title ?? '').toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    (t.description ?? '').toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          HomeHeaderCard(
            searchController: _searchController,
            searchQuery: _searchQuery,
            onSearchChanged: (value) => setState(() => _searchQuery = value),
            onSearchCleared: () => setState(() {
              _searchQuery = '';
              _searchController.clear();
            }),
          ),

          if (state.isLoading && state.todos.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: commonShimmerList(itemCount: 10)),
              ),
            )
          else if (filteredTodos.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: EmptyStateCard(
                    title: _searchQuery.isNotEmpty
                        ? 'No results for "$_searchQuery"'
                        : "No Todos Found",
                    subtitle: _searchQuery.isNotEmpty
                        ? "Try a different keyword."
                        : "Start adding your todos now!",
                    icon: _searchQuery.isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.checklist_rounded,
                    actionLabel: _searchQuery.isNotEmpty ? null : "Add Todo",
                    onAction: null,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshAllData,
                color: const Color(0xFF1A1A2E),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: filteredTodos.length + 1,
                  itemBuilder: (context, index) {
                    // Footer
                    if (index == filteredTodos.length) {
                      if (state.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CommonShimmerTile(),
                        );
                      }
                      if (!state.hasMore) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              "All ${state.totalItems} tasks loaded",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }

                    final todo = filteredTodos[index];
                    return CommonCard(
                      onTap: () {
                        context.pushNamed(
                          RouteConstants.todoDetailScreen,
                          extra: todo.id,
                        );
                      },
                      title: todo.title ?? "",
                      description: todo.description ?? "",
                      isCompleted: todo.status ?? false,
                      icon: Icons.delete_outline_rounded,
                      onDelete: () {
                        ref
                            .read(todoProvider.notifier)
                            .deleteTodo(id: todo.id ?? 0);
                        CustomSnackbar.show(
                          context,
                          message: "Todo deleted successfully!",
                          type: SnackbarType.success,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          context.pushNamed(RouteConstants.createtodo);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
