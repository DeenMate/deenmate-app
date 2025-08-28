import 'package:flutter/material.dart';

import '../../../../core/theme/theme_helper.dart';

/// Widget for displaying and managing search history
class SearchHistoryWidget extends StatelessWidget {
  const SearchHistoryWidget({
    super.key,
    required this.onHistoryItemTap,
    required this.onClearHistory,
    required this.history,
  });

  final List<String> history;
  final ValueChanged<String> onHistoryItemTap;
  final VoidCallback onClearHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeHelper.getCardColor(context),
            border: Border(
              bottom: BorderSide(
                color: ThemeHelper.getDividerColor(context),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: ThemeHelper.getPrimaryColor(context),
              ),
              const SizedBox(width: 8),
              Text(
                'Search History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showClearConfirmation(context),
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
            ],
          ),
        ),
        
        // History list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final query = history[index];
              return Card(
                elevation: 1,
                color: ThemeHelper.getCardColor(context),
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                  title: Text(
                    query,
                    style: TextStyle(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Tap to search again',
                    style: TextStyle(
                      color: ThemeHelper.getTextSecondaryColor(context),
                      fontSize: 12,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.north_west,
                      color: ThemeHelper.getTextSecondaryColor(context),
                      size: 16,
                    ),
                    onPressed: () => onHistoryItemTap(query),
                    tooltip: 'Use this search',
                  ),
                  onTap: () => onHistoryItemTap(query),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeHelper.getCardColor(context),
        title: Text(
          'Clear Search History',
          style: TextStyle(
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        content: Text(
          'Are you sure you want to clear all search history? This action cannot be undone.',
          style: TextStyle(
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onClearHistory();
            },
            child: Text(
              'Clear',
              style: TextStyle(
                color: ThemeHelper.getPrimaryColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
