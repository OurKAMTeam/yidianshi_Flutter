import 'package:get/get.dart';

class PostController extends GetxController {
  static PostController get to => Get.find();
  
  // 所有帖子列表
  final _allPosts = <Map<String, dynamic>>[
    {
      "title": "综合类（产品、财务、人力、会计、运营、商务等）、营销/技术支持类、算法/网络安全/大数据类、器件电路类、软件/嵌入式类",
      "time": "2024.9.19 十分钟前",
      "likes": 100,
      "comments": 10,
    },
    {
      "title": "综合类（产品、财务、人力、会计、运营、商务等）、营销/技术支持类、算法/网络安全/大数据类、器件电路类、软件/嵌入式类",
      "time": "2024.9.19 十分钟前",
      "likes": 100,
      "comments": 10,
    },
    {
      "title": "综合类（产品、财务、人力、会计、运营、商务等）、营销/技术支持类、算法/网络安全/大数据类、器件电路类、软件/嵌入式类",
      "time": "2024.9.19 十分钟前",
      "likes": 100,
      "comments": 10,
    },
    {
      "title": "综合类（产品、财务、人力、会计、运营、商务等）、营销/技术支持类、算法/网络安全/大数据类、器件电路类、软件/嵌入式类",
      "time": "2024.9.19 十分钟前",
      "likes": 100,
      "comments": 10,
    },
  ];

  // 显示的帖子列表
  final posts = <Map<String, dynamic>>[].obs;
  
  // 搜索关键词
  final searchText = ''.obs;

  // 当前选中的标签页索引
  final currentTabIndex = 0.obs;

  // 切换标签页
  void changeTab(int index) {
    currentTabIndex.value = index;
    handleTabClick(index);
  }

  // 处理标签页点击
  void handleTabClick(int index) {
    switch (index) {
      case 0:
        handleRecommendTab();
        break;
      case 1:
        handleJobTab();
        break;
      case 2:
        handlePostgraduateTab();
        break;
      case 3:
        handleRecommendedStudentTab();
        break;
      case 4:
        handleConfessionTab();
        break;
      case 5:
        handleSecondHandTab();
        break;
    }
  }

  // 处理推荐页
  void handleRecommendTab() {
    // TODO: 加载推荐页的帖子
    print('加载推荐页');
  }

  // 处理就业页
  void handleJobTab() {
    // TODO: 加载就业相关帖子
    print('加载就业页');
  }

  // 处理考研页
  void handlePostgraduateTab() {
    // TODO: 加载考研相关帖子
    print('加载考研页');
  }

  // 处理保研页
  void handleRecommendedStudentTab() {
    // TODO: 加载保研相关帖子
    print('加载保研页');
  }

  // 处理表白墙
  void handleConfessionTab() {
    // TODO: 加载表白墙帖子
    print('加载表白墙');
  }

  // 处理旧物交易
  void handleSecondHandTab() {
    // TODO: 加载旧物交易帖子
    print('加载旧物交易');
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化显示所有帖子
    posts.assignAll(_allPosts);
  }

  void addPost() {
    final newPost = {
      "title": "新帖子",
      "time": "刚刚",
      "likes": 0,
      "comments": 0,
    };
    _allPosts.add(newPost);
    searchPosts(searchText.value); // 更新显示列表
  }

  // 搜索帖子
  void searchPosts(String keyword) {
    searchText.value = keyword;
    if (keyword.isEmpty) {
      posts.assignAll(_allPosts);
      return;
    }

    final filteredPosts = _allPosts.where((post) => 
      post['title'].toString().toLowerCase().contains(keyword.toLowerCase())
    ).toList();
    
    posts.assignAll(filteredPosts);
  }
}
