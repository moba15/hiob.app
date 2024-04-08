import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/changelog/view/changelog_view.dart';
import 'package:smart_home/customwidgets/widgets/view/settings/templates/custom_widget_template.dart';
import 'package:smart_home/customwidgets/widgets/group/custom_group_widget.dart';
import 'package:smart_home/manager/connection/connection_manager.dart' as man;
import 'package:smart_home/manager/cubit/manager_cubit.dart';
import 'package:smart_home/manager/manager.dart';
import 'package:smart_home/notifications/bloc/notifications_bloc.dart';
import 'package:smart_home/notifications/view/notifications_log_view.dart';
import 'package:smart_home/settings/ioBroker_settings/view/iobroker_settings_page.dart';
import 'package:smart_home/utils/blinking_widget.dart';
import 'package:smart_home/view/main/cubit/main_view_cubit.dart';

import '../../screen/screen.dart';
import '../../screen/view/screen_menu_tabbar.dart';
import '../../settings/view/main_settings_screen.dart';

const double breakpoint = 800;
const int paneProportion = 70;

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      manager: context.read<Manager>(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final Manager manager;

  const MainScreen({Key? key, required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerCubit, ManagerState>(
      builder: (context, state) {
        switch (state.status) {
          case ManagerStatus.loading:
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Loading"),
                  actions: [
                    IconButton(
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationLogViewScreen()),
                              )
                            },
                        icon: const Icon(Icons.notifications)),
                    IconButton(
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MainSettingsScreen(manager: manager)),
                              )
                            },
                        icon: const Icon(Icons.settings)),
                  ],
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                ));
          case ManagerStatus.changeLog:
            return ChangeLogScreen(manager: manager);
          default:
            return const MainView();
        }
      },
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  late StreamController<int> _controller;
  int numberOfRows = 1;
  late StreamSubscription<man.ConnectionStatus> _ioConnectionSub;
  bool ioConnected = false;

  late TabController _tabController;

  @override
  void initState() {
    _controller = StreamController.broadcast();
    ioConnected = context.read<Manager>().connectionManager.ioBConnected;
    context
        .read<Manager>()
        .generalManager
        .dialogStreamController
        .stream
        .listen((event) {
      showDialog(context: context, builder: event);
    });

    _tabController = TabController(
      initialIndex: 0,
      length: 1,
      vsync: this,
    );

    super.initState();
  }

  int currentTab = 0;

  void onViewChange() {
    setState(() {});
  }

  @override
  void dispose() {
    //_tabController.dispose();
    //_tabController.removeListener(onViewChange);
    _controller.close();
    _ioConnectionSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 960.0) {
      numberOfRows = 2;
    }
    if (width >= 1300) {
      numberOfRows = 3;
    }
    if (width < 960.0) {
      numberOfRows = 1;
    }
    Manager manager = context.read<Manager>();

    return BlocBuilder<MainViewCubit, MainViewState>(
      bloc: MainViewCubit(),
      builder: (context, state) {
        List<Screen> screens =
            state.screens.where((element) => element.enabled).toList();
        _tabController = TabController(
          initialIndex: _tabController.index,
          length: screens.length,
          vsync: this,
        );
        _tabController.addListener(() {
          _controller.add(_tabController.index);
        });
        if (screens.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
          );
        }
        return Scaffold(
            appBar: AppBar(
              toolbarHeight: 90,
              centerTitle: true,
              leading: Container(
                child: _getAppBarStatus(state.connectionStatus),
              ),
              title: screens.isEmpty
                  ? const Text("Loading")
                  : StreamBuilder<int>(
                      stream: _controller.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Error");
                        }
                        return Text(screens[snapshot.data ?? 0].name);
                      },
                    ),
              actions: [
                StreamBuilder(
                  stream:
                      Manager.instance.notificationManager.notificationStream,
                  builder: (context, state) {
                    return Badge(
                      child: IconButton(
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationLogViewScreen())),
                        },
                        icon: const Icon(Icons.notifications),
                      ),
                      isLabelVisible: Manager.instance.notificationManager
                              .unreadNotifications >
                          0,
                      label: Manager.instance.notificationManager
                                  .unreadNotifications >
                              0
                          ? Text(
                              "${Manager.instance.notificationManager.unreadNotifications}")
                          : null,
                    );
                  },
                ),
                IconButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainSettingsScreen(manager: manager)),
                    )
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
              automaticallyImplyLeading: false,
              bottom: TabBar(
                tabAlignment: TabAlignment.start,
                onTap: (i) {
                  _controller.add(i);
                },
                indicatorWeight: 3,
                isScrollable: true,
                controller: _tabController,
                tabs: [
                  for (int i = 0; i < screens.length; i++)
                    ScreenTab(
                      screen: screens[i],
                    ),
                ],
              ),
            ),
            body: screens.isEmpty
                ? const Text("null")
                : TabBarView(
                    controller: _tabController,
                    children: [
                      for (int i = 0; i < screens.length; i++)
                        ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            Screen screen = screens[i];
                            List<dynamic> templates = screen.widgetTemplates;
                            List<List<dynamic>> rows =
                                List.generate(numberOfRows, (index) {
                              List<dynamic> row = [];
                              for (int i = index;
                                  i < templates.length;
                                  i += numberOfRows) {
                                row.add(templates[i]);
                              }
                              return row;
                            });
                            rows.removeWhere((element) => element.isEmpty);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (List<dynamic> t in rows)
                                  Expanded(
                                    child: Column(
                                      children: t.map((e) {
                                        if (e is CustomWidgetTemplate) {
                                          return Card(
                                            child: e.customWidget.widget,
                                          );
                                        } else if (e is CustomGroupWidget) {
                                          return Card(
                                            child: e.widget,
                                          );
                                        } else {
                                          return const Text("Error 404");
                                        }
                                      }).toList(),
                                    ),
                                  )
                              ],
                            );
                          },
                        )
                    ],
                  ));
      },
    );
  }

  Widget? _getAppBarStatus(man.ConnectionStatus connectionStatus) {
    debugPrint("AppBar Status: ${connectionStatus.name}");
    int n = 0;
    BlinkingWidget blinkingWidget;
    switch (connectionStatus) {
      case man.ConnectionStatus.connected:
      case man.ConnectionStatus.loggedIn:
        blinkingWidget = BlinkingWidget(
          vsync: this,
          disablerAfter: const Duration(seconds: 3),
          invisibleAfter: true,
          child: const Icon(Icons.done, color: Colors.green),
        );
        break;
      case man.ConnectionStatus.loggingIn:
        blinkingWidget = BlinkingWidget(
          vsync: this,
          child: const Icon(
            Icons.login,
            color: Colors.orange,
          ),
        );
        break;
      case man.ConnectionStatus.loginDeclined:
        blinkingWidget = BlinkingWidget(
          vsync: this,
          child: const Icon(Icons.login, color: Colors.orange),
        );
        break;
      case man.ConnectionStatus.newAesKey:
        blinkingWidget = BlinkingWidget(
          vsync: this,
          child: const Icon(Icons.add_moderator, color: Colors.yellow),
        );
        break;
      case man.ConnectionStatus.wrongAdapterVersion:
        blinkingWidget = BlinkingWidget(
          vsync: this,
          child: const Icon(Icons.update, color: Colors.yellow),
        );
        break;
      case man.ConnectionStatus.emptyAES:
        blinkingWidget = BlinkingWidget(
          vsync: this,
          child: const Icon(Icons.add_moderator_outlined, color: Colors.red),
        );
        break;

      default:
        blinkingWidget = BlinkingWidget(
          vsync: this,
          child: IconButton(
              icon: const Icon(
                  Icons.signal_wifi_connected_no_internet_4_outlined,
                  color: Colors.red),
              onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => const IoBrokerSettingsPage()))
                  }),
        );
    }
    return blinkingWidget;
    /* if (connectionStatus.isConnected) {
      return BlinkingWidget(
        vsync: this,
        disablerAfter: const Duration(seconds: 3),
        invisibleAfter: true,
        child: const Icon(Icons.done, color: Colors.green),
      );
    } else if (connectionStatus == man.ConnectionStatus.loggingIn) {
      return BlinkingWidget(
        vsync: this,
        child: const Icon(
          Icons.login,
          color: Colors.orange,
        ),
      );
    } else if (connectionStatus == man.ConnectionStatus.loginDeclined) {
      return BlinkingWidget(
        vsync: this,
        child: const Icon(Icons.login, color: Colors.orange),
      );
    } else if (connectionStatus == man.ConnectionStatus.newAesKey) {
      return BlinkingWidget(
        vsync: this,
        child: const Icon(Icons.add_moderator, color: Colors.yellow),
      );
    } else if (connectionStatus == man.ConnectionStatus.emptyAES) {
      return BlinkingWidget(
        vsync: this,
        child: const Icon(Icons.add_moderator_outlined, color: Colors.red),
      );
    } else {
      return BlinkingWidget(
        vsync: this,
        child: IconButton(
            icon: const Icon(Icons.signal_wifi_connected_no_internet_4_outlined,
                color: Colors.red),
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => const IoBrokerSettingsPage()))
                }),
      );
    }*/
  }
}
