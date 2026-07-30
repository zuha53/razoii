import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
/// ---------------------------------------------------------------------
/// LUXURY ANIMATED LOGIN SCREEN — RAZOII
/// A single, code-drawn silhouette character (always visually consistent)
/// + a gold shimmer particle background.
/// No external animation files needed — everything is native Flutter.
/// ---------------------------------------------------------------------

enum LoginPhase { walkingIn, idle, success, fail }

class LuxuryAnimatedLoginScreen extends StatefulWidget {
  const LuxuryAnimatedLoginScreen({super.key});

  @override
  State<LuxuryAnimatedLoginScreen> createState() =>
      _LuxuryAnimatedLoginScreenState();
}

class _LuxuryAnimatedLoginScreenState extends State<LuxuryAnimatedLoginScreen>
    with TickerProviderStateMixin {
  LoginPhase _phase = LoginPhase.walkingIn;
  bool _showCard = false;
  bool _isSignup = false;
  bool _isSubmitting = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // Walk-in slide position
  late final AnimationController _walkController;
  late final Animation<double> _walkPosition;

  // Continuous shimmer / particle time source
  late final AnimationController _shimmerController;

  // Pose blend (0..1) used to ease between poses
  late final AnimationController _poseController;

  final List<_Particle> _particles =
      List.generate(26, (i) => _Particle.random());

  @override
  void initState() {
    super.initState();

    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _walkPosition = Tween<double>(begin: -0.4, end: -0.05).animate(
      CurvedAnimation(parent: _walkController, curve: Curves.easeOutCubic),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _poseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _walkController.forward();
    _walkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _phase = LoginPhase.idle;
          _showCard = true;
        });
        _poseController.forward();
      }
    });
  }

  @override
  void dispose() {
    _walkController.dispose();
    _shimmerController.dispose();
    _poseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      if (_isSignup) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseAuth.instance.currentUser?.updateDisplayName(
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      await _resolvePhase(LoginPhase.success);
      // TODO: Navigator.pushReplacement(...) to home screen here.
    } on FirebaseAuthException catch (_) {
      await _resolvePhase(LoginPhase.fail);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _resolvePhase(LoginPhase result) async {
    setState(() => _phase = result);
    _poseController
      ..reset()
      ..forward();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    setState(() => _phase = LoginPhase.idle);
    _poseController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final gold = context.colors.gold;
    final purple = context.colors.purple;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ---- Shimmer particle background ----
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, _) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ShimmerPainter(
                    time: _shimmerController.value,
                    particles: _particles,
                    color: gold,
                  ),
                );
              },
            ),

            // ---- Logo ----
            Positioned(
              top: 24,
              child: AnimatedOpacity(
                opacity: _showCard ? 1 : 0,
                duration: const Duration(milliseconds: 700),
                child: Text(
                  'RAZOII',
                  style: TextStyle(
                    color: gold,
                    fontSize: 26,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // ---- Silhouette character ----
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_walkController, _shimmerController, _poseController]),
              builder: (context, _) {
                final pose = _poseFor(_phase, _shimmerController.value,
                    _walkController.value, _poseController.value);
                return Align(
                  alignment: Alignment(_walkPosition.value, 0.42),
                  child: SizedBox(
                    width: 130,
                    height: 220,
                    child: CustomPaint(
                      painter: _SilhouettePainter(pose: pose, color: gold),
                    ),
                  ),
                );
              },
            ),

            // ---- Floating login/signup card ----
            AnimatedOpacity(
              opacity: _showCard ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: AnimatedSlide(
                offset: _showCard ? Offset.zero : const Offset(0, 0.3),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                child: _buildCard(gold, purple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Color gold, Color purple) {
    return Container(
      width: 340,
      margin: const EdgeInsets.only(top: 90, left: 24, right: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isSignup ? 'Create Account' : 'Welcome Back',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_isSignup) ...[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (v) =>
                  (v == null || v.length < 6) ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isSignup ? 'Sign Up' : 'Log In'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() => _isSignup = !_isSignup),
              child: Text(_isSignup
                  ? 'Already have an account? Log In'
                  : 'New here? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  /// Blends pose parameters depending on current phase.
  _Pose _poseFor(
      LoginPhase phase, double shimmerT, double walkT, double poseT) {
    switch (phase) {
      case LoginPhase.walkingIn:
        final cycle = sin(walkT * 18);
        return _Pose(
          lean: 0.02,
          armL: 0.3 + cycle * 0.5,
          armR: -0.3 - cycle * 0.5,
          legSpread: cycle * 0.4,
          headTilt: 0,
          bounce: cycle.abs() * 3,
        );
      case LoginPhase.idle:
        final sway = sin(shimmerT * 2 * pi) * 0.03;
        return _Pose(
          lean: 0.22 + sway,
          armL: 0.9,
          armR: -0.15,
          legSpread: 0.08,
          headTilt: 0.05,
          bounce: 0,
        );
      case LoginPhase.success:
        final jump = sin(poseT * pi).clamp(0.0, 1.0);
        return _Pose(
          lean: -0.05,
          armL: -1.3 * poseT.clamp(0.0, 1.0),
          armR: 1.3 * poseT.clamp(0.0, 1.0),
          legSpread: 0.15,
          headTilt: -0.15,
          bounce: -jump * 14,
        );
      case LoginPhase.fail:
        return _Pose(
          lean: 0.35 * poseT.clamp(0.0, 1.0),
          armL: 0.15,
          armR: -0.05,
          legSpread: 0.05,
          headTilt: 0.3 * poseT.clamp(0.0, 1.0),
          bounce: 4 * poseT.clamp(0.0, 1.0),
        );
    }
  }
}

/// Pose parameters shared by every state — same figure, different angles.
class _Pose {
  final double lean; // torso lean angle (radians)
  final double armL; // left arm angle
  final double armR; // right arm angle
  final double legSpread;
  final double headTilt;
  final double bounce; // vertical offset

  _Pose({
    required this.lean,
    required this.armL,
    required this.armR,
    required this.legSpread,
    required this.headTilt,
    required this.bounce,
  });
}

/// Draws one consistent minimalist line-art silhouette figure,
/// posed according to [pose]. Same figure is reused for every
/// login state so the character never changes identity.
class _SilhouettePainter extends CustomPainter {
  final _Pose pose;
  final Color color;

  _SilhouettePainter({required this.pose, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fill = Paint()..color = color;

    final cx = size.width / 2;
    final topY = 30.0 + pose.bounce;

    canvas.save();
    canvas.translate(cx, topY);
    canvas.rotate(pose.lean);

    // Head
    canvas.drawCircle(Offset(0, -8 + pose.headTilt * 10), 16, fill);

    // Torso
    final torsoTop = const Offset(0, 8);
    final torsoBottom = const Offset(0, 90);
    canvas.drawLine(torsoTop, torsoBottom, paint);

    // Arms
    final shoulder = const Offset(0, 20);
    final armLEnd = Offset(
      shoulder.dx - 45 * cos(pose.armL),
      shoulder.dy + 45 * sin(pose.armL).abs() + 10,
    );
    final armREnd = Offset(
      shoulder.dx + 45 * cos(pose.armR),
      shoulder.dy + 45 * sin(pose.armR).abs() + 10,
    );
    canvas.drawLine(shoulder, armLEnd, paint);
    canvas.drawLine(shoulder, armREnd, paint);

    // Legs
    final hip = const Offset(0, 90);
    final legLEnd = Offset(hip.dx - 20 - pose.legSpread * 20, hip.dy + 70);
    final legREnd = Offset(hip.dx + 20 + pose.legSpread * 20, hip.dy + 70);
    canvas.drawLine(hip, legLEnd, paint);
    canvas.drawLine(hip, legREnd, paint);

    // Bag (held in right hand) — always present, ties to "carrying a bag" idea
    final bagCenter = armREnd.translate(6, 10);
    final bagRect = Rect.fromCenter(center: bagCenter, width: 22, height: 26);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bagRect, const Radius.circular(4)),
      Paint()..color = color.withOpacity(0.85),
    );
    canvas.drawArc(
      Rect.fromCenter(
          center: bagCenter.translate(0, -13), width: 14, height: 14),
      pi,
      pi,
      false,
      paint..strokeWidth = 3,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SilhouettePainter oldDelegate) => true;
}

class _Particle {
  final double x, seed, speed, size;
  _Particle(this.x, this.seed, this.speed, this.size);

  factory _Particle.random() {
    final r = Random();
    return _Particle(
      r.nextDouble(),
      r.nextDouble() * 2 * pi,
      0.4 + r.nextDouble() * 0.6,
      1.5 + r.nextDouble() * 2.5,
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final double time;
  final List<_Particle> particles;
  final Color color;

  _ShimmerPainter({
    required this.time,
    required this.particles,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (time * p.speed + p.seed) % 1.0;
      final dx = p.x * size.width;
      final dy = size.height * (1 - t);
      final opacity = (sin(t * pi)).clamp(0.0, 1.0) * 0.5;
      canvas.drawCircle(
        Offset(dx, dy),
        p.size,
        Paint()..color = color.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) => true;
}
