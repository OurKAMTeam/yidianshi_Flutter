// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:get/get.dart';
import 'package:yidianshi/model/xidian_ids/library.dart';
import 'package:yidianshi/xd_api/tool/library_session.dart';

class LibraryController extends GetxController {
  final isLoading = false.obs;
  final searchResults = Rx<List<BookInfo>>([]);
  final borrowList = Rx<List<BorrowData>>([]);
  final currentPage = 1.obs;
  final searchWord = ''.obs;
  
  final LibrarySession _session = LibrarySession();

  @override
  void onInit() {
    super.onInit();
    getBorrowList();
  }

  Future<void> getBorrowList() async {
    try {
      isLoading.value = true;
      borrowList.value = await _session.getBorrowList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get borrow list: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchBook(String query, {int page = 1}) async {
    try {
      isLoading.value = true;
      searchWord.value = query;
      currentPage.value = page;
      final results = await _session.searchBook(query, page);
      searchResults.value = results;
    } catch (e) {
      Get.snackbar('Error', 'Failed to search books: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> renewBook(int loanId) async {
    try {
      isLoading.value = true;
      await _session.renew(loanId);
      await getBorrowList(); // Refresh the list after renewal
      Get.snackbar('Success', 'Book renewed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to renew book: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getBookCover(String isbn) async {
    try {
      return LibrarySession.bookCover(isbn);
    } catch (e) {
      return ''; // Return empty string if failed to get cover
    }
  }
}
