import 'package:awesome_app/features/photo_list/presentation/pages/photo_list_page.dart';
import 'package:collapsible_app_bar/collapsible_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../managers/show_item_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool appBarCollapsed = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollapsibleAppBar(
        onPressedBack: () {
          // Menampilkan dialog konfirmasi keluar aplikasi
          _showExitConfirmationDialog(context);
        },
        shrinkTitle: 'Explore Photos',
        forceElevated: true,
        elevation: 10,
        actions: [
          BlocBuilder<ShowItemBloc, ShowItemState>(
            builder: (context, state) {
              return state.when(
                  show: (isGrid) => IconButton(
                        icon: Icon(isGrid ? Icons.grid_view : Icons.list),
                        onPressed: () {
                          context.read<ShowItemBloc>().add(const ShowItemEvent.option());
                        },
                      ));
            },
          ),
        ],
        onChange: (collapsed) {
          setState(() {
            appBarCollapsed = collapsed;
          });
        },
        expandedHeight: 250,
        header: _buildHeader(context),
        headerBottom: _buildHeaderBottom(context),
        userWrapper: false,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://fastly.picsum.photos/id/326/4928/3264.jpg?hmac=lJA_LBhuSUZpPbFFE6vjjSjIWzpaqjZpR9vV9MkZfJw',
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
          },
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Browse photos by category',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              appBarCollapsed
                  ? BlocBuilder<ShowItemBloc, ShowItemState>(
                      builder: (context, state) {
                        return state.when(
                          show: (isGrid) => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 3000),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: IconButton(
                              key: ValueKey<bool>(isGrid), // Unique key for AnimatedSwitcher
                              icon: Icon(isGrid ? Icons.grid_view : Icons.list),
                              onPressed: () {
                                context.read<ShowItemBloc>().add(const ShowItemEvent.option());
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
        Container(
          height: 10,
          color: Colors.grey[100],
        ),
      ],
    );
  }

  Widget _buildHeaderBottom(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: Colors.black87,
      labelPadding: const EdgeInsets.only(bottom: 8),
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [
        Text('Food'),
        Text('Animal'),
        Text('Nature'),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      top: true,
      child: TabBarView(
        controller: tabController,
        children: const [
          PhotoListPage(category: 'Food'),
          PhotoListPage(category: 'Animal'),
          PhotoListPage(category: 'Nature'),
        ],
      ),
    );
  }
}

void _showExitConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Menutup dialog tanpa keluar aplikasi
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Menutup dialog dan keluar dari aplikasi
              Navigator.of(context).pop();
              SystemNavigator.pop(); // Keluar aplikasi
            },
            child: const Text('Exit'),
          ),
        ],
      );
    },
  );
}
