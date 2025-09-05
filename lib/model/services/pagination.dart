// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../utils/color_resource.dart';
import '../utils/dimensions_resource.dart';

enum APISTATUS {
  LOADING,
  SUCEESS,
  ERROR,
  HIDELOADER;
}

class PaginationView<T> extends StatelessWidget {
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final Widget Function(BuildContext context) errorBuilder;
  final Widget Function(BuildContext context) bottomLoaderBuilder;
  final Future Function() onRefresh;
  final PagingScrollController<T> pagingScrollController;

  const PaginationView({
    Key? key,
    required this.itemBuilder,
    required this.errorBuilder,
    required this.bottomLoaderBuilder,
    required this.pagingScrollController,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorResource.primaryColor,
      onRefresh: onRefresh,
      child: Obx(() => ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 0),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: pagingScrollController.scrollController,
            // child: Obx(()=>Column(
            children: [
              ...List.generate(
                  pagingScrollController.list.length,
                  (index) => itemBuilder(context, index,
                      pagingScrollController.list.elementAt(index))),
              Visibility(
                  visible: pagingScrollController.isDataLoading.value,
                  child: bottomLoaderBuilder(context)),
            ],
            //  ),
            //)
          )),
    );
  }
}

class GridPaginationView<T> extends StatelessWidget {
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final Widget Function(BuildContext context) errorBuilder;
  final Widget Function(BuildContext context) bottomLoaderBuilder;
  final Future Function() onRefresh;
  final bool isRectangle;
  final double aspectRatio;
  final PagingScrollController<T> pagingScrollController;

  const GridPaginationView(
      {Key? key,
      required this.itemBuilder,
      required this.errorBuilder,
      required this.bottomLoaderBuilder,
      required this.pagingScrollController,
      required this.onRefresh,
      required this.isRectangle,
      this.aspectRatio = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
          left: DimensionResource.marginSizeDefault,
          right: DimensionResource.marginSizeDefault,
          top: DimensionResource.marginSizeSmall),
      sliver: SliverAnimatedGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: DimensionResource.marginSizeSmall,
              mainAxisSpacing: DimensionResource.marginSizeSmall,
              childAspectRatio: isRectangle ? 1.8 : aspectRatio),
          initialItemCount: pagingScrollController.list.length,
          itemBuilder: (context, index, animationVal) {
            return itemBuilder(
                context, index, pagingScrollController.list.elementAt(index));
          }),
    );
  }
}

class PagingScrollController<T> {
  final ScrollController scrollController = ScrollController();
  final RxList<T> list = <T>[].obs;
  final RxBool isDataLoading = false.obs;
  final Rx<APISTATUS> apiStatus = APISTATUS.HIDELOADER.obs;

  final Future<void> Function(int page, int totalItemsCount) onLoadMore;
  final int Function() getStartPage;
  final int Function() getThreshold;

  bool _isLoading = true;
  int _currentPage = 0;
  int _previousItemsCount = 0;

  PagingScrollController({
    required this.onLoadMore,
    required this.getStartPage,
    required this.getThreshold,
  }) {
    _currentPage = getStartPage();
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final currentItemsCount = list.length;

    if (currentItemsCount < _previousItemsCount) {
      _currentPage = getStartPage();
      _previousItemsCount = currentItemsCount;
      if (currentItemsCount == 0) {
        _isLoading = true;
      }
    }

    if (_isLoading && currentItemsCount > _previousItemsCount) {
      _isLoading = false;
      _previousItemsCount = currentItemsCount;
    }

    final nextPageTrigger = scrollController.position.maxScrollExtent;

    if (scrollController.position.userScrollDirection == ScrollDirection.reverse &&
        !_isLoading &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - getThreshold()) {
      _loadNextPage(currentItemsCount);
    }

  }

  Future<void> _loadNextPage(int currentItemsCount) async {
    _currentPage++;
    _isLoading = true;
    await onLoadMore(_currentPage, currentItemsCount);
  }

  void reset() {
    _isLoading = true;
    _currentPage = getStartPage();
    _previousItemsCount = 0;
    list.clear();
    isDataLoading.value = false;
    debugPrint('PagingController reset - List length: ${list.length}');
  }

  void dispose() {
    scrollController.dispose();
  }
}
