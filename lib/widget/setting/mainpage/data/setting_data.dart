class SettingData {
  static final Map<String, dynamic> userInfo = {
    'name': '张三',
    'studentId': '20009371462',
    'avatar': 'assets/icon.png',
    'department': '网络与信息安全学院',
    'major': '网络工程',
  };

  static final List<Map<String, dynamic>> settingItems = [
    {
      'title': '账号与安全',
      'icon': 'security',
      'route': '/security',
    },
    {
      'title': '通知设置',
      'icon': 'notifications',
      'route': '/notifications',
    },
    {
      'title': '主题设置',
      'icon': 'color_lens',
      'route': '/theme',
    },
    {
      'title': '关于我们',
      'icon': 'info',
      'route': '/about',
    },
  ];
}
