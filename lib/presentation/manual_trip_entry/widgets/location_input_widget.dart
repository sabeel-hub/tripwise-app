import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationInputWidget extends StatefulWidget {
  final String label;
  final String? value;
  final Function(String) onChanged;
  final bool isRequired;
  final String hintText;

  const LocationInputWidget({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    this.isRequired = false,
    required this.hintText,
  });

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  final List<Map<String, dynamic>> _recentLocations = [
    {
      "name": "Home",
      "address": "123 Main Street, Springfield, IL 62701",
      "type": "home",
    },
    {
      "name": "Office",
      "address": "456 Business Ave, Springfield, IL 62702",
      "type": "work",
    },
    {
      "name": "Springfield Mall",
      "address": "789 Shopping Blvd, Springfield, IL 62703",
      "type": "shopping",
    },
    {
      "name": "Central Park",
      "address": "321 Park Drive, Springfield, IL 62704",
      "type": "recreation",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isRequired ? '${widget.label} *' : widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (value) {
                  widget.onChanged(value);
                  setState(() {
                    _showSuggestions = value.isNotEmpty && _focusNode.hasFocus;
                  });
                },
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'location_on',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                            widget.onChanged('');
                            setState(() {});
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            // Show map picker
                            _showMapPicker(context);
                          },
                          icon: CustomIconWidget(
                            iconName: 'map',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
              ),
              if (_showSuggestions && _controller.text.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _getFilteredSuggestions().length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = _getFilteredSuggestions()[index];
                      return ListTile(
                        dense: true,
                        leading: CustomIconWidget(
                          iconName:
                              _getLocationIcon(suggestion["type"] as String),
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        title: Text(
                          suggestion["name"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          suggestion["address"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        onTap: () {
                          _controller.text = suggestion["address"] as String;
                          widget.onChanged(suggestion["address"] as String);
                          _focusNode.unfocus();
                          setState(() {
                            _showSuggestions = false;
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredSuggestions() {
    final query = _controller.text.toLowerCase();
    return _recentLocations.where((location) {
      final name = (location["name"] as String).toLowerCase();
      final address = (location["address"] as String).toLowerCase();
      return name.contains(query) || address.contains(query);
    }).toList();
  }

  String _getLocationIcon(String type) {
    switch (type) {
      case 'home':
        return 'home';
      case 'work':
        return 'business';
      case 'shopping':
        return 'shopping_cart';
      case 'recreation':
        return 'park';
      default:
        return 'place';
    }
  }

  void _showMapPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Location',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'map',
                        color: Theme.of(context).colorScheme.primary,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Map Integration',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Interactive map will be available here',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
