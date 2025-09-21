import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/app_export.dart';

class LegalLinksWidget extends StatelessWidget {
  const LegalLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'gavel',
                  color: AppTheme.textSecondary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Legal & Support',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          _buildLegalLink(
            context: context,
            theme: theme,
            icon: 'policy',
            title: 'Privacy Policy',
            subtitle: 'How we collect and use your data',
            hasUpdate: true,
            onTap: () => _openWebView(
              context,
              'Privacy Policy',
              'https://tripwise.app/privacy-policy',
            ),
          ),
          _buildDivider(theme),
          _buildLegalLink(
            context: context,
            theme: theme,
            icon: 'description',
            title: 'Terms of Service',
            subtitle: 'Usage terms and conditions',
            hasUpdate: false,
            onTap: () => _openWebView(
              context,
              'Terms of Service',
              'https://tripwise.app/terms-of-service',
            ),
          ),
          _buildDivider(theme),
          _buildLegalLink(
            context: context,
            theme: theme,
            icon: 'help',
            title: 'Help & Support',
            subtitle: 'Get help with app features',
            hasUpdate: false,
            onTap: () => _openWebView(
              context,
              'Help & Support',
              'https://tripwise.app/support',
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildLegalLink({
    required BuildContext context,
    required ThemeData theme,
    required String icon,
    required String title,
    required String subtitle,
    required bool hasUpdate,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (hasUpdate) ...[
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.5.w, vertical: 0.3.h),
                          decoration: BoxDecoration(
                            color: AppTheme.errorRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Updated',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'open_in_new',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _openWebView(BuildContext context, String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _WebViewScreen(title: title, url: url),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.colorScheme.outline.withValues(alpha: 0.2),
      ),
    );
  }
}

class _WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const _WebViewScreen({
    required this.title,
    required this.url,
  });

  @override
  State<_WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<_WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _controller.reload(),
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: theme.scaffoldBackgroundColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.primaryBlue,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Loading ${widget.title}...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
