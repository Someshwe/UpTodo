import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/empty_state.dart';
import '../widgets/add_edit_task_dialog.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/theme_provider.dart';
import '../../../core/widgets/glass_effect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditTaskDialog(
        onSave: (title, description, dueDate) {
          context.read<TaskProvider>().addTask(
            title,
            description: description,
            dueDate: dueDate,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✨ Task added!'),
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AddEditTaskDialog(
        task: task,
        onSave: (title, description, dueDate) {
          context.read<TaskProvider>().updateTask(
            task.id,
            title: title,
            description: description,
            dueDate: dueDate,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✨ Task updated!'),
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    await themeProvider.toggleTheme();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeProvider.isDarkMode
                          ? AppColors.glassDark.withOpacity(0.7)
                          : Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: themeProvider.isDarkMode
                            ? AppColors.accentCyan.withOpacity(0.5)
                            : AppColors.accentCyan.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      themeProvider.isDarkMode
                          ? Icons.brightness_4_rounded
                          : Icons.brightness_7_rounded,
                      color: AppColors.accentCyan,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          return Column(
            children: [
              // Stats Bar with Modern Glass Effect
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: GlassEffect(
                  blur: 15,
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.glassDark,
                  opacity: 0.7,
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total',
                        taskProvider.totalCount.toString(),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.15),
                      ),
                      _buildStatItem(
                        'Completed',
                        taskProvider.completedCount.toString(),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.15),
                      ),
                      _buildStatItem(
                        'Pending',
                        (taskProvider.totalCount - taskProvider.completedCount)
                            .toString(),
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Tabs
              FilterTabs(
                selectedFilter: taskProvider.filterType,
                onFilterChanged: (filter) {
                  taskProvider.setFilter(filter);
                },
              ),

              // Task List
              Expanded(
                child: taskProvider.tasks.isEmpty
                    ? const EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: taskProvider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.tasks[index];
                          return TaskCard(
                            task: task,
                            onDelete: () {
                              taskProvider.deleteTask(task.id);
                            },
                            onEdit: () {
                              _showEditTaskDialog(task);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryGradient1, AppColors.primaryGradient2],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGradient1.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showAddTaskDialog,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(Icons.add_rounded, size: 28, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.accentCyan,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
