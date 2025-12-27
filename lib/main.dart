import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const IranDigitalSchoolApp());
}

// ============================================================================
// THEME & CONSTANTS
// ============================================================================

class AppColors {
  static const Color background = Color(0xFF1A1A1A);
  static const Color cardBackground = Color(0xFF2A2A2A);
  static const Color cardBackgroundLight = Color(0xFF323232);
  static const Color cardBorder = Color(0xFF3A3A3A);
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF707070);
  static const Color inputBackground = Color(0xFF252525);
  static const Color inputBorder = Color(0xFF404040);
  static const Color success = Color(0xFF4CAF50);
  static const Color courseBlue = Color(0xFF1E3A5F);
  static const Color courseBlueBorder = Color(0xFF2D5A87);
}

// ============================================================================
// MAIN APP
// ============================================================================

class IranDigitalSchoolApp extends StatelessWidget {
  const IranDigitalSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مدرسه دیجیتال ایران',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Yekan',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.primaryLight,
          surface: AppColors.cardBackground,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}

// ============================================================================
// BACKGROUND WIDGET
// ============================================================================

class NoiseBackground extends StatelessWidget {
  final Widget child;

  const NoiseBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),
        // Grey overlay with 50% opacity
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.25),
          ),
        ),
        child,
      ],
    );
  }
}

// ============================================================================
// FOCUSABLE WRAPPER
// ============================================================================

class FocusableItem extends StatefulWidget {
  final Widget Function(bool isFocused) builder;
  final VoidCallback? onSelect;
  final bool autofocus;
  final FocusNode? focusNode;

  const FocusableItem({
    super.key,
    required this.builder,
    this.onSelect,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<FocusableItem> createState() => _FocusableItemState();
}

class _FocusableItemState extends State<FocusableItem> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          widget.onSelect?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        onEnter: (_) => _focusNode.requestFocus(),
        child: GestureDetector(
          onTap: widget.onSelect,
          child: widget.builder(_isFocused),
        ),
      ),
    );
  }
}

// ============================================================================
// COMMON WIDGETS
// ============================================================================

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final bool hasBorder;
  final Color? backgroundColor;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.hasBorder = true,
    this.backgroundColor,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground.withOpacity(0.85),
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(color: AppColors.cardBorder.withOpacity(0.5), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool autofocus;
  final double? width;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.autofocus = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      autofocus: autofocus,
      onSelect: onPressed,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isFocused
                ? [AppColors.primaryLight, AppColors.primary]
                : [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          border: isFocused
              ? Border.all(color: Colors.white.withOpacity(0.5), width: 2)
              : null,
          boxShadow: isFocused
              ? [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2)
                ]
              : [],
        ),
        transform: Matrix4.identity()..scale(isFocused ? 1.03 : 1.0),
        transformAlignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool autofocus;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      autofocus: autofocus,
      onSelect: onPressed,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFocused ? AppColors.primary : AppColors.cardBorder,
            width: isFocused ? 2 : 1,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 1)
                ]
              : [],
        ),
        transform: Matrix4.identity()..scale(isFocused ? 1.03 : 1.0),
        transformAlignment: Alignment.center,
        child: Text(text,
            style: TextStyle(
                color: isFocused ? AppColors.primary : AppColors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onPressed;
  final bool autofocus;

  const TabButton({
    super.key,
    required this.text,
    required this.isSelected,
    this.onPressed,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      autofocus: autofocus,
      onSelect: onPressed,
      builder: (isFocused) {
        final isActive = isSelected || isFocused;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark])
                : null,
            color: isSelected ? null : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.cardBorder,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Text(text,
              style: TextStyle(
                  color: isActive ? Colors.white : AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        );
      },
    );
  }
}

// ============================================================================
// SPLASH SCREEN
// ============================================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ProfileSelectionScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity:
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoiseBackground(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(width: 24),
                    const Text('مدرسه دیجیتال ایران',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PROFILE SELECTION SCREEN
// ============================================================================

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  static const List<Map<String, dynamic>> _profiles = [
    {'name': 'هاشمی', 'color': Color(0xFF2E7D32)},
    {'name': 'محمدی', 'color': Color(0xFF5D4037)},
    {'name': 'فرهمند', 'color': Color(0xFF1A237E)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoiseBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('لطفا پروفایل اکانت خود را انتخاب کنید',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add Profile Button
                _AddProfileButton(
                  onSelect: () => Navigator.of(context)
                      .push(_createRoute(const LoginScreen())),
                ),
                const SizedBox(width: 24),
                // Profiles
                ..._profiles.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _ProfileItem(
                        profile: entry.value,
                        autofocus: entry.key == 0,
                        onSelect: () => Navigator.of(context).pushReplacement(
                            _createRoute(const HomeScreen(isGuest: false))),
                      ),
                    )),
                const SizedBox(width: 24),
                // Guest Profile
                _GuestProfileButton(
                  onSelect: () => Navigator.of(context).pushReplacement(
                      _createRoute(const HomeScreen(isGuest: true))),
                ),
              ],
            ),
            const SizedBox(height: 80),
            SecondaryButton(text: 'انصراف', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

// Smooth page transition
Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.02, 0), end: Offset.zero)
                  .animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class _AddProfileButton extends StatelessWidget {
  final VoidCallback onSelect;
  const _AddProfileButton({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onSelect,
      builder: (isFocused) => Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardBackground,
              border: Border.all(
                color: isFocused ? AppColors.primary : AppColors.cardBorder,
                width: isFocused ? 3 : 2,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2)
                    ]
                  : [],
            ),
            transform: Matrix4.identity()..scale(isFocused ? 1.06 : 1.0),
            transformAlignment: Alignment.center,
            child: Icon(Icons.add,
                size: 60,
                color: isFocused ? AppColors.primary : AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              color:
                  isFocused ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 18,
              fontWeight: isFocused ? FontWeight.w600 : FontWeight.w400,
            ),
            child: const Text('اضافه کردن'),
          ),
        ],
      ),
    );
  }
}

class _GuestProfileButton extends StatelessWidget {
  final VoidCallback onSelect;
  const _GuestProfileButton({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onSelect,
      builder: (isFocused) => Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardBackground.withOpacity(0.5),
              border: Border.all(
                color: isFocused
                    ? AppColors.primary
                    : AppColors.cardBorder.withOpacity(0.5),
                width: isFocused ? 3 : 2,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2)
                    ]
                  : [],
            ),
            transform: Matrix4.identity()..scale(isFocused ? 1.06 : 1.0),
            transformAlignment: Alignment.center,
            child: Icon(Icons.person_outline_rounded,
                size: 60,
                color: isFocused
                    ? AppColors.primary
                    : AppColors.textSecondary.withOpacity(0.7)),
          ),
          const SizedBox(height: 16),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              color: isFocused
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withOpacity(0.7),
              fontSize: 18,
              fontWeight: isFocused ? FontWeight.w600 : FontWeight.w400,
            ),
            child: const Text('مهمان'),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final Map<String, dynamic> profile;
  final VoidCallback onSelect;
  final bool autofocus;

  const _ProfileItem(
      {required this.profile, required this.onSelect, this.autofocus = false});

  @override
  Widget build(BuildContext context) {
    final isDefault = profile['isDefault'] == true;
    final color = profile['color'] as Color? ?? AppColors.primary;

    return FocusableItem(
      autofocus: autofocus,
      onSelect: onSelect,
      builder: (isFocused) => Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDefault ? AppColors.primary : color,
              border: Border.all(
                color: isFocused ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 25,
                          spreadRadius: 3)
                    ]
                  : [],
            ),
            transform: Matrix4.identity()..scale(isFocused ? 1.08 : 1.0),
            transformAlignment: Alignment.center,
            child: isDefault
                ? const _DefaultAvatarIcon()
                : Icon(Icons.person,
                    size: 70, color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 16),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              color:
                  isFocused ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 18,
              fontWeight: isFocused ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(profile['name']),
          ),
        ],
      ),
    );
  }
}

class _DefaultAvatarIcon extends StatelessWidget {
  const _DefaultAvatarIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80, height: 80, child: CustomPaint(painter: _AvatarPainter()));
  }
}

class _AvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1565C0)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.3), size.width * 0.25, paint);
    final bodyPath = Path()
      ..moveTo(size.width * 0.15, size.height)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.55,
          size.width * 0.5, size.height * 0.55)
      ..quadraticBezierTo(
          size.width * 0.85, size.height * 0.55, size.width * 0.85, size.height)
      ..close();
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// LOGIN SCREEN
// ============================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPhoneLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoiseBackground(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _isPhoneLogin
                      ? const PhoneLoginContent(key: ValueKey('phone'))
                      : const QRLoginContent(key: ValueKey('qr')),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabButton(
                    text: 'ورود با تلفن همراه',
                    isSelected: _isPhoneLogin,
                    autofocus: _isPhoneLogin,
                    onPressed: () => setState(() => _isPhoneLogin = true),
                  ),
                  const SizedBox(width: 16),
                  TabButton(
                    text: 'ورود با QR Code',
                    isSelected: !_isPhoneLogin,
                    onPressed: () => setState(() => _isPhoneLogin = false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneLoginContent extends StatefulWidget {
  const PhoneLoginContent({super.key});
  @override
  State<PhoneLoginContent> createState() => _PhoneLoginContentState();
}

class _PhoneLoginContentState extends State<PhoneLoginContent> {
  final _phoneController = TextEditingController();
  final _inputFocusNode = FocusNode();
  bool _isInputFocused = false;

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(
        () => setState(() => _isInputFocused = _inputFocusNode.hasFocus));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 500,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ورود با تلفن همراه',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          const Text('شماره موبایل خود را وارد کنید تا وارد حساب کاربری شوید.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 32),
          Focus(
            focusNode: _inputFocusNode,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: _isInputFocused
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    width: _isInputFocused ? 2 : 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'لطفا شماره تلفن خود را وارد کنید',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.phone_android,
                      color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'ارسال کد تایید',
            onPressed: () => Navigator.of(context)
                .push(_createRoute(const OTPVerificationScreen())),
          ),
        ],
      ),
    );
  }
}

class QRLoginContent extends StatelessWidget {
  const QRLoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 800,
      padding: const EdgeInsets.all(40),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'برای ورود به اپ، لطفاً این QR Code را با موبایل خود اسکن کنید.',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        height: 1.6)),
                SizedBox(height: 16),
                Text(
                    'بعد از اسکن، صفحه‌ی ورود روی گوشی شما باز می‌شود و می‌توانید وارد حساب کاربری‌تان شوید.',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.6)),
                SizedBox(height: 24),
                Text(
                    'پس از ورود، اطلاعات شما به‌طور خودکار روی تلویزیون نمایش داده می‌شود و وارد محیط برنامه خواهید شد.',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.6)),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(16),
            child: CustomPaint(
                painter: QRCodePainter(), size: const Size(188, 188)),
          ),
        ],
      ),
    );
  }
}

class QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final cellSize = size.width / 25;
    final random = math.Random(12345);

    _drawCornerSquare(canvas, paint, 0, 0, cellSize);
    _drawCornerSquare(canvas, paint, size.width - cellSize * 7, 0, cellSize);
    _drawCornerSquare(canvas, paint, 0, size.height - cellSize * 7, cellSize);

    for (int i = 0; i < 25; i++) {
      for (int j = 0; j < 25; j++) {
        if ((i < 8 && j < 8) || (i < 8 && j > 16) || (i > 16 && j < 8)) {
          continue;
        }
        if (random.nextBool()) {
          canvas.drawRect(
              Rect.fromLTWH(i * cellSize, j * cellSize, cellSize, cellSize),
              paint);
        }
      }
    }
  }

  void _drawCornerSquare(
      Canvas canvas, Paint paint, double x, double y, double cellSize) {
    canvas.drawRect(Rect.fromLTWH(x, y, cellSize * 7, cellSize * 7), paint);
    canvas.drawRect(
        Rect.fromLTWH(x + cellSize, y + cellSize, cellSize * 5, cellSize * 5),
        Paint()..color = Colors.white);
    canvas.drawRect(
        Rect.fromLTWH(
            x + cellSize * 2, y + cellSize * 2, cellSize * 3, cellSize * 3),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// OTP VERIFICATION SCREEN - WITH WORKING INPUT (LTR)
// ============================================================================

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});
  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) setState(() => _focusedIndex = i);
      });
    }
    // Focus the leftmost field first (index 4 in RTL, but we want LTR input)
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNodes[0].requestFocus());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  String _toPersianDigit(String digit) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    final idx = english.indexOf(digit);
    return idx >= 0 ? persian[idx] : digit;
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      final lastChar = value[value.length - 1];
      if (RegExp(r'[0-9]').hasMatch(lastChar)) {
        _controllers[index].text = _toPersianDigit(lastChar);
        _controllers[index].selection =
            const TextSelection.collapsed(offset: 1);
        // Move to next field (left to right)
        if (index < 4) {
          _focusNodes[index + 1].requestFocus();
        }
      } else {
        _controllers[index].text = '';
      }
    }
    setState(() {});
  }

  void _onKeyPress(int index, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
        } else {
          _controllers[index].clear();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          index < 4) {
        _focusNodes[index + 1].requestFocus();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoiseBackground(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: GlassCard(
                  width: 550,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('ورود با تلفن همراه',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      const Text(
                          'برای ورود، کد ارسال‌شده به موبایل خود را وارد کنید.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 16)),
                      const SizedBox(height: 40),
                      // OTP fields in LTR order
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              5,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: _buildOTPField(index),
                                  )),
                        ),
                      ),
                      const SizedBox(height: 40),
                      PrimaryButton(
                        text: 'ورود به حساب',
                        onPressed: () => Navigator.of(context).pushReplacement(
                            _createRoute(const CreateProfileScreen())),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabButton(
                      text: 'ورود با تلفن همراه',
                      isSelected: true,
                      onPressed: () {}),
                  const SizedBox(width: 16),
                  TabButton(
                      text: 'ورود با QR Code',
                      isSelected: false,
                      onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    final isFocused = _focusedIndex == index;
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) => _onKeyPress(index, event),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 70,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isFocused ? AppColors.primary : AppColors.inputBorder,
              width: isFocused ? 2 : 1),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1)
                ]
              : [],
        ),
        child: Center(
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 2,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 36,
                fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => _onDigitChanged(index, value),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CREATE PROFILE SCREEN
// ============================================================================

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _nameController = TextEditingController();
  final _inputFocusNode = FocusNode();
  bool _isInputFocused = false;

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(
        () => setState(() => _isInputFocused = _inputFocusNode.hasFocus));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoiseBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ساختن پروفایل جدید',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 48),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.primary
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5)
                  ],
                ),
                child: const Center(child: _DefaultAvatarIcon()),
              ),
              const SizedBox(height: 40),
              Focus(
                focusNode: _inputFocusNode,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  width: 400,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _isInputFocused
                            ? AppColors.primary
                            : AppColors.inputBorder,
                        width: _isInputFocused ? 2 : 1),
                  ),
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: 'لطفا نام خود را وارد کنید',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'ورود',
                autofocus: true,
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    _createRoute(const HomeScreen(isGuest: false)),
                    (route) => false),
              ),
              const SizedBox(height: 48),
              SecondaryButton(
                  text: 'انصراف', onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HOME SCREEN
// ============================================================================

class HomeScreen extends StatefulWidget {
  final bool isGuest;
  const HomeScreen({super.key, this.isGuest = false});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sidebarExpanded = false;
  int _selectedNavIndex = 0;
  String? _selectedCourse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isGuest) {
        _showGuestLoginDialog();
      } else {
        _showPresidentialMessage();
      }
    });
  }

  void _showGuestLoginDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (_) => const GuestLoginDialog());
  }

  void _showPresidentialMessage() {
    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (_) => const PresidentialMessageDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoiseBackground(
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            // MAIN CONTENT - pushes left when sidebar expands
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 24, 24),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('کلاس شروع شد؛ آماده‌ایم با هم',
                                    style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold)),
                                const Text('یک چیز تازه یاد بگیریم',
                                    style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 24),
                                PrimaryButton(
                                    text: 'شروع کلاس',
                                    icon: Icons.play_arrow_rounded,
                                    onPressed: () {}),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                          const SizedBox(width: 480, child: PersianCalendar()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      child: _selectedCourse != null
                          ? _CourseDetailSection(
                              courseName: _selectedCourse!,
                              onBack: () =>
                                  setState(() => _selectedCourse = null))
                          : _TodayLessonsSection(
                              onCourseSelect: (n) =>
                                  setState(() => _selectedCourse = n),
                              isGuest: widget.isGuest),
                    ),
                  ],
                ),
              ),
            ),
            // SIDEBAR - pushes content when expanded
            _Sidebar(
              expanded: _sidebarExpanded,
              selectedIndex: _selectedNavIndex,
              onHover: (e) => setState(() => _sidebarExpanded = e),
              onSelect: (i) => setState(() => _selectedNavIndex = i),
              onLogout: () => Navigator.of(context).pushAndRemoveUntil(
                  _createRoute(const ProfileSelectionScreen()),
                  (route) => false),
              isGuest: widget.isGuest,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SIDEBAR - OVERLAY WITH GRADIENT FADE
// ============================================================================

class _Sidebar extends StatelessWidget {
  final bool expanded;
  final int selectedIndex;
  final Function(bool) onHover;
  final Function(int) onSelect;
  final VoidCallback onLogout;
  final bool isGuest;

  const _Sidebar({
    required this.expanded,
    required this.selectedIndex,
    required this.onHover,
    required this.onSelect,
    required this.onLogout,
    this.isGuest = false,
  });

  List<Map<String, dynamic>> get _navItems {
    final items = [
      {'icon': Icons.home_filled, 'label': 'صفحه اصلی'},
      {'icon': Icons.search_rounded, 'label': 'جستجو'},
      {'icon': Icons.play_circle_filled_rounded, 'label': 'شروع کلاس'},
      {'icon': Icons.grid_view_rounded, 'label': 'کلاس‌ها'},
      {'icon': Icons.play_circle_outline_rounded, 'label': 'ویدیوهای آموزشی'},
      {'icon': Icons.settings_rounded, 'label': 'تنظیمات'},
    ];
    // Only add profile for non-guest users
    if (!isGuest) {
      items.add({'icon': Icons.person_outline_rounded, 'label': 'پروفایل'});
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _navItems;
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: expanded ? 260 : 72,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(), // Required for clipBehavior
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Gradient background - dark on right, fading to left
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: expanded
                      ? [
                          const Color(0xFF0D0D0D),
                          const Color(0xF50D0D0D),
                          const Color(0xE00D0D0D),
                          const Color(0xA00D0D0D),
                          const Color(0x000D0D0D),
                        ]
                      : [
                          const Color(0xFF0D0D0D).withOpacity(0.8),
                          Colors.transparent,
                        ],
                  stops: expanded ? [0.0, 0.2, 0.4, 0.7, 1.0] : [0.0, 1.0],
                ),
              ),
            ),
            // Content
            Column(
              children: [
                const SizedBox(height: 28),
                // Logo
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: expanded ? 18 : 14),
                  child: _buildLogo(),
                ),
                const SizedBox(height: 36),
                // Nav Items
                Expanded(
                  child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: expanded ? 14 : 8),
                    itemCount: navItems.length,
                    itemBuilder: (context, index) {
                      final item = navItems[index];
                      return _SidebarItem(
                        icon: item['icon'] as IconData,
                        label: item['label'] as String,
                        isSelected: selectedIndex == index,
                        expanded: expanded,
                        onSelect: () => onSelect(index),
                      );
                    },
                  ),
                ),
                // Logout Button
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 28,
                      left: expanded ? 14 : 8,
                      right: expanded ? 14 : 8),
                  child: _SidebarItem(
                      icon: Icons.logout_rounded,
                      label: 'خروج',
                      isSelected: false,
                      expanded: expanded,
                      onSelect: onLogout,
                      isLogout: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: expanded
            ? Row(
                key: const ValueKey('expanded'),
                children: [
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      )),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text('مدرسه دیجیتال ایران',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              )
            : Center(
                key: const ValueKey('collapsed'),
                child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    )),
              ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool expanded;
  final VoidCallback onSelect;
  final bool isLogout;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.expanded,
    required this.onSelect,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onSelect,
      builder: (isFocused) {
        final isActive = isSelected || isFocused;
        final iconColor = isLogout
            ? (isFocused ? Colors.red.shade300 : AppColors.textSecondary)
            : (isActive ? Colors.white : AppColors.textSecondary);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: 56,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: expanded ? 18 : 0),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark])
                : null,
            color: isFocused && !isSelected
                ? AppColors.cardBackgroundLight.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isFocused && !isSelected
                ? Border.all(color: AppColors.primary.withOpacity(0.5))
                : null,
          ),
          clipBehavior: Clip.hardEdge,
          child: expanded
              ? Row(
                  children: [
                    Icon(icon, size: 26, color: iconColor),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: isLogout
                              ? (isFocused
                                  ? Colors.red.shade300
                                  : AppColors.textSecondary)
                              : (isActive
                                  ? Colors.white
                                  : AppColors.textSecondary),
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(child: Icon(icon, size: 26, color: iconColor)),
        );
      },
    );
  }
}

// ============================================================================
// PERSIAN CALENDAR
// ============================================================================

class PersianCalendar extends StatefulWidget {
  const PersianCalendar({super.key});
  @override
  State<PersianCalendar> createState() => _PersianCalendarState();
}

class _PersianCalendarState extends State<PersianCalendar> {
  late Jalali _currentDate;
  late Jalali _displayedMonth;
  int _selectedDay = 5;

  @override
  void initState() {
    super.initState();
    _currentDate = Jalali.now();
    _displayedMonth = Jalali(_currentDate.year, _currentDate.month, 1);
    _selectedDay = _currentDate.day;
  }

  static const _weekDays = [
    'شنبه',
    '۱شنبه',
    '۲شنبه',
    '۳شنبه',
    '۴شنبه',
    '۵شنبه',
    'جمعه'
  ];
  static const _persianDigits = [
    '۰',
    '۱',
    '۲',
    '۳',
    '۴',
    '۵',
    '۶',
    '۷',
    '۸',
    '۹'
  ];

  String _toPersian(int number) => number
      .toString()
      .split('')
      .map((d) => _persianDigits[int.parse(d)])
      .join();

  static const _persianMonths = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند'
  ];

  String _getMonthName(int month) => _persianMonths[month - 1];

  void _previousMonth() {
    setState(() {
      _displayedMonth = _displayedMonth.copy(month: _displayedMonth.month - 1);
      if (_displayedMonth.month == 0) {
        _displayedMonth =
            _displayedMonth.copy(year: _displayedMonth.year - 1, month: 12);
      }
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = _displayedMonth.copy(month: _displayedMonth.month + 1);
      if (_displayedMonth.month == 13) {
        _displayedMonth =
            _displayedMonth.copy(year: _displayedMonth.year + 1, month: 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row - nav buttons on right, title in center, today button on left
        Row(
          children: [
            // Nav buttons - rounded squares (right side in RTL)
            _CalendarNavButton(
                icon: Icons.chevron_left_rounded, onPressed: _previousMonth),
            const SizedBox(width: 10),
            _CalendarNavButton(
                icon: Icons.chevron_right_rounded, onPressed: _nextMonth),
            // Spacer to push title to center
            const Expanded(child: SizedBox()),
            // Month title - centered
            Text(
                'تقویم ${_getMonthName(_displayedMonth.month)} ${_toPersian(_displayedMonth.year)}',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            // Spacer to keep title centered
            const Expanded(child: SizedBox()),
            // Today's schedule button - pill shaped (left side in RTL)
            FocusableItem(
              onSelect: () {},
              builder: (isFocused) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isFocused ? Colors.white : Colors.transparent,
                      width: 2),
                  boxShadow: isFocused
                      ? [
                          BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 12)
                        ]
                      : [],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 20, color: Colors.white),
                    SizedBox(width: 10),
                    Text('برنامه امروز',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Week day headers
        Row(
          children: _weekDays.map((day) {
            final isWeekend = day == 'جمعه' ||
                day == '۵شنبه'; // Thursday & Friday are weekend
            return Expanded(
              child: Center(
                child: Text(day,
                    style: TextStyle(
                        color: isWeekend ? Colors.red : AppColors.textSecondary,
                        fontSize: 14)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        // Calendar days grid - 6 weeks to handle all months
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: List.generate(7, (dayIndex) {
                final dayOfMonth = weekIndex * 7 + dayIndex + 1;
                final firstDayOfMonth =
                    Jalali(_displayedMonth.year, _displayedMonth.month, 1);
                final monthLength = firstDayOfMonth.monthLength;
                final firstDayWeekday =
                    firstDayOfMonth.weekDay - 1; // 0 = Saturday

                // Calculate which day this cell represents
                final actualDay = dayOfMonth - firstDayWeekday;

                if (actualDay < 1 || actualDay > monthLength) {
                  // Empty cell
                  return const Expanded(child: SizedBox());
                }

                final isToday = _currentDate.year == _displayedMonth.year &&
                    _currentDate.month == _displayedMonth.month &&
                    _currentDate.day == actualDay;
                final isSelected = actualDay == _selectedDay && !isToday;
                final isWeekend =
                    dayIndex == 5 || dayIndex == 6; // Thursday & Friday

                return Expanded(
                  child: _CalendarDay(
                      day: _toPersian(actualDay),
                      isSelected: isSelected,
                      isWeekend: isWeekend,
                      isToday: isToday,
                      onSelect: () => setState(() => _selectedDay = actualDay)),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _CalendarNavButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onPressed,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isFocused ? AppColors.primary : const Color(0xFF333333),
              width: isFocused ? 2 : 1),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.3), blurRadius: 8)
                ]
              : [],
        ),
        child: Icon(icon,
            color: isFocused ? AppColors.primary : Colors.white, size: 28),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isWeekend;
  final bool isToday;
  final VoidCallback onSelect;

  const _CalendarDay(
      {required this.day,
      required this.isSelected,
      required this.isWeekend,
      this.isToday = false,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onSelect,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isToday
                  ? AppColors.primary.withOpacity(0.2)
                  : isFocused
                      ? AppColors.cardBackgroundLight
                      : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isToday
              ? Border.all(color: AppColors.primary, width: 2)
              : isFocused && !isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
        ),
        child: Center(
          child: Text(day,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? AppColors.primary
                        : isWeekend
                            ? Colors.red
                            : AppColors.textPrimary,
                fontSize: 16,
                fontWeight:
                    (isSelected || isToday) ? FontWeight.w600 : FontWeight.w400,
              )),
        ),
      ),
    );
  }
}

// ============================================================================
// TODAY LESSONS SECTION
// ============================================================================

class _TodayLessonsSection extends StatelessWidget {
  final Function(String) onCourseSelect;
  final bool isGuest;
  const _TodayLessonsSection(
      {required this.onCourseSelect, this.isGuest = false});

  static const _courses = [
    {
      'name': 'کلاس شیمی',
      'subtitle': 'ادامه درس پیوندها',
      'page': '۲۴',
      'icon': Icons.science_rounded,
      'session': '۳',
    },
    {
      'name': 'کلاس ریاضی',
      'subtitle': 'ادامه درس اتحاد ها',
      'page': '۳۲',
      'icon': Icons.calculate_rounded,
      'session': '۵',
    },
    {
      'name': 'کلاس تاریخ',
      'subtitle': 'ادامه درس ۱۲',
      'page': '۳۰',
      'icon': Icons.history_edu_rounded,
      'session': '۲',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text('درس‌های امروز',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 8, bottom: 16),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: _CourseCard(
                    name: course['name'] as String,
                    subtitle: course['subtitle'] as String,
                    page: course['page'] as String,
                    icon: course['icon'] as IconData,
                    autofocus: index == 0,
                    onSelect: () {
                      Navigator.of(context).push(_createRoute(
                        SingleClassScreen(
                          className: course['name'] as String,
                          subtitle: course['subtitle'] as String,
                          session: course['session'] as String,
                          page: course['page'] as String,
                          isGuest: isGuest,
                        ),
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String page;
  final IconData icon;
  final bool autofocus;
  final VoidCallback onSelect;

  const _CourseCard({
    required this.name,
    required this.subtitle,
    required this.page,
    required this.icon,
    this.autofocus = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      autofocus: autofocus,
      onSelect: onSelect,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 500,
        height: 200,
        decoration: BoxDecoration(
          color: isFocused ? AppColors.courseBlue : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isFocused
                ? AppColors.primary
                : AppColors.cardBorder.withOpacity(0.4),
            width: isFocused ? 3 : 1,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2)
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          textDirection:
              TextDirection.ltr, // Force LTR so illustration is on left
          children: [
            // LEFT side - Illustration (clipped on the left edge)
            SizedBox(
              width: 220,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Monitor - positioned to extend past left edge
                  Positioned(
                    left: -40,
                    top: 10,
                    bottom: 10,
                    child: _CardMonitor(courseName: name, isFocused: isFocused),
                  ),
                  // Book at bottom center
                  Positioned(
                    bottom: -15,
                    left: 60,
                    child: _CardBook(isFocused: isFocused),
                  ),
                  // Test tube for chemistry (top right of illustration area)
                  if (name.contains('شیمی'))
                    Positioned(
                        top: 15,
                        right: 10,
                        child: _CardTestTube(isFocused: isFocused)),
                  // Compass for math (top left, partially clipped)
                  if (name.contains('ریاضی'))
                    Positioned(
                        top: 10,
                        left: -10,
                        child: _CardCompass(isFocused: isFocused)),
                ],
              ),
            ),
            // RIGHT side - Text content (RTL for proper Persian text alignment)
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Start = RIGHT in RTL
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(subtitle,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 16)),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 14, color: Colors.white.withOpacity(0.6)),
                          const SizedBox(width: 6),
                          Text('آخرین مطلب گفته شده: صفحه $page',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13)),
                        ],
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

// Card monitor illustration
class _CardMonitor extends StatelessWidget {
  final String courseName;
  final bool isFocused;
  const _CardMonitor({required this.courseName, required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Monitor screen
        Container(
          width: 180,
          height: 110,
          decoration: BoxDecoration(
            color: const Color(0xFF1E4A70),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF3A7AAC), width: 6),
          ),
          padding: const EdgeInsets.all(12),
          child: _getFormulas(),
        ),
        // Monitor stand
        Container(width: 28, height: 18, color: const Color(0xFF3A7AAC)),
        // Monitor base
        Container(
          width: 55,
          height: 5,
          decoration: BoxDecoration(
              color: const Color(0xFF2A5A8C),
              borderRadius: BorderRadius.circular(3)),
        ),
      ],
    );
  }

  Widget _getFormulas() {
    if (courseName.contains('شیمی')) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CH₂+H₂→CH₄',
              style: TextStyle(
                  color: Colors.white, fontSize: 11, fontFamily: 'Yekan')),
          Text('HCl→H⁺+Cl⁻',
              style: TextStyle(
                  color: Colors.white, fontSize: 10, fontFamily: 'Yekan')),
          Text('H₂SO₄→2H⁺+SO₄²⁻',
              style: TextStyle(
                  color: Colors.white, fontSize: 9, fontFamily: 'Yekan')),
        ],
      );
    } else if (courseName.contains('ریاضی')) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('a²+b²=c²',
              style: TextStyle(
                  color: Colors.white, fontSize: 12, fontFamily: 'Yekan')),
          Text('f(x)',
              style: TextStyle(
                  color: Colors.white, fontSize: 11, fontFamily: 'Yekan')),
          Text('x=−b±√b²−4ac/2a',
              style: TextStyle(
                  color: Colors.white, fontSize: 9, fontFamily: 'Yekan')),
        ],
      );
    }
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('تاریخ ایران',
            style: TextStyle(color: Colors.white, fontSize: 12)),
        Text('۱۴۰۴', style: TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}

// Book that clips outside card
class _CardBook extends StatelessWidget {
  final bool isFocused;
  const _CardBook({required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(90, 45),
      painter: _BookPainter(
          color: isFocused ? const Color(0xFF4A9AD8) : const Color(0xFF3A6A9C)),
    );
  }
}

class _BookPainter extends CustomPainter {
  final Color color;
  _BookPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final leftPage = Path()
      ..moveTo(size.width / 2, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.2, 0, 0, size.height * 0.3)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height * 0.8)
      ..close();
    canvas.drawPath(leftPage, paint);
    final rightPage = Path()
      ..moveTo(size.width / 2, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.8, 0, size.width, size.height * 0.3)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height * 0.8)
      ..close();
    canvas.drawPath(rightPage, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Test tube illustration
class _CardTestTube extends StatelessWidget {
  final bool isFocused;
  const _CardTestTube({required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(18, 55),
      painter: _TubePainter(
          color: isFocused ? const Color(0xFF4A9AD8) : const Color(0xFF3A6A9C)),
    );
  }
}

class _TubePainter extends CustomPainter {
  final Color color;
  _TubePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
          Rect.fromLTWH(2, 5, size.width - 4, size.height - 5),
          bottomLeft: const Radius.circular(8),
          bottomRight: const Radius.circular(8)),
      Paint()..color = color,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
          Rect.fromLTWH(
              4, size.height * 0.5, size.width - 8, size.height * 0.45),
          bottomLeft: const Radius.circular(6),
          bottomRight: const Radius.circular(6)),
      Paint()..color = const Color(0xFF6AB4F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Compass illustration
class _CardCompass extends StatelessWidget {
  final bool isFocused;
  const _CardCompass({required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(40, 60),
      painter: _CompassDrawPainter(
          color: isFocused ? const Color(0xFF4A9AD8) : const Color(0xFF3A6A9C)),
    );
  }
}

class _CompassDrawPainter extends CustomPainter {
  final Color color;
  _CompassDrawPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawLine(
        Offset(size.width / 2, 8), Offset(4, size.height - 4), paint);
    canvas.drawLine(Offset(size.width / 2, 8),
        Offset(size.width - 4, size.height - 4), paint);
    canvas.drawCircle(
        Offset(size.width / 2, 8), 5, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// COURSE DETAIL SECTION
// ============================================================================

class _CourseDetailSection extends StatelessWidget {
  final String courseName;
  final VoidCallback onBack;

  const _CourseDetailSection({required this.courseName, required this.onBack});

  static const _persianDigits = [
    '۰',
    '۱',
    '۲',
    '۳',
    '۴',
    '۵',
    '۶',
    '۷',
    '۸',
    '۹'
  ];
  String _toPersian(int number) => number
      .toString()
      .split('')
      .map((d) => _persianDigits[int.parse(d)])
      .join();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text('درس‌های ${courseName.replaceAll("کلاس ", "")}',
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: List.generate(3, (index) {
              final sessionNum = index + 1;
              final progress = sessionNum == 1
                  ? 1.0
                  : sessionNum == 2
                      ? 1.0
                      : 0.75;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: index < 2 ? 16 : 0),
                  child: _SessionCard(
                      sessionNumber: sessionNum,
                      progress: progress,
                      autofocus: index == 0),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final int sessionNumber;
  final double progress;
  final bool autofocus;

  const _SessionCard(
      {required this.sessionNumber,
      required this.progress,
      this.autofocus = false});

  static const _persianDigits = [
    '۰',
    '۱',
    '۲',
    '۳',
    '۴',
    '۵',
    '۶',
    '۷',
    '۸',
    '۹'
  ];
  String _toPersian(int number) => number
      .toString()
      .split('')
      .map((d) => _persianDigits[int.parse(d)])
      .join();

  @override
  Widget build(BuildContext context) {
    final isComplete = progress >= 1.0;

    return FocusableItem(
      autofocus: autofocus,
      onSelect: () {},
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.courseBlue,
              AppColors.courseBlue.withOpacity(0.85)
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isFocused ? AppColors.primary : AppColors.courseBlueBorder,
              width: isFocused ? 3 : 1),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2)
                ]
              : [],
        ),
        transform: Matrix4.identity()..scale(isFocused ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('جلسه ${_toPersian(sessionNumber)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    'فصل ${_toPersian(sessionNumber)}، ${sessionNumber == 1 ? "مقدمه" : sessionNumber == 2 ? "واکنش ها" : "محلول ها"} تا صفحه ${_toPersian(sessionNumber * 12 + 10)}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 13),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation(
                              isComplete
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isComplete)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.success, size: 20)
                      else
                        Text('${_toPersian((progress * 100).toInt())} درصد',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(Icons.science_rounded,
                  size: 44, color: Colors.white.withOpacity(0.9)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// DIALOGS
// ============================================================================

class GuestLoginDialog extends StatelessWidget {
  const GuestLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: GlassCard(
            width: 750,
            padding: const EdgeInsets.all(36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('برای تجربه بهتر، وارد حساب کاربری خود شوید.',
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none)),
                          SizedBox(height: 20),
                          Text(
                            'برای بهره‌بردن از همه امکانات، بهتر است وارد حساب کاربری خود شوید. با ورود، کلاس‌ها و محتوای مخصوص شما دقیق‌تر نمایش داده می‌شود.',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                height: 1.7,
                                decoration: TextDecoration.none),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'می‌توانید مستقیم لاگین کنید یا با اسکن QR Code سریع وارد پروفایل خود شوید تا تجربه‌ای کامل‌تر و شخصی‌تر داشته باشید.',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                height: 1.7,
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 36),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.all(12),
                      child: CustomPaint(
                          painter: QRCodePainter(), size: const Size(156, 156)),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SecondaryButton(
                    text: 'بستن',
                    autofocus: true,
                    onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PresidentialMessageDialog extends StatefulWidget {
  const PresidentialMessageDialog({super.key});
  @override
  State<PresidentialMessageDialog> createState() =>
      _PresidentialMessageDialogState();
}

class _PresidentialMessageDialogState extends State<PresidentialMessageDialog>
    with TickerProviderStateMixin {
  late List<_ConfettiParticle> _particles;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(100, (_) => _ConfettiParticle());
    _confettiController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, _) => CustomPaint(
              painter: _ConfettiPainter(
                  particles: _particles, progress: _confettiController.value),
              size: MediaQuery.of(context).size,
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: GlassCard(
                width: 700,
                padding: const EdgeInsets.all(36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cardBackgroundLight,
                            border: Border.all(
                                color: AppColors.cardBorder, width: 2),
                          ),
                          child: const ClipOval(
                              child: Icon(Icons.person,
                                  size: 36, color: AppColors.textSecondary)),
                        ),
                        const SizedBox(width: 16),
                        const Text('پیام دکتر پزشکیان',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'آغاز سال تحصیلی ۱۴۰۵ را به همه دانش‌آموزان عزیز تبریک می‌گویم؛ شما سرمایه‌های درخشانی هستید که آینده این سرزمین را می‌سازید.',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          height: 1.8,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'امید دارم امسال با تلاش، امید و یادگیری عمیق‌تر، مسیر رسیدن به رویاهای‌تان را هموارتر کنید.',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.8,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 32),
                    Center(
                        child: SecondaryButton(
                            text: 'بستن',
                            autofocus: true,
                            onPressed: () => Navigator.of(context).pop())),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiParticle {
  final double x = math.Random().nextDouble();
  final double y = math.Random().nextDouble() * 0.5 - 0.5;
  final double size = math.Random().nextDouble() * 14 + 8;
  final Color color = [
    Colors.pink,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan
  ][math.Random().nextInt(7)];
  final double speed = math.Random().nextDouble() * 0.4 + 0.4;
  final double rotation = math.Random().nextDouble() * math.pi * 2;
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;
  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y + progress * p.speed * 2) % 1.5 - 0.25;
      final x = p.x + math.sin(progress * math.pi * 4 + p.rotation) * 0.04;
      if (y > 0 && y < 1) {
        canvas.save();
        canvas.translate(x * size.width, y * size.height);
        canvas.rotate(progress * math.pi * 2 + p.rotation);
        canvas.drawRect(
            Rect.fromCenter(
                center: Offset.zero, width: p.size, height: p.size * 0.5),
            Paint()..color = p.color);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

// ============================================================================
// SINGLE CLASS SCREEN
// ============================================================================

class SingleClassScreen extends StatefulWidget {
  final String className;
  final String subtitle;
  final String session;
  final String page;
  final bool isGuest;

  const SingleClassScreen({
    super.key,
    required this.className,
    required this.subtitle,
    required this.session,
    required this.page,
    this.isGuest = false,
  });

  @override
  State<SingleClassScreen> createState() => _SingleClassScreenState();
}

class _SingleClassScreenState extends State<SingleClassScreen> {
  bool _sidebarExpanded = false;
  int _selectedNavIndex = 3; // Classes tab selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoiseBackground(
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            // MAIN CONTENT - pushes left when sidebar expands
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 32, 24, 40),
                child: Column(
                  children: [
                    // Header with back button (on the right in RTL)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _BackButton(
                            onPressed: () => Navigator.of(context).pop()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Main content area
                    Expanded(
                      child: Row(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Right side - Class info
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title row
                                Row(
                                  children: [
                                    Text(
                                      widget.className,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'جلسه ${widget.session}',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  widget.subtitle,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        size: 18,
                                        color: AppColors.textSecondary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'آخرین مطلب گفته شده: تا سر صفحه ${widget.page}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                PrimaryButton(
                                  text: 'شروع کلاس',
                                  icon: Icons.play_arrow_rounded,
                                  autofocus: true,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      _createRoute(ClassSessionScreen(
                                        className: widget.className,
                                        isGuest: widget.isGuest,
                                      )),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Left side - Illustration
                          Expanded(
                            flex: 3,
                            child:
                                _ClassIllustration(className: widget.className),
                          ),
                        ],
                      ),
                    ),
                    // Bottom action cards grid
                    const SizedBox(height: 24),
                    _ClassActionGrid(
                      className: widget.className,
                      isGuest: widget.isGuest,
                    ),
                  ],
                ),
              ),
            ),
            // SIDEBAR - pushes content when expanded
            _Sidebar(
              expanded: _sidebarExpanded,
              selectedIndex: _selectedNavIndex,
              onHover: (e) => setState(() => _sidebarExpanded = e),
              onSelect: (i) => setState(() => _selectedNavIndex = i),
              onLogout: () => Navigator.of(context).pushAndRemoveUntil(
                  _createRoute(const ProfileSelectionScreen()),
                  (route) => false),
              isGuest: widget.isGuest,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onPressed,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isFocused
              ? AppColors.cardBackgroundLight
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isFocused ? AppColors.primary : AppColors.cardBorder,
              width: isFocused ? 2 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_rounded,
                size: 20,
                color: isFocused ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text('بازگشت',
                style: TextStyle(
                    color:
                        isFocused ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _ClassIllustration extends StatelessWidget {
  final String className;
  const _ClassIllustration({required this.className});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Monitor
          Container(
            width: 420,
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFF2A5A8C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4A7AAC), width: 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _getFormulasForClass(className),
            ),
          ),
          // Monitor stand
          Positioned(
            bottom: -40,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A7AAC),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                ),
                Container(
                  width: 160,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A6A9C),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          // Lab equipment on left
          Positioned(
            left: -80,
            bottom: -20,
            child: _LabEquipment(),
          ),
          // Cloud decoration
          Positioned(
            bottom: -30,
            right: 40,
            child: _CloudDecoration(),
          ),
        ],
      ),
    );
  }

  Widget _getFormulasForClass(String className) {
    if (className.contains('شیمی')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _FormulaText('CH₂+H₂→CH₄', 24),
              _FormulaText('PV=nRT', 18),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MoleculeStructure(),
              const SizedBox(width: 40),
              const _FormulaText('HCl→H⁺+Cl⁻', 18),
            ],
          ),
          const Center(child: _FormulaText('H₂SO₄→2H⁺+SO₄²⁻', 18)),
        ],
      );
    } else if (className.contains('ریاضی')) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FormulaText('(a+b)² = a²+2ab+b²', 22),
          _FormulaText('∫f(x)dx = F(x)+C', 20),
          _FormulaText('Σ(n) = n(n+1)/2', 20),
        ],
      );
    } else {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FormulaText('تاریخ ایران', 28),
          _FormulaText('دوره قاجار', 22),
          _FormulaText('۱۲۰۰ - ۱۳۰۴', 20),
        ],
      );
    }
  }
}

class _FormulaText extends StatelessWidget {
  final String text;
  final double fontSize;
  const _FormulaText(this.text, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Yekan',
      ),
    );
  }
}

class _MoleculeStructure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(painter: _MoleculePainter()),
    );
  }
}

class _MoleculePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw central C
    final center = Offset(size.width / 2, size.height / 2);

    // Draw bonds
    canvas.drawLine(center, Offset(center.dx, center.dy - 25), paint);
    canvas.drawLine(center, Offset(center.dx - 25, center.dy + 20), paint);
    canvas.drawLine(center, Offset(center.dx + 25, center.dy + 20), paint);
    canvas.drawLine(center, Offset(center.dx, center.dy + 30), paint);

    // Draw H labels
    const labelStyle = TextStyle(color: Colors.white, fontSize: 12);

    void drawLabel(String text, Offset pos) {
      textPainter.text = TextSpan(text: text, style: labelStyle);
      textPainter.layout();
      textPainter.paint(
          canvas, pos - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    drawLabel('H', Offset(center.dx, center.dy - 35));
    drawLabel('H', Offset(center.dx - 35, center.dy + 25));
    drawLabel('H', Offset(center.dx + 35, center.dy + 25));
    drawLabel('H', Offset(center.dx, center.dy + 42));
    drawLabel('C', center);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LabEquipment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 120,
      child: CustomPaint(painter: _LabEquipmentPainter()),
    );
  }
}

class _LabEquipmentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Beaker
    final beakerPaint = Paint()
      ..color = const Color(0xFF4A8AC4)
      ..style = PaintingStyle.fill;

    final beakerPath = Path()
      ..moveTo(20, 40)
      ..lineTo(15, 100)
      ..lineTo(55, 100)
      ..lineTo(50, 40)
      ..close();
    canvas.drawPath(beakerPath, beakerPaint);

    // Beaker liquid
    final liquidPaint = Paint()
      ..color = const Color(0xFF6AB4F4)
      ..style = PaintingStyle.fill;
    final liquidPath = Path()
      ..moveTo(18, 60)
      ..lineTo(16, 98)
      ..lineTo(54, 98)
      ..lineTo(52, 60)
      ..close();
    canvas.drawPath(liquidPath, liquidPaint);

    // Flask
    final flaskPaint = Paint()
      ..color = const Color(0xFF4A8AC4)
      ..style = PaintingStyle.fill;

    // Flask body
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(75, 90), width: 40, height: 30),
        flaskPaint);

    // Flask neck
    canvas.drawRect(const Rect.fromLTWH(70, 50, 10, 45), flaskPaint);

    // Flask liquid
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(75, 92), width: 35, height: 22),
      Paint()..color = const Color(0xFF6AB4F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CloudDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 60,
      child: CustomPaint(painter: _CloudPainter()),
    );
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5A9AD4).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
        Rect.fromCenter(center: const Offset(30, 40), width: 50, height: 35),
        paint);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(60, 35), width: 60, height: 40),
        paint);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(90, 40), width: 50, height: 35),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ClassActionGrid extends StatelessWidget {
  final String className;
  final bool isGuest;

  const _ClassActionGrid({required this.className, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.assignment_ind_rounded,
        'label': 'حضور و غیاب کلاسی',
        'tabIndex': 0
      },
      {'icon': Icons.checklist_rounded, 'label': 'بررسی تکالیف', 'tabIndex': 1},
      {
        'icon': Icons.description_rounded,
        'label': 'طرح درس این جلسه',
        'tabIndex': 2
      },
      {'icon': Icons.quiz_rounded, 'label': 'امتحان کلاسی', 'tabIndex': 3},
      {
        'icon': Icons.assignment_rounded,
        'label': 'تکلیف جلسه بعد',
        'tabIndex': 4
      },
      {
        'icon': Icons.article_rounded,
        'label': 'طرح درس جلسه بعد',
        'tabIndex': 5
      },
    ];

    return SizedBox(
      height: 180,
      child: Column(
        children: [
          // First row
          Expanded(
            child: Row(
              children: actions.sublist(0, 3).asMap().entries.map((entry) {
                final index = entry.key;
                final action = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index < 2 ? 12 : 0,
                      bottom: 6,
                    ),
                    child: _ActionCard(
                      icon: action['icon'] as IconData,
                      label: action['label'] as String,
                      onSelect: () {
                        Navigator.push(
                          context,
                          _createRoute(ClassSessionScreen(
                            className: className,
                            isGuest: isGuest,
                            initialTabIndex: action['tabIndex'] as int,
                          )),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Second row
          Expanded(
            child: Row(
              children: actions.sublist(3, 6).asMap().entries.map((entry) {
                final index = entry.key;
                final action = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index < 2 ? 12 : 0,
                      top: 6,
                    ),
                    child: _ActionCard(
                      icon: action['icon'] as IconData,
                      label: action['label'] as String,
                      onSelect: () {
                        Navigator.push(
                          context,
                          _createRoute(ClassSessionScreen(
                            className: className,
                            isGuest: isGuest,
                            initialTabIndex: action['tabIndex'] as int,
                          )),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onSelect;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onSelect,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isFocused ? AppColors.courseBlue : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isFocused
                ? AppColors.primary
                : AppColors.cardBorder.withOpacity(0.4),
            width: isFocused ? 2 : 1,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 1)
                ]
              : [],
        ),
        child: Row(
          children: [
            // Icon on the left
            _ActionIcon(icon: icon, isFocused: isFocused),
            const Spacer(),
            // Text on the right
            Text(
              label,
              style: TextStyle(
                color: isFocused ? Colors.white : AppColors.textPrimary,
                fontSize: 18,
                fontWeight: isFocused ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final bool isFocused;

  const _ActionIcon({required this.icon, required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      height: 55,
      child: CustomPaint(
        painter: _ActionIconPainter(isFocused: isFocused),
        child: Center(
          child: Icon(
            icon,
            size: 28,
            color:
                isFocused ? const Color(0xFF6AB4F4) : const Color(0xFF4A9AD8),
          ),
        ),
      ),
    );
  }
}

class _ActionIconPainter extends CustomPainter {
  final bool isFocused;
  _ActionIconPainter({required this.isFocused});

  @override
  void paint(Canvas canvas, Size size) {
    final color = isFocused ? const Color(0xFF4A9AD8) : const Color(0xFF4A7AAC);
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw clipboard shape
    final clipboardPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 8, size.width - 16, size.height - 12),
        const Radius.circular(6),
      ));
    canvas.drawPath(clipboardPath, paint);

    // Draw clip at top
    final clipPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width / 2 - 12, 4, 24, 10),
        const Radius.circular(3),
      ),
      clipPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// CLASS SESSION SCREEN - Main screen for class activities
// ============================================================================

class ClassSessionScreen extends StatefulWidget {
  final String className;
  final bool isGuest;
  final int initialTabIndex;

  const ClassSessionScreen({
    super.key,
    required this.className,
    this.isGuest = false,
    this.initialTabIndex = 0,
  });

  @override
  State<ClassSessionScreen> createState() => _ClassSessionScreenState();
}

class _ClassSessionScreenState extends State<ClassSessionScreen> {
  bool _sidebarExpanded = false;
  int _selectedNavIndex = 3;
  late int _selectedTabIndex;
  int _currentStudentIndex = 0;
  int _currentQuestionIndex = 0;
  bool _showAttendanceSuccess = false;
  bool _showLessonSummary = false;

  static const _tabs = [
    'حضور و غیاب کلاسی',
    'بررسی تکالیف',
    'طرح درس این جلسه',
    'امتحان کلاسی',
    'تکلیف جلسه بعد',
    'طرح درس جلسه بعد',
  ];

  static const _students = [
    {
      'name': 'کسری کشوردوست',
      'present': 30,
      'absent': 6,
      'late': 1,
      'history': ['absent', 'late', 'absent']
    },
    {
      'name': 'محسن کلانتری',
      'present': 6,
      'absent': 3,
      'late': 1,
      'history': ['absent', 'present', 'present']
    },
    {
      'name': 'علی محمدی',
      'present': 25,
      'absent': 4,
      'late': 2,
      'history': ['present', 'present', 'late']
    },
  ];

  // Homework questions data
  static const _homeworkQuestions = [
    {
      'number': '۱',
      'text':
          'در یک آزمایش، دانش‌آموزان باید گاز هیدروژن تولید کنند و مقدار آن را اندازه‌گیری کنند. برای این کار، ۱۰ گرم روی (Zn) را در محلول هیدروکلریک‌اسید ۲ مولار (HCl) می‌اندازند. واکنش زیر رخ می‌دهد:',
      'formula': 'Zn + 2HCl → ZnCl2 + H2(g)',
      'extraText':
          'پس از انجام واکنش، گاز هیدروژن تولیدشده جمع‌آوری می‌شود و حجم آن در شرایط آزمایشگاه ۲۲ درجهٔ سانتی‌گراد و فشار ۱ اتمسفر برابر با ۳.۹۶ لیتر اندازه‌گیری می‌شود.',
      'question':
          'آیا مقدار گاز هیدروژنی که به‌صورت نظری (محاسباتی) باید تولید شود با مقدار واقعی که آزمایشگاه اندازه‌گیری کرده یکسان است؟ اگر تفاوت وجود دارد، علت احتمالی آن چیست؟ (جرم اتمی Zn = ۶۵ g/mol، گاز هیدروژن در شرایط استاندارد تقریباً ۲۲.۴ لیتر بر مول است)',
      'solved': 15,
      'notSolved': 12,
      'notSent': 3,
    },
    {
      'number': '۲',
      'text':
          'در یک آزمایش، دانش‌آموزان باید گاز هیدروژن تولید کنند و مقدار آن را اندازه‌گیری کنند. برای این کار، ۱۰ گرم روی (Zn) را در محلول هیدروکلریک‌اسید ۲ مولار (HCl) می‌اندازند. واکنش زیر رخ می‌دهد:',
      'formula': null,
      'extraText': null,
      'question':
          'آیا مقدار گاز هیدروژنی که به‌صورت نظری (محاسباتی) باید تولید شود با مقدار واقعی که آزمایشگاه اندازه‌گیری کرده یکسان است؟ اگر تفاوت وجود دارد، علت احتمالی آن چیست؟ (جرم اتمی Zn = ۶۵ g/mol، گاز هیدروژن در شرایط استاندارد تقریباً ۲۲.۴ لیتر بر مول است)',
      'solved': 24,
      'notSolved': 5,
      'notSent': 1,
    },
  ];

  // Lesson plan content data
  int _selectedLessonItemIndex =
      2; // Currently selected item in table of contents
  bool _showSessionsList =
      false; // Toggle between lesson content and sessions list

  // Track attendance status for each student: null = not set, 0 = present, 1 = absent, 2 = late
  late List<int?> _attendanceStatus;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _attendanceStatus = List.filled(_students.length, null);
  }

  void _showAttendanceMethodDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => AttendanceMethodDialog(
        onFaceRecognition: () {
          Navigator.pop(context);
          // Face recognition logic
        },
        onVoiceRecognition: () {
          Navigator.pop(context);
          // Voice recognition logic
        },
      ),
    );
  }

  void _completeAttendance() {
    setState(() => _showAttendanceSuccess = true);
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: // Attendance
        return _AttendanceContent(
          students: _students,
          currentIndex: _currentStudentIndex,
          attendanceStatus: _attendanceStatus,
          onPrevious: () {
            if (_currentStudentIndex > 0) {
              setState(() => _currentStudentIndex--);
            }
          },
          onNext: () {
            if (_currentStudentIndex < _students.length - 1) {
              setState(() => _currentStudentIndex++);
            }
          },
          onSetStatus: (status) {
            setState(() => _attendanceStatus[_currentStudentIndex] = status);
          },
        );
      case 1: // Homework Review
        return _HomeworkReviewContent(
          questions: _homeworkQuestions,
          currentIndex: _currentQuestionIndex,
          onPrevious: () {
            if (_currentQuestionIndex > 0) {
              setState(() => _currentQuestionIndex--);
            }
          },
          onNext: () {
            if (_currentQuestionIndex < _homeworkQuestions.length - 1) {
              setState(() => _currentQuestionIndex++);
            }
          },
        );
      case 2: // Lesson Plan (طرح درس این جلسه)
        return _LessonPlanContent(
          selectedItemIndex: _selectedLessonItemIndex,
          showSessionsList: _showSessionsList,
          onItemSelect: (index) {
            setState(() => _selectedLessonItemIndex = index);
          },
          onToggleSessionsList: () {
            setState(() => _showSessionsList = !_showSessionsList);
          },
        );
      case 3: // Class Exam (امتحان کلاسی)
        return const _ClassExamContent();
      case 4: // Next Session Homework (تکلیف جلسه بعد)
        return const _NextHomeworkContent();
      case 5: // Next Session Lesson Plan (طرح درس جلسه بعد)
        return _NextLessonPlanContent(
          onFinishSession: () {
            // Handle finish session
            Navigator.pop(context);
          },
        );
      default:
        return Center(
          child: Text(
            _tabs[_selectedTabIndex],
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 24),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show Attendance Success Screen
    if (_showAttendanceSuccess) {
      return _AttendanceSuccessScreen(
        onContinue: () {
          setState(() {
            _showAttendanceSuccess = false;
            _selectedTabIndex = 1; // Go to next tab
          });
        },
        onBack: () {
          setState(() => _showAttendanceSuccess = false);
        },
        isGuest: widget.isGuest,
      );
    }

    // Show Lesson Summary Screen
    if (_showLessonSummary) {
      return _LessonSummaryScreen(
        onGoToExam: () {
          setState(() {
            _showLessonSummary = false;
            _selectedTabIndex = 3; // Go to exam tab
          });
        },
        onBack: () {
          setState(() => _showLessonSummary = false);
        },
        isGuest: widget.isGuest,
      );
    }

    return Scaffold(
      body: NoiseBackground(
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            // MAIN CONTENT - pushes left when sidebar expands
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 32, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with back, previous and next buttons
                      Row(
                        children: [
                          // Back button (right in RTL = start)
                          _BackButton(onPressed: () => Navigator.pop(context)),
                          const Spacer(),
                          // Previous section button
                          if (_selectedTabIndex > 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: FocusableItem(
                                onSelect: () {
                                  if (_selectedTabIndex > 0) {
                                    setState(() => _selectedTabIndex--);
                                  }
                                },
                                builder: (isFocused) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: isFocused
                                            ? AppColors.primary
                                            : AppColors.cardBorder,
                                        width: isFocused ? 2 : 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.play_arrow_rounded,
                                          size: 20,
                                          color: isFocused
                                              ? Colors.white
                                              : AppColors.textSecondary),
                                      const SizedBox(width: 6),
                                      Text('بخش قبل',
                                          style: TextStyle(
                                              color: isFocused
                                                  ? Colors.white
                                                  : AppColors.textSecondary,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          // Next section button (left in RTL = end)
                          FocusableItem(
                            onSelect: () {
                              // If on lesson plan tab, show summary
                              if (_selectedTabIndex == 2) {
                                setState(() => _showLessonSummary = true);
                              } else if (_selectedTabIndex == 0) {
                                // If on attendance tab, show success
                                setState(() => _showAttendanceSuccess = true);
                              } else if (_selectedTabIndex < _tabs.length - 1) {
                                setState(() => _selectedTabIndex++);
                              }
                            },
                            builder: (isFocused) => AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: isFocused
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('بخش بعدی',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  SizedBox(width: 6),
                                  Icon(Icons.chevron_right_rounded,
                                      size: 24, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Tab bar
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _tabs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final isSelected = index == _selectedTabIndex;
                            return FocusableItem(
                              autofocus: index == 0,
                              onSelect: () =>
                                  setState(() => _selectedTabIndex = index),
                              builder: (isFocused) => AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.transparent
                                      : AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isFocused
                                            ? AppColors.primary
                                            : AppColors.cardBorder),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Text(
                                  _tabs[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isFocused
                                            ? Colors.white
                                            : AppColors.textSecondary),
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Content based on selected tab
                      Expanded(
                        child: _buildTabContent(),
                      ),
                      // Bottom assistant button - only on attendance tab
                      if (_selectedTabIndex == 0)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: FocusableItem(
                            onSelect: _showAttendanceMethodDialog,
                            builder: (isFocused) => AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC107),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: isFocused
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.support_agent_rounded,
                                      size: 22, color: Colors.black87),
                                  SizedBox(width: 10),
                                  Text('بررسی با کمک دستیار',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // SIDEBAR - pushes content when expanded
            _Sidebar(
              expanded: _sidebarExpanded,
              selectedIndex: _selectedNavIndex,
              onHover: (e) => setState(() => _sidebarExpanded = e),
              onSelect: (i) => setState(() => _selectedNavIndex = i),
              onLogout: () => Navigator.of(context).pushAndRemoveUntil(
                  _createRoute(const ProfileSelectionScreen()),
                  (route) => false),
              isGuest: widget.isGuest,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ATTENDANCE CONTENT
// ============================================================================

class _AttendanceContent extends StatelessWidget {
  final List<Map<String, dynamic>> students;
  final int currentIndex;
  final List<int?> attendanceStatus;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(int) onSetStatus;

  const _AttendanceContent({
    required this.students,
    required this.currentIndex,
    required this.attendanceStatus,
    required this.onPrevious,
    required this.onNext,
    required this.onSetStatus,
  });

  @override
  Widget build(BuildContext context) {
    final student = students[currentIndex];
    final status = attendanceStatus[currentIndex];
    final history = student['history'] as List<String>;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Student photo (first in RTL = right side)
        Container(
          width: 200,
          height: 260,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: const _StudentAvatar(size: 200),
          ),
        ),
        const SizedBox(width: 40),
        // Student info (middle)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student name
              Text(
                student['name'] as String,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Last 3 sessions history
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'روند حضور دانش‌آموز در سه جلسه آخر کلاس',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  // History icons
                  ...history.map((h) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _HistoryIcon(status: h),
                      )),
                ],
              ),
              const SizedBox(height: 32),
              // Attendance status text
              const Text(
                'وضعیت حضور و غیاب دانش‌آموز تا به اینجای سال',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 12),
              // Progress bar
              _AttendanceProgressBar(
                present: student['present'] as int,
                absent: student['absent'] as int,
                late: student['late'] as int,
              ),
              const SizedBox(height: 12),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _LegendItem(
                      label: 'حضور',
                      count: student['present'] as int,
                      color: Colors.green),
                  const SizedBox(width: 24),
                  _LegendItem(
                      label: 'غایب',
                      count: student['absent'] as int,
                      color: Colors.red),
                  const SizedBox(width: 24),
                  _LegendItem(
                      label: 'تاخیر',
                      count: student['late'] as int,
                      color: Colors.white),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        // Navigation arrows and status buttons (last in RTL = left side)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Navigation arrows
            Row(
              children: [
                _NavArrowButton(
                    icon: Icons.chevron_left_rounded, onPressed: onPrevious),
                const SizedBox(width: 10),
                _NavArrowButton(
                    icon: Icons.chevron_right_rounded, onPressed: onNext),
              ],
            ),
            const SizedBox(height: 32),
            // Status selection buttons
            Row(
              children: [
                _AttendanceStatusButton(
                  label: 'حاضر',
                  icon: Icons.check_rounded,
                  isSelected: status == 0,
                  color: Colors.green,
                  onSelect: () => onSetStatus(0),
                ),
                const SizedBox(width: 12),
                _AttendanceStatusButton(
                  label: 'غایب',
                  icon: Icons.close_rounded,
                  isSelected: status == 1,
                  color: Colors.red,
                  onSelect: () => onSetStatus(1),
                ),
                const SizedBox(width: 12),
                _AttendanceStatusButton(
                  label: 'تاخیر',
                  icon: Icons.access_time_rounded,
                  isSelected: status == 2,
                  color: Colors.grey,
                  onSelect: () => onSetStatus(2),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// HOMEWORK REVIEW CONTENT
// ============================================================================

class _HomeworkReviewContent extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final int currentIndex;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _HomeworkReviewContent({
    required this.questions,
    required this.currentIndex,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];
    final solved = question['solved'] as int;
    final notSolved = question['notSolved'] as int;
    final notSent = question['notSent'] as int;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Right side - Question content
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question header with number and navigation
                Row(
                  children: [
                    Text(
                      'سوال ${question['number']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Navigation arrows
                    Row(
                      children: [
                        _NavArrowButton(
                          icon: Icons.chevron_left_rounded,
                          onPressed: onPrevious,
                        ),
                        const SizedBox(width: 10),
                        _NavArrowButton(
                          icon: Icons.chevron_right_rounded,
                          onPressed: onNext,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Question text
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['text'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.8,
                          ),
                        ),
                        if (question['formula'] != null) ...[
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Text(
                                question['formula'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Yekan',
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (question['extraText'] != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            question['extraText'] as String,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              height: 1.8,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Text(
                          question['question'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Left side - Student status chart
        Container(
          width: 340,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              // Donut chart
              Expanded(
                child: Center(
                  child: _StudentStatusChart(
                    solved: solved,
                    notSolved: notSolved,
                    notSent: notSent,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Legend
              _ChartLegend(
                solved: solved,
                notSolved: notSolved,
                notSent: notSent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Donut chart for student status
class _StudentStatusChart extends StatelessWidget {
  final int solved;
  final int notSolved;
  final int notSent;

  const _StudentStatusChart({
    required this.solved,
    required this.notSolved,
    required this.notSent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: _DonutChartPainter(
          solved: solved,
          notSolved: notSolved,
          notSent: notSent,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'وضعیت',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'دانش‌آموزان',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Donut chart painter
class _DonutChartPainter extends CustomPainter {
  final int solved;
  final int notSolved;
  final int notSent;

  _DonutChartPainter({
    required this.solved,
    required this.notSolved,
    required this.notSent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = solved + notSolved + notSent;
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 28.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Calculate angles
    const startAngle = -math.pi / 2; // Start from top
    final solvedAngle = (solved / total) * 2 * math.pi;
    final notSolvedAngle = (notSolved / total) * 2 * math.pi;
    final notSentAngle = (notSent / total) * 2 * math.pi;

    // Draw segments with small gaps
    final gap = 0.04; // Gap between segments

    // Draw solved (green)
    paint.color = const Color(0xFF4CAF50);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle + gap,
      solvedAngle - gap * 2,
      false,
      paint,
    );

    // Draw not solved (red)
    paint.color = const Color(0xFFE53935);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle + solvedAngle + gap,
      notSolvedAngle - gap * 2,
      false,
      paint,
    );

    // Draw not sent (light blue/white)
    paint.color = const Color(0xFFB0BEC5);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle + solvedAngle + notSolvedAngle + gap,
      notSentAngle - gap * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Chart legend
class _ChartLegend extends StatelessWidget {
  final int solved;
  final int notSolved;
  final int notSent;

  const _ChartLegend({
    required this.solved,
    required this.notSolved,
    required this.notSent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LegendRow(
          color: const Color(0xFF4CAF50),
          label: 'کسانی که سوال را حل کردن',
          count: solved,
        ),
        const SizedBox(height: 16),
        _LegendRow(
          color: const Color(0xFFE53935),
          label: 'کسانی که سوال را حل نکردن',
          count: notSolved,
        ),
        const SizedBox(height: 16),
        _LegendRow(
          color: const Color(0xFFB0BEC5),
          label: 'کسانی که سوال را ارسال نکردن',
          count: notSent,
        ),
      ],
    );
  }
}

// Legend row
class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count نفر',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LESSON PLAN CONTENT (طرح درس این جلسه)
// ============================================================================

class _LessonPlanContent extends StatelessWidget {
  final int selectedItemIndex;
  final bool showSessionsList;
  final Function(int) onItemSelect;
  final VoidCallback onToggleSessionsList;

  const _LessonPlanContent({
    required this.selectedItemIndex,
    required this.showSessionsList,
    required this.onItemSelect,
    required this.onToggleSessionsList,
  });

  // Lesson content items - flattened for easy selection
  static const _lessonItems = [
    {
      'title': 'ترازهای انرژی؛ خانه‌های اصلی الکترون‌ها',
      'type': 'text',
      'duration': null,
      'chapter': 'مقدمه‌ای بر مدل کوانتومی'
    },
    {
      'title': 'آشنایی سریع با منطق مدل کوانتومی',
      'type': 'video',
      'duration': '۱۰ دقیقه',
      'chapter': 'مقدمه‌ای بر مدل کوانتومی'
    },
    {
      'title': 'آزمایش سوختن آهن و اکسیژن',
      'type': 'experiment',
      'duration': null,
      'chapter': 'مقدمه‌ای بر مدل کوانتومی',
      'designer': 'آروین'
    },
    {
      'title': 'کوییز کوتاه از بخش',
      'type': 'quiz',
      'duration': null,
      'chapter': 'مقدمه‌ای بر مدل کوانتومی',
      'designer': 'پامادان'
    },
    {
      'title': 'تابع موج چیست؟',
      'type': 'text',
      'duration': null,
      'chapter': 'تابع موج و احتمال'
    },
  ];

  static const _sessions = [
    {
      'number': '۱',
      'description':
          'فصل ۱ از شروع بخش آشنایی با عنصرها تا ایزوتوپ و شکل‌گیری عنصرها',
      'status': 'completed'
    },
    {
      'number': '۲',
      'description': 'فصل ۲ از شروع بخش ترکیب‌ها تا پیوندها',
      'status': 'completed'
    },
    {
      'number': '۳',
      'description': 'فصل ۳ از شروع بخش مدل کوانتومی تا گروه‌ها و دروه‌ها',
      'status': 'current'
    },
    {
      'number': '۴',
      'description': 'فصل ۴ از شروع بخش خواص تناوبی عنصرها تا پایان فصل',
      'status': 'not_started'
    },
    {
      'number': '۵',
      'description': 'فصل ۵ از شروع بخش الکترون ها و ساختار اتم تا پایان فصل',
      'status': 'not_started'
    },
    {
      'number': '۶',
      'description': 'فصل ۶ از شروع بخش واکنش های شیمیایی تا پایان فصل',
      'status': 'not_started'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Session info bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              // Session number (RIGHT in RTL - comes first)
              FocusableItem(
                onSelect: onToggleSessionsList,
                builder: (isFocused) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'جلسه ۳',
                      style: TextStyle(
                        color: isFocused ? AppColors.primary : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      showSessionsList
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: isFocused ? AppColors.primary : Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Progress indicator (LEFT in RTL - comes second)
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 15),
                  children: [
                    TextSpan(
                      text: '۱۷ درصد',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: ' مطالب کتاب گفته شده است',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Main content
        Expanded(
          child:
              showSessionsList ? _buildSessionsList() : _buildLessonContent(),
        ),
      ],
    );
  }

  Widget _buildSessionsList() {
    return ListView.separated(
      itemCount: _sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = _sessions[index];
        return _LessonSessionCard(
          number: session['number'] as String,
          description: session['description'] as String,
          status: session['status'] as String,
          onTap: () {},
        );
      },
    );
  }

  Widget _buildLessonContent() {
    final currentItem = _lessonItems[selectedItemIndex];
    final itemType = currentItem['type'] as String;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Table of contents sidebar (RIGHT in RTL - first in Row)
        SizedBox(
          width: 300,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D).withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium header with gradient text effect (subtle)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'فهرست مطالب',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: Colors.white12, height: 1),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildTableOfContents(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Main content area (LEFT in RTL - second in Row)
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
            ),
            child: itemType == 'quiz'
                ? _buildQuizScrollableContent(currentItem)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title, designer, and duration
                      _buildContentHeader(currentItem),
                      const SizedBox(height: 20),
                      // Content based on type
                      Expanded(
                        child: _buildContentByType(itemType, currentItem),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentHeader(Map<String, dynamic> currentItem) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and designer on right
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentItem['title'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (currentItem['designer'] != null) ...[
                const SizedBox(height: 6),
                Text(
                  'طراحی شده توسط ${currentItem['designer']}',
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
        // Duration on left
        if (currentItem['duration'] != null)
          Text(
            currentItem['duration'] as String,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildQuizScrollableContent(Map<String, dynamic> currentItem) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildContentHeader(currentItem),
          const SizedBox(height: 20),
          // Quiz content
          _QuizContent(designer: currentItem['designer'] as String?),
          // Navigation buttons
          _buildQuizNavigation(),
        ],
      ),
    );
  }

  Widget _buildContentByType(String type, Map<String, dynamic> item) {
    switch (type) {
      case 'video':
      case 'experiment':
        return const _VideoPlayerPlaceholder();
      case 'text':
        return const _TextContent();
      default:
        return const Center(
          child: Text(
            'محتوا در دسترس نیست',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        );
    }
  }

  Widget _buildQuizNavigation() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          // Previous topic button (RIGHT in RTL) - blue
          Expanded(
            child: FocusableItem(
              onSelect: () {},
              builder: (isFocused) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isFocused ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تابع موج و احتمال',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.chevron_right_rounded,
                        color: Colors.white, size: 22),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Next topic button (LEFT in RTL)
          Expanded(
            flex: 2,
            child: FocusableItem(
              onSelect: () {},
              builder: (isFocused) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isFocused ? AppColors.primary : AppColors.cardBorder,
                    width: isFocused ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: isFocused ? Colors.white : AppColors.textSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'آشنایی سریع با منطق مدل کوانتومی',
                      style: TextStyle(
                        color:
                            isFocused ? Colors.white : AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableOfContents() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter 1: مقدمه‌ای بر مدل کوانتومی
          _TOCChapter(
            title: 'مقدمه‌ای بر مدل کوانتومی',
            isExpanded: true,
            children: [
              _TOCItem(
                title: 'ترازهای انرژی؛ خانه‌های اصلی الکترون‌ها',
                type: 'text',
                isSelected: selectedItemIndex == 0,
                onTap: () => onItemSelect(0),
              ),
              _TOCItem(
                title: 'آشنایی سریع با منطق مدل کوانتومی',
                type: 'video',
                isSelected: selectedItemIndex == 1,
                onTap: () => onItemSelect(1),
              ),
              _TOCItem(
                title: 'آزمایش سوختن آهن و اکسیژن',
                type: 'experiment',
                isSelected: selectedItemIndex == 2,
                onTap: () => onItemSelect(2),
              ),
              _TOCItem(
                title: 'کوییز کوتاه از بخش',
                type: 'quiz',
                isSelected: selectedItemIndex == 3,
                onTap: () => onItemSelect(3),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Chapter 2: تابع موج و احتمال
          _TOCChapter(
            title: 'تابع موج و احتمال',
            isExpanded: true,
            children: [
              _TOCItem(
                title: 'تابع موج چیست؟',
                type: 'text',
                isSelected: selectedItemIndex == 4,
                onTap: () => onItemSelect(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CLASS EXAM CONTENT - Tab 3 (امتحان کلاسی)
// ============================================================================

class _ClassExamContent extends StatefulWidget {
  const _ClassExamContent();

  @override
  State<_ClassExamContent> createState() => _ClassExamContentState();
}

class _ClassExamContentState extends State<_ClassExamContent> {
  // 0 = QR/File view, 1 = Questions view
  int _currentView = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentView == 0) {
      return _buildQRFileView();
    } else {
      return _buildQuestionsView();
    }
  }

  Widget _buildQRFileView() {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT CARD - File upload (smaller)
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.cardBorder.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'استفاده از فایل بارگذاری‌شده',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // File icon placeholder
                      Container(
                        width: 90,
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Icon(
                                Icons.description_rounded,
                                color: AppColors.primary,
                                size: 60,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'اگر قبلاً فایل سؤالات را در سامانه بارگذاری کرده‌اید،\nاین گزینه را انتخاب کنید تا همان فایل استفاده شود.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FocusableItem(
                        onSelect: () => setState(() => _currentView = 1),
                        builder: (isFocused) => AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isFocused ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'انتخاب فایل',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // "یا" separator
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'یا',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // RIGHT CARD - QR Code (larger)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.cardBorder.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      // QR Code on left side of this card
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CustomPaint(
                          painter: _QRCodePainter(),
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Text content on right side
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'اسکن QR Code',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'با دوربین موبایل خود این QR Code را اسکن کنید.\nبعد از اسکن، صفحه‌ای برای شما باز می‌شود که می‌توانید\nسؤال‌های امتحان را همان‌جا در موبایل وارد و ثبت کنید.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                height: 1.8,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'مراحل بعدی طراحی و مدیریت امتحان از طریق موبایل شما\nانجام می‌شود و نتیجه روی همین صفحه نمایش داده\nخواهد شد.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row - Title on right, Timer on left
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and designer on right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'امتحان کلاسی',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'طراحی شده توسط پامادان',
                          style: TextStyle(
                            color: const Color(0xFF7CB342),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Timer on far left
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'مدت زمان امتحان: ۲۰:۰۰ دقیقه',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Question 1 - Multiple choice
          const Text(
            '۱. مهم‌ترین تفاوت مدل بور و مدل کوانتومی در توصیف حرکت الکترون چیست؟',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          // Answer options - Row 1 (options 1 and 2)
          Row(
            children: [
              // Option 2 on left
              Expanded(
                child: _ExamAnswerCard(
                  number: '۲',
                  text:
                      'مدل بور شعاع ثابت برای الکترون تعیین می‌کند، مدل کوانتومی فقط احتمال حضور را مشخص می‌کند.',
                ),
              ),
              const SizedBox(width: 16),
              // Option 1 on right
              Expanded(
                child: _ExamAnswerCard(
                  number: '۱',
                  text:
                      'مدل بور الکترون را موج می‌داند و مدل کوانتومی آن را ذره.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Answer options - Row 2 (options 3 and 4)
          Row(
            children: [
              // Option 4 on left
              Expanded(
                child: _ExamAnswerCard(
                  number: '۴',
                  text: 'مدل کوانتومی وجود اوربیتال‌ها را رد می‌کند.',
                ),
              ),
              const SizedBox(width: 16),
              // Option 3 on right
              Expanded(
                child: _ExamAnswerCard(
                  number: '۳',
                  text:
                      'مدل بور انرژی الکترون را ناپیوسته می‌داند و مدل کوانتومی پیوسته.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          // Question 2 - Text question
          const Text(
            '۲. تابع موج در مدل کوانتومی چه چیزی را نشان می‌دهد و چرا مقدار آن به‌تنهایی معنای فیزیکی ندارد؟',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 36),
          // Question 3 - Text question
          const Text(
            '۳. نقش اعداد کوانتومی را در مشخص کردن وضعیت یک الکترون در اتم توضیح بده. توضیح بده هر عدد کوانتومی چه اطلاعاتی می‌دهد و این چهار عدد چگونه با هم یک حالت الکترونی کامل را تعریف می‌کنند.',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamAnswerCard extends StatelessWidget {
  final String number;
  final String text;

  const _ExamAnswerCard({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: () {},
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFocused
                ? AppColors.primary
                : AppColors.cardBorder.withOpacity(0.3),
            width: isFocused ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text content on left (appears on left in RTL)
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Number badge on right (appears on right in RTL)
            Text(
              number,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// QR Code painter
class _QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 25;

    // Draw corner squares
    _drawCornerSquare(canvas, paint, 2 * cellSize, 2 * cellSize, cellSize * 7);
    _drawCornerSquare(
        canvas, paint, size.width - 9 * cellSize, 2 * cellSize, cellSize * 7);
    _drawCornerSquare(
        canvas, paint, 2 * cellSize, size.height - 9 * cellSize, cellSize * 7);

    // Draw some random pattern in center
    final random = [
      [10, 10],
      [11, 10],
      [12, 10],
      [13, 11],
      [14, 12],
      [10, 12],
      [12, 12],
      [14, 10],
      [10, 14],
      [12, 14],
      [11, 13],
      [13, 13],
      [15, 11],
      [15, 13],
      [11, 15],
    ];

    for (final pos in random) {
      canvas.drawRect(
        Rect.fromLTWH(pos[0] * cellSize, pos[1] * cellSize, cellSize, cellSize),
        paint,
      );
    }
  }

  void _drawCornerSquare(
      Canvas canvas, Paint paint, double x, double y, double size) {
    // Outer square
    canvas.drawRect(Rect.fromLTWH(x, y, size, size), paint);
    // Inner white
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(x + size * 0.14, y + size * 0.14, size * 0.72, size * 0.72),
      whitePaint,
    );
    // Inner black
    canvas.drawRect(
      Rect.fromLTWH(x + size * 0.28, y + size * 0.28, size * 0.44, size * 0.44),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// NEXT HOMEWORK CONTENT - Tab 4 (تکلیف جلسه بعد)
// ============================================================================

class _NextHomeworkContent extends StatefulWidget {
  const _NextHomeworkContent();

  @override
  State<_NextHomeworkContent> createState() => _NextHomeworkContentState();
}

class _NextHomeworkContentState extends State<_NextHomeworkContent> {
  // 0 = QR/File view, 1 = Homework content view
  int _currentView = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentView == 0) {
      return _buildQRFileView();
    } else {
      return _buildHomeworkView();
    }
  }

  Widget _buildQRFileView() {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT CARD - File upload (smaller)
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.cardBorder.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'استفاده از فایل بارگذاری‌شده',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // File icon placeholder
                      Container(
                        width: 90,
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Icon(
                                Icons.description_rounded,
                                color: AppColors.primary,
                                size: 60,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'اگر قبلاً فایل سؤالات را در سامانه بارگذاری کرده‌اید،\nاین گزینه را انتخاب کنید تا همان فایل استفاده شود.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FocusableItem(
                        onSelect: () => setState(() => _currentView = 1),
                        builder: (isFocused) => AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isFocused ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'انتخاب فایل',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // "یا" separator
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'یا',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // RIGHT CARD - QR Code (larger)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.cardBorder.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      // QR Code on left side of this card
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CustomPaint(
                          painter: _QRCodePainter(),
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Text content on right side
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'اسکن QR Code',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'برای ثبت تکلیف این جلسه، لطفاً QR Code روی صفحه را با\nموبایل خود اسکن کنید.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                height: 1.8,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'بعد از اسکن، وارد یک صفحه اختصاصی می‌شوید که در آن\nمی‌توانید تکالیف دانش‌آموزان را به‌طور کامل وارد کنید؛\nاز توضیح درس گرفته تا فایل، تصویر یا حتی نکات تکمیلی که\nلازم است در اختیار دانش‌آموز قرار بگیرد.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeworkView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Title on right, Designer on left
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'تکلیف کلاسی',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'طراحی شده توسط دانیو',
                  style: TextStyle(
                    color: const Color(0xFF7CB342),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Question 1
            _buildHomeworkQuestion(
              number: '۱',
              mainText:
                  'یک عنصر دلخواه از جدول تناوبی انتخاب کن (ترجیحاً یکی از عناصر دورهٔ دوم یا سوم مانند کربن، نیتروژن، سدیم یا منیزیم). سپس:',
              subItems: [
                '۱) آرایش الکترونی کامل آن عنصر را بنویس.',
                '۲) برای یکی از الکترون‌های لایه آخر، چهار عدد کوانتومی (n، l، m، s) را مشخص کن.',
                '۳) توضیح بده چرا این آرایش با قوانین "هوند" و "پر شدن اوربیتال‌ها" سازگار است.',
                '۴) یک نمودار خیلی ساده (حتی با خطوط و دایره‌های کوچک) از اوربیتال‌های پر و خالی آن عنصر بکش و نشان بده الکترون‌ها چطور در آن پخش شده‌اند.',
              ],
            ),
            const SizedBox(height: 32),
            // Question 2
            _buildHomeworkQuestion(
              number: '۲',
              mainText:
                  'گذار الکترون از یک تراز انرژی بالاتر به تراز پایین‌تر باعث گسیل نور می‌شود. توضیح بده چرا این گذار فقط می‌تواند در مقادیر مشخصی از انرژی اتفاق بیفتد و چگونه این موضوع به «طیف خطی عناصر» منجر می‌شود.',
              subItems: [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkQuestion({
    required String number,
    required String mainText,
    required List<String> subItems,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main question with number
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text
            Expanded(
              child: Text(
                mainText,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Number
            Text(
              '$number.',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (subItems.isNotEmpty) ...[
          const SizedBox(height: 16),
          // Sub items
          ...subItems.map((item) => Padding(
                padding:
                    const EdgeInsetsDirectional.only(bottom: 10, start: 32),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    item,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                ),
              )),
        ],
      ],
    );
  }
}

// ============================================================================
// NEXT LESSON PLAN CONTENT - Tab 5 (طرح درس جلسه بعد)
// ============================================================================

class _NextLessonPlanContent extends StatelessWidget {
  final VoidCallback onFinishSession;

  const _NextLessonPlanContent({required this.onFinishSession});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT side - Donut chart card
            Container(
              width: 340,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Donut chart with center text
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: _BookContentDonutPainter(),
                      child: const Center(
                        child: Text(
                          'مطالب کتاب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Legend items - Right aligned for RTL
                  _buildLegendRow('تدریس شده', AppColors.primary, '۳۵ درصد'),
                  const SizedBox(height: 12),
                  _buildLegendRow(
                      'تدریس خواهد شد', const Color(0xFF1A4A6C), '۱۵ درصد'),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // RIGHT side - Lesson plan content card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'طرح درس جلسه بعد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Topic 1
                      _buildTopicSection(
                        number: '۱',
                        title: 'پیوندهای شیمیایی',
                        content:
                            'اینکه چرا اتم‌ها به هم نزدیک می‌شوند، چه نوع پیوندهایی تشکیل می‌دهند و چطور این پیوندها رفتار مواد را تعیین می‌کنند.',
                      ),
                      const SizedBox(height: 28),
                      // Topic 2
                      _buildTopicSection(
                        number: '۲',
                        title: 'شکل و هندسهٔ مولکول‌ها',
                        content:
                            'با هم بررسی می‌کنیم مولکول‌ها چه آرایش فضایی دارند و چرا این آرایش روی قطبیت و ویژگی‌های ماده تأثیر می‌گذارد.',
                      ),
                      const SizedBox(height: 28),
                      // Topic 3
                      _buildTopicSection(
                        number: '۳',
                        title: 'نیروهای بین‌مولکولی',
                        content:
                            'می‌بینیم چرا بعضی مواد زود تبخیر می‌شوند، چرا برخی چسبنده‌اند و چه نیرویی بین مولکول‌ها نقش دارد. این جلسه مقدمه‌ای است برای اینکه بفهمیم چرا هر ماده رفتار مخصوص خودش را دارد.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // Button at bottom left corner
        Positioned(
          left: 0,
          bottom: 0,
          child: FocusableItem(
            onSelect: onFinishSession,
            builder: (isFocused) => AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFocused ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
              child: const Text(
                'اتمام جلسه سوم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendRow(String label, Color color, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildTopicSection({
    required String number,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with number
        Text(
          '$number) $title',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        // Content
        Text(
          content,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 14,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

// Donut painter for book content
class _BookContentDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 24.0;

    // Background arc (dark gray - remaining)
    final bgPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Already taught (blue) - 35%
    final taughtPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -3.14159 / 2; // Start from top
    const taughtSweep = 2 * 3.14159 * 0.35;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      taughtSweep,
      false,
      taughtPaint,
    );

    // Will be taught (darker blue) - 15%
    final willTeachPaint = Paint()
      ..color = const Color(0xFF1A3A5C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const willTeachSweep = 2 * 3.14159 * 0.15;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle + taughtSweep,
      willTeachSweep,
      false,
      willTeachPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Session card for lesson plan sessions list
class _LessonSessionCard extends StatelessWidget {
  final String number;
  final String description;
  final String status;
  final VoidCallback onTap;

  const _LessonSessionCard({
    required this.number,
    required this.description,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = status == 'current';

    return FocusableItem(
      onSelect: onTap,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isFocused
                    ? AppColors.primary
                    : AppColors.cardBorder.withOpacity(0.3)),
            width: isSelected || isFocused ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Status indicator
            _buildStatusIndicator(),
            const Spacer(),
            // Description
            Expanded(
              flex: 4,
              child: Text(
                description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: status == 'not_started'
                      ? AppColors.textSecondary
                      : Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Session number
            Text(
              'جلسه $number',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    switch (status) {
      case 'completed':
        return Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
        );
      case 'current':
        return Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.subdirectory_arrow_left_rounded,
              color: Colors.white, size: 18),
        );
      default:
        return const Text(
          'شروع نشده',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        );
    }
  }
}

// Video player placeholder - used directly
class _VideoPlayerPlaceholder extends StatelessWidget {
  const _VideoPlayerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Video placeholder background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade900.withOpacity(0.5),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videocam_off_outlined,
                      color: Colors.grey.shade600,
                      size: 60,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ویدیو موجود نیست',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Play button
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          // Video controls (top-left in the video)
          PositionedDirectional(
            top: 16,
            start: 16,
            child: Row(
              children: [
                _VideoControlButton(icon: Icons.fullscreen_rounded),
                const SizedBox(width: 8),
                _VideoControlButton(icon: Icons.settings_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoControlButton extends StatelessWidget {
  final IconData icon;
  const _VideoControlButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

// Quiz content widget
class _QuizContent extends StatefulWidget {
  final String? designer;

  const _QuizContent({this.designer});

  @override
  State<_QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<_QuizContent> {
  int? _selectedAnswer;

  static const _quizQuestion = 'مدل کوانتومی اتم چگونه جایگزین مدل بور شد؟';
  static const _answers = [
    'چون مدل بور مسیرهای کاملاً مشخص برای الکترون‌ها در نظر می‌گرفت، اما مدل کوانتومی رفتار الکترون را به‌صورت تابع احتمال توصیف می‌کند.',
    'چون مدل بور وجود الکترون را رد می‌کرد و مدل کوانتومی آن را دوباره معرفی کرد.',
    'چون مدل بور انرژی الکترون‌ها را پیوسته می‌دانست، ولی مدل کوانتومی آن‌ها را ناپیوسته کرد.',
    'چون مدل کوانتومی ثابت کرد که هسته اتم وجود ندارد.',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Quiz video header area (dark area showing topic)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'کوییز آموزشی',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _quizQuestion,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Answer options - 2 columns using Wrap or manual layout
          _buildAnswerRow(0, 1),
          const SizedBox(height: 16),
          _buildAnswerRow(2, 3),
        ],
      ),
    );
  }

  Widget _buildAnswerRow(int index1, int index2) {
    return Row(
      children: [
        Expanded(
          child: _buildAnswerCard(index1),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnswerCard(index2),
        ),
      ],
    );
  }

  Widget _buildAnswerCard(int index) {
    final isSelected = _selectedAnswer == index;
    final number = ['۱', '۲', '۳', '۴'][index];
    return _QuizAnswerCard(
      number: number,
      text: _answers[index],
      isSelected: isSelected,
      isCorrect: index == 0,
      showResult: _selectedAnswer != null,
      onTap: () {
        if (_selectedAnswer == null) {
          setState(() => _selectedAnswer = index);
        }
      },
    );
  }
}

class _QuizAnswerCard extends StatelessWidget {
  final String number;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const _QuizAnswerCard({
    required this.number,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.cardBorder;
    Color bgColor = AppColors.cardBackgroundLight;

    if (showResult && isSelected) {
      borderColor = isCorrect ? const Color(0xFF4CAF50) : Colors.red;
      bgColor =
          (isCorrect ? const Color(0xFF4CAF50) : Colors.red).withOpacity(0.15);
    }

    return FocusableItem(
      onSelect: onTap,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: showResult && isSelected
                ? borderColor
                : (isFocused ? AppColors.primary : AppColors.cardBorder),
            width: isSelected || isFocused ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Answer text (on left in RTL)
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            // Number badge (on right in RTL)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

// Text content widget
class _TextContent extends StatelessWidget {
  const _TextContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParagraph('تراز انرژی مثل طبقه‌های یک ساختمان هستند؛'),
          _buildParagraph(
            'الکترون‌ها می‌توانند در هر طبقه قرار بگیرند، اما هر طبقه ظرفیت مشخصی دارد.',
          ),
          _buildParagraph(
            'هرچه تراز انرژی دورتر از هسته باشد، انرژی بیشتری دارد و الکترون‌ها در آن آزادترند.',
          ),
          const SizedBox(height: 24),
          const Text(
            'زیرلایه‌ها (s, p, d, f)',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildParagraph('درون هر تراز، چند زیرلایه وجود دارد.'),
          _buildParagraph('هر زیرلایه، شکل و ظرفیت متفاوتی دارد.'),
          _buildParagraph('مثلاً:'),
          const SizedBox(height: 12),
          _buildBulletPoint('زیرلایه s فقط ۲ الکترون'),
          _buildBulletPoint('زیرلایه p فقط ۶ الکترون'),
          _buildBulletPoint('زیرلایه d فقط ۱۰ الکترون می‌پذیرد.'),
          const SizedBox(height: 16),
          _buildParagraph(
            'همین تفاوت زیرلایه‌ها باعث تنوع عجیب‌وغریب رفتار عنصرها شده است.',
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 16,
          height: 1.8,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Table of contents chapter
class _TOCChapter extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final List<Widget> children;

  const _TOCChapter({
    required this.title,
    required this.isExpanded,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter header (RTL order)
        FocusableItem(
          onSelect: () {}, // Future expansion logic
          builder: (isFocused) => AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isFocused
                  ? Colors.white.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Book icon on right (start in RTL)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.folder_open_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                // Title next to icon
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Chevron
                Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: Colors.white.withOpacity(0.3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(children: children),
          ),
        ],
      ],
    );
  }
}

// Table of contents item
class _TOCItem extends StatelessWidget {
  final String title;
  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  const _TOCItem({
    required this.title,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (type) {
      case 'video':
        return Icons.play_circle_outline_rounded;
      case 'experiment':
        return Icons.science_outlined;
      case 'quiz':
        return Icons.quiz_outlined;
      case 'text':
      default:
        return Icons.article_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: FocusableItem(
        onSelect: onTap,
        builder: (isFocused) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isFocused
                    ? Colors.white.withOpacity(0.08)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon (on right in RTL)
              Icon(
                _icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
              // Title (expands from start in RTL)
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Student avatar placeholder
class _StudentAvatar extends StatelessWidget {
  final double size;
  const _StudentAvatar({this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 1.3,
      color: const Color(0xFFE8E8E8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: size * 0.5, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text('تصویر دانش‌آموز',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }
}

// History icon for attendance
class _HistoryIcon extends StatelessWidget {
  final String status;
  const _HistoryIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color iconColor;
    IconData icon;

    switch (status) {
      case 'present':
        bgColor = Colors.green;
        iconColor = Colors.white;
        icon = Icons.check_rounded;
        break;
      case 'absent':
        bgColor = Colors.red;
        iconColor = Colors.white;
        icon = Icons.close_rounded;
        break;
      case 'late':
        bgColor = Colors.white;
        iconColor = Colors.black54;
        icon = Icons.access_time_rounded;
        break;
      default:
        bgColor = Colors.grey;
        iconColor = Colors.white;
        icon = Icons.remove;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}

// Attendance progress bar
class _AttendanceProgressBar extends StatelessWidget {
  final int present;
  final int absent;
  final int late;

  const _AttendanceProgressBar(
      {required this.present, required this.absent, required this.late});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
              flex: late,
              child: Container(color: Colors.white.withOpacity(0.3))),
          Expanded(flex: absent, child: Container(color: Colors.red)),
          Expanded(flex: present, child: Container(color: Colors.green)),
        ],
      ),
    );
  }
}

// Legend item
class _LegendItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _LegendItem(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$count جلسه',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(width: 8),
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(width: 6),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }
}

// Navigation arrow button
class _NavArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onPressed,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isFocused ? AppColors.primary : AppColors.cardBorder,
              width: isFocused ? 2 : 1),
        ),
        child: Icon(icon,
            color: isFocused ? Colors.white : AppColors.textSecondary,
            size: 28),
      ),
    );
  }
}

// Attendance status selection button
class _AttendanceStatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onSelect;

  const _AttendanceStatusButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableItem(
      onSelect: onSelect,
      builder: (isFocused) {
        final showColor = isSelected || isFocused;
        final bgColor =
            isSelected ? color.withOpacity(0.2) : AppColors.cardBackground;
        final borderColor =
            isSelected ? color : (isFocused ? color : AppColors.cardBorder);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 100,
          height: 130,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: borderColor,
                width: isSelected ? 3 : (isFocused ? 2 : 1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar with icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: showColor
                      ? color.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(Icons.person,
                          size: 36, color: showColor ? color : Colors.grey),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: showColor ? color : Colors.grey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(icon, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: showColor ? color : AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// ATTENDANCE METHOD DIALOG
// ============================================================================

class AttendanceMethodDialog extends StatelessWidget {
  final VoidCallback onFaceRecognition;
  final VoidCallback onVoiceRecognition;

  const AttendanceMethodDialog({
    super.key,
    required this.onFaceRecognition,
    required this.onVoiceRecognition,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 700,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'لطفاً روش حضور و غیاب را انتخاب کنید.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'می‌توانید از تشخیص چهره یا تشخیص صدا برای ثبت حضور دانش‌آموزان استفاده کنید. روش دلخواه خود را انتخاب کنید تا سیستم بر اساس همان فعال شود.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.9),
                    fontSize: 15,
                    height: 1.6),
              ),
              const SizedBox(height: 32),
              // Method selection cards - Face on right (first in RTL), Voice on left
              Row(
                children: [
                  Expanded(
                      child: _MethodCard(
                    title: 'تشخیص چهره',
                    icon: Icons.face_retouching_natural_rounded,
                    onSelect: onFaceRecognition,
                  )),
                  const SizedBox(width: 24),
                  Expanded(
                      child: _MethodCard(
                    title: 'تشخیص صدا',
                    icon: Icons.graphic_eq_rounded,
                    onSelect: onVoiceRecognition,
                    isVoice: true,
                  )),
                ],
              ),
              const SizedBox(height: 32),
              // Cancel button
              FocusableItem(
                onSelect: () => Navigator.pop(context),
                builder: (isFocused) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: isFocused
                            ? AppColors.primary
                            : AppColors.cardBorder,
                        width: isFocused ? 2 : 1),
                  ),
                  child: Text(
                    'انصراف',
                    style: TextStyle(
                        color: isFocused
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onSelect;
  final bool isVoice;

  const _MethodCard({
    required this.title,
    required this.icon,
    required this.onSelect,
    this.isVoice = false,
  });

  @override
  Widget build(BuildContext context) {
    // Olive/brownish gradient colors like camera viewfinder effect
    final gradientColors = isVoice
        ? [
            const Color(0xFF4A5D23),
            const Color(0xFF3D4A20),
            const Color(0xFF2A331A)
          ]
        : [
            const Color(0xFF4A5D23),
            const Color(0xFF3D4A20),
            const Color(0xFF2A331A)
          ];

    return FocusableItem(
      onSelect: onSelect,
      builder: (isFocused) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isFocused ? AppColors.primary : Colors.transparent,
              width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white.withOpacity(0.7), width: 2),
              ),
              child: Icon(icon, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ATTENDANCE SUCCESS SCREEN
// ============================================================================

class _AttendanceSuccessScreen extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final bool isGuest;

  const _AttendanceSuccessScreen(
      {required this.onContinue, required this.onBack, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NoiseBackground(
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              // Main content - pushes left when sidebar expands
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 32, 24, 40),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          _BackButton(onPressed: onBack),
                          const Spacer(),
                          FocusableItem(
                            onSelect: onContinue,
                            builder: (isFocused) => AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: isFocused
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('بخش بعدی',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  SizedBox(width: 6),
                                  Icon(Icons.chevron_right_rounded,
                                      size: 24, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Tabs (same as before but disabled visually)
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildTab('حضور و غیاب کلاسی', true),
                            const SizedBox(width: 12),
                            _buildTab('بررسی تکالیف', false),
                            const SizedBox(width: 12),
                            _buildTab('طرح درس این جلسه', false),
                            const SizedBox(width: 12),
                            _buildTab('امتحان کلاسی', false),
                            const SizedBox(width: 12),
                            _buildTab('تکلیف جلسه بعد', false),
                            const SizedBox(width: 12),
                            _buildTab('طرح درس جلسه بعد', false),
                          ],
                        ),
                      ),
                      // Success content
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Checkmark circle
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.green.withOpacity(0.4),
                                        blurRadius: 40,
                                        spreadRadius: 10),
                                  ],
                                ),
                                child: const Icon(Icons.check_rounded,
                                    size: 90, color: Colors.white),
                              ),
                              const SizedBox(height: 32),
                              const Text(
                                'حضور و غیاب انجام شد',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24),
                              // Continue button
                              FocusableItem(
                                autofocus: true,
                                onSelect: onContinue,
                                builder: (isFocused) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: isFocused
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2),
                                    boxShadow: isFocused
                                        ? [
                                            BoxShadow(
                                                color: AppColors.primary
                                                    .withOpacity(0.4),
                                                blurRadius: 20)
                                          ]
                                        : [],
                                  ),
                                  child: const Text(
                                    'رفتن به بخش بررسی تکلیف',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Sidebar - pushes content when expanded
              _Sidebar(
                expanded: false,
                selectedIndex: 2,
                isGuest: isGuest,
                onHover: (_) {},
                onSelect: (_) {},
                onLogout: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.transparent : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2 : 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

// ============================================================================
// LESSON SUMMARY SCREEN - Shows after completing lesson plan
// ============================================================================

class _LessonSummaryScreen extends StatelessWidget {
  final VoidCallback onGoToExam;
  final VoidCallback onBack;
  final bool isGuest;

  const _LessonSummaryScreen({
    required this.onGoToExam,
    required this.onBack,
    required this.isGuest,
  });

  // Topics data
  static const _topics = [
    {
      'title': 'مدل کوانتومی و ترازهای انرژی',
      'completed': 2,
      'total': 3,
      'items': [
        {'text': 'چرا مدل‌های قدیمی کافی نبودند؟', 'done': true},
        {'text': 'ترازهای انرژی؛ خانه‌های اصلی الکترون‌ها', 'done': true},
        {'text': 'زیرلایه‌ها (s, p, d, f)', 'done': false},
      ],
    },
    {
      'title': 'آرایش الکترونی؛ شناسنامهٔ هر عنصر',
      'completed': 0,
      'total': 3,
      'items': [
        {'text': 'آرایش الکترونی یعنی چه؟', 'done': true},
        {'text': 'الکترون‌های ظرفیت؛ کلید رفتار شیمیایی', 'done': false},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NoiseBackground(
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              // Main content - pushes left when sidebar expands
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 32, 24, 40),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          _BackButton(onPressed: onBack),
                          const Spacer(),
                          // Previous section button
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: FocusableItem(
                              onSelect: onBack,
                              builder: (isFocused) => AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isFocused
                                        ? AppColors.primary
                                        : AppColors.cardBorder,
                                    width: isFocused ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.play_arrow_rounded,
                                        size: 20,
                                        color: isFocused
                                            ? Colors.white
                                            : AppColors.textSecondary),
                                    const SizedBox(width: 6),
                                    Text('بخش قبل',
                                        style: TextStyle(
                                            color: isFocused
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Next section button
                          FocusableItem(
                            onSelect: onGoToExam,
                            builder: (isFocused) => AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isFocused
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('بخش بعدی',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  SizedBox(width: 6),
                                  Icon(Icons.chevron_right_rounded,
                                      size: 24, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Tabs
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildTab('حضور و غیاب کلاسی', false),
                            const SizedBox(width: 12),
                            _buildTab('بررسی تکالیف', false),
                            const SizedBox(width: 12),
                            _buildTab('طرح درس این جلسه', true),
                            const SizedBox(width: 12),
                            _buildTab('امتحان کلاسی', false),
                            const SizedBox(width: 12),
                            _buildTab('تکلیف جلسه بعد', false),
                            const SizedBox(width: 12),
                            _buildTab('طرح درس جلسه بعد', false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Main content area
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Go to exam button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FocusableItem(
                                  onSelect: onGoToExam,
                                  builder: (isFocused) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isFocused
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Text(
                                      'رفتن به بخش امتحان کلاسی',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Donut chart card
                                Container(
                                  width: 340,
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppColors.cardBorder
                                            .withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    children: [
                                      // Donut chart
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: CustomPaint(
                                          painter: _LessonDonutPainter(
                                              percentage: 0.45),
                                          child: const Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '۴۵',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 48,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'درصد',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      const Text(
                                        'مقدار مطالبی که در این جلسه باید تدریس داده می‌شد.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            // Topics list
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'مطالبی که در این جلسه تدریس شد',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: _topics.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 16),
                                      itemBuilder: (context, index) {
                                        final topic = _topics[index];
                                        return _TopicCard(
                                          title: topic['title'] as String,
                                          completed: topic['completed'] as int,
                                          total: topic['total'] as int,
                                          items: (topic['items'] as List)
                                              .cast<Map<String, dynamic>>(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Sidebar - pushes content when expanded
              _Sidebar(
                expanded: false,
                selectedIndex: 3,
                isGuest: isGuest,
                onHover: (_) {},
                onSelect: (_) {},
                onLogout: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.transparent : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.cardBorder,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

// Topic card for lesson summary
class _TopicCard extends StatelessWidget {
  final String title;
  final int completed;
  final int total;
  final List<Map<String, dynamic>> items;

  const _TopicCard({
    required this.title,
    required this.completed,
    required this.total,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Progress indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$completed از $total',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
              const Spacer(),
              // Title
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Items list
          ...items.map((item) => _TopicItem(
                text: item['text'] as String,
                isDone: item['done'] as bool,
              )),
        ],
      ),
    );
  }
}

// Topic item with checkbox
class _TopicItem extends StatelessWidget {
  final String text;
  final bool isDone;

  const _TopicItem({required this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Checkbox
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: isDone ? AppColors.primary : AppColors.cardBorder,
                width: 2,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : null,
          ),
          const Spacer(),
          // Text
          Text(
            text,
            style: TextStyle(
              color: isDone ? Colors.white : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Donut chart painter for lesson summary
class _LessonDonutPainter extends CustomPainter {
  final double percentage;

  _LessonDonutPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 20.0;

    // Background arc (gray)
    final bgPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc (blue)
    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -3.14159 / 2; // Start from top
    final sweepAngle = 2 * 3.14159 * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
