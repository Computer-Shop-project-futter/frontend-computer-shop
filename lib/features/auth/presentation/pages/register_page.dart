import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
	const RegisterPage({super.key});

	@override
	ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
	final _fullNameController = TextEditingController();
	final _emailController = TextEditingController();
	final _phoneController = TextEditingController();
	final _passwordController = TextEditingController();
	final _confirmController = TextEditingController();
	String _selectedRole = 'customer';
	bool _obscurePassword = true;
	bool _obscureConfirm = true;

	@override
	void initState() {
		super.initState();

		ref.listenManual<AuthState>(authProvider, (previous, next) {
			if (next.status == AuthStatus.authenticated) {
				WidgetsBinding.instance.addPostFrameCallback((_) {
					context.go('/home');
				});
			}

			if (next.status == AuthStatus.error) {
				final msg = next.message ?? 'Registration failed.';
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text(msg)));

				ref.read(authProvider.notifier).clearError();
			}
		});
	}

	@override
	void dispose() {
		_fullNameController.dispose();
		_emailController.dispose();
		_phoneController.dispose();
		_passwordController.dispose();
		_confirmController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final size = MediaQuery.of(context).size;
		final authState = ref.watch(authProvider);
	

		return Scaffold(
			body: Container(
				width: double.infinity,
				height: double.infinity,
				decoration: const BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topCenter,
						end: Alignment.bottomCenter,
						colors: [
							Color(0xFFEAF2FF),
							Color(0xFFF6F9FF),
							Colors.white,
						],
					),
				),
				child: SafeArea(
					child: Stack(
						children: [
							Positioned(
								top: -50,
								left: -30,
								child: Container(
									width: size.width * 0.45,
									height: size.width * 0.45,
									decoration: BoxDecoration(
										shape: BoxShape.circle,
										color: const Color(0xFF2A66FF).withOpacity(0.08),
									),
								),
							),
							Positioned(
								bottom: -70,
								right: -40,
								child: Container(
									width: size.width * 0.55,
									height: size.width * 0.55,
									decoration: BoxDecoration(
										shape: BoxShape.circle,
										color: const Color(0xFF2A66FF).withOpacity(0.06),
									),
								),
							),
							Center(
								child: SingleChildScrollView(
									padding: const EdgeInsets.symmetric(horizontal: 24),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.center,
										children: [
											Image.asset(
												'assets/images/g14_logo.png',
												width: 92,
												height: 92,
											),
											const SizedBox(height: 10),
											const Text(
												'Create Your Account',
												style: TextStyle(
													fontSize: 20,
													fontWeight: FontWeight.w700,
													color: Color(0xFF0D1B3D),
												),
											),
											const SizedBox(height: 4),
											const Text(
												'Join us and get started',
												style: TextStyle(
													fontSize: 13,
													color: Color(0xFF7C8AA6),
												),
											),
											const SizedBox(height: 18),
												const Align(
												  alignment: Alignment.centerLeft,
												  child: Text(
												    'Select Role',
												    style: TextStyle(
												      fontSize: 12,
												      fontWeight: FontWeight.w600,
												      color: Color(0xFF1A1917),
												    ),
												  ),
												),
												const SizedBox(height: 8),
												Wrap(
												  spacing: 10,
												  runSpacing: 10,
												  children: [
												    _RoleChoiceChip(
												      label: 'Customer',
												      selected: _selectedRole == 'customer',
												      onTap: () => setState(() => _selectedRole = 'customer'),
												    ),
												    _RoleChoiceChip(
												      label: 'Staff',
												      selected: _selectedRole == 'staff',
												      onTap: () => setState(() => _selectedRole = 'staff'),
												    ),
												  ],
												),
												const SizedBox(height: 18),
											Container(
												padding: const EdgeInsets.symmetric(
													horizontal: 16,
													vertical: 18,
												),
												decoration: BoxDecoration(
													color: Colors.white,
													borderRadius: BorderRadius.circular(20),
													boxShadow: [
														BoxShadow(
															color: Colors.black.withOpacity(0.06),
															blurRadius: 18,
															offset: const Offset(0, 10),
														),
													],
												),
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.stretch,
													children: [
														AuthFormField(
															label: 'Full Name',
															hintText: 'Enter your name',
															controller: _fullNameController,
														),
														const SizedBox(height: 12),
														AuthFormField(
															label: 'Email Address',
															hintText: 'name@company.com',
															controller: _emailController,
															keyboardType: TextInputType.emailAddress,
														),
														const SizedBox(height: 12),
														AuthFormField(
															label: 'Phone Number',
															hintText: '+1 000 000 0000',
															controller: _phoneController,
															keyboardType: TextInputType.phone,
														),
														const SizedBox(height: 12),
														AuthFormField(
															label: 'Password',
															hintText: 'Create a password',
															controller: _passwordController,
															obscureText: _obscurePassword,
															suffixIcon: _obscurePassword
																	? Icons.visibility_off_outlined
																	: Icons.visibility_outlined,
															onSuffixTap: () => setState(() {
																_obscurePassword = !_obscurePassword;
															}),
														),
														const SizedBox(height: 12),
														AuthFormField(
															label: 'Confirm Password',
															hintText: 'Repeat your password',
															controller: _confirmController,
															obscureText: _obscureConfirm,
															suffixIcon: _obscureConfirm
																	? Icons.visibility_off_outlined
																	: Icons.visibility_outlined,
															onSuffixTap: () => setState(() {
																_obscureConfirm = !_obscureConfirm;
															}),
														),
														const SizedBox(height: 12),
														Row(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Checkbox(
																	value: true,
																	onChanged: (_) {},
																	activeColor: const Color(0xFF2A66FF),
																),
																Expanded(
																	child: RichText(
																		text: const TextSpan(
																			style: TextStyle(
																				fontSize: 11,
																				color: Color(0xFF7C8AA6),
																				height: 1.4,
																			),
																			children: [
																				TextSpan(text: 'I agree to G14 Tech\'s '),
																				TextSpan(
																					text: 'Terms of Service',
																					style: TextStyle(
																						color: Color(0xFF2A66FF),
																						fontWeight: FontWeight.w600,
																					),
																				),
																				TextSpan(text: ' and '),
																				TextSpan(
																					text: 'Privacy Policy',
																					style: TextStyle(
																						color: Color(0xFF2A66FF),
																						fontWeight: FontWeight.w600,
																					),
																				),
																				TextSpan(text: '.'),
																			],
																		),
																	),
																),
															],
														),
														const SizedBox(height: 8),
														ElevatedButton(
															onPressed: authState.status == AuthStatus.loading
																? null
																: () {
																	if (_passwordController.text != _confirmController.text) {
																		ScaffoldMessenger.of(context).showSnackBar(
																			const SnackBar(content: Text('Passwords do not match.')),
																		);
																		return;
																	}
																	ref.read(authProvider.notifier).register(
																		_fullNameController.text.trim(),
																		_emailController.text.trim(),
																		_phoneController.text.trim(),
																		_passwordController.text,
																		_selectedRole,
																	);
																},
															style: ElevatedButton.styleFrom(
																backgroundColor: const Color(0xFF2A66FF),
																foregroundColor: Colors.white,
																padding: const EdgeInsets.symmetric(
																	vertical: 14,
																),
																shape: RoundedRectangleBorder(
																	borderRadius: BorderRadius.circular(14),
																),
																elevation: 0,
															),
															child: Row(
																mainAxisAlignment: MainAxisAlignment.center,
																children: [
																	Text(
																		authState.status == AuthStatus.loading ? 'Loading...' : 'Sign Up',
																		style: const TextStyle(
																			fontSize: 14,
																			fontWeight: FontWeight.w600,
																		),
																	),
																	const SizedBox(width: 8),
																	const Icon(Icons.arrow_forward, size: 18),
																],
															),
														),
													],
												),
											),
											const SizedBox(height: 16),
											Row(
												mainAxisAlignment: MainAxisAlignment.center,
												children: [
													const Text(
														'Already have an account?',
														style: TextStyle(
															fontSize: 12,
															color: Color(0xFF7C8AA6),
														),
													),
													TextButton(
														onPressed: () => context.push('/login'),
														style: TextButton.styleFrom(
															foregroundColor: const Color(0xFF2A66FF),
														),
														child: const Text(
															'Login',
															style: TextStyle(fontSize: 12),
														),
													),
												],
											),
											const SizedBox(height: 24),
										],
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


class _RoleChoiceChip extends StatelessWidget {
	final String label;
	final bool selected;
	final VoidCallback onTap;

	const _RoleChoiceChip({
		required this.label,
		required this.selected,
		required this.onTap,
	});

	@override
	Widget build(BuildContext context) {
		return ChoiceChip(
			selected: selected,
			onSelected: (_) => onTap(),
			label: Text(label),
			labelStyle: TextStyle(
				color: selected ? Colors.white : const Color(0xFF0D1B3D),
				fontWeight: FontWeight.w600,
				fontSize: 12,
			),
			selectedColor: const Color(0xFF2A66FF),
			backgroundColor: const Color(0xFFF2F6FF),
			side: const BorderSide(color: Color(0xFFD7E4FF)),
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
		);
	}
}
