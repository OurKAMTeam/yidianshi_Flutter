import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './post_controller.dart';

class PostScreen extends GetView<PostController> {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('论坛', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索帖子...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onChanged: controller.searchPosts,
            ),
          ),
          // 横向滚动按钮栏
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton('推荐', 0),
                  _buildTabButton('就业', 1),
                  _buildTabButton('考研', 2),
                  _buildTabButton('保研', 3),
                  _buildTabButton('表白墙', 4),
                  _buildTabButton('旧物交易', 5),
                ],
              ),
            ),
          ),
          // 帖子列表
          Expanded(
            child: Obx(() {
              if (controller.posts.isEmpty) {
                return const Center(
                  child: Text('没有找到相关帖子'),
                );
              }
              return ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (context, index) {
                  var post = controller.posts[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed('/post/detail', arguments: {'post': post});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['title'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              post['time'],
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.message, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text('${post['comments']}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text('${post['likes']}'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addPost();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            onPressed: () => controller.changeTab(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.currentTabIndex.value == index 
                  ? Theme.of(Get.context!).primaryColor 
                  : Colors.grey[200],
              foregroundColor: controller.currentTabIndex.value == index 
                  ? Colors.white 
                  : Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(title),
          ),
        ));
  }
}
