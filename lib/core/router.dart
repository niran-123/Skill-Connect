import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

import '../screens/shared/splash_screen.dart';
import '../screens/shared/onboarding_screen.dart';
import '../screens/shared/shared_screens.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/pro_registration_screen.dart';

import '../screens/customer/customer_shell.dart';
import '../screens/customer/customer_home_screen.dart';
import '../screens/customer/search_professionals_screen.dart';
import '../screens/customer/job_request_screen.dart';
import '../screens/customer/professional_list_screen.dart';
import '../screens/customer/professional_detail_screen.dart';
import '../screens/customer/customer_bookings_screen.dart';
import '../screens/customer/review_screen.dart';
import '../screens/customer/booking_request_screen.dart';
import '../screens/customer/booking_sent_screen.dart';
import '../screens/customer/booking_details_screen.dart';
import '../screens/customer/customer_notifications_screen.dart';
import '../screens/customer/customer_profile_screen.dart';
import '../screens/customer/edit_customer_profile_screen.dart';
import '../screens/customer/saved_professionals_screen.dart';

import '../screens/professional/professional_shell.dart';
import '../screens/professional/professional_dashboard.dart';
import '../screens/professional/professional_settings_screen.dart';
import '../screens/professional/job_execution_screen.dart';
import '../screens/professional/service_request_details_screen.dart';
import '../screens/professional/service_requests_screen.dart';
import '../models/professional.dart';
import '../screens/professional/job_history_screen.dart';
import '../screens/professional/pro_notifications_screen.dart';
import '../screens/professional/pro_profile_view_screen.dart';
import '../screens/professional/edit_pro_profile_screen.dart';
import '../screens/professional/manage_skills_rates_screen.dart';
import '../screens/professional/document_verification_screen.dart';

import '../screens/admin/admin_screen.dart';
import '../models/match_result.dart';
import '../models/booking.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: _routerNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final session = context.read<SessionProvider>();
      
      final isAuthRoute = state.matchedLocation == '/login' || 
                          state.matchedLocation == '/signup' || 
                          state.matchedLocation == '/forgot-password' ||
                          state.matchedLocation == '/pro-registration' ||
                          state.matchedLocation == '/role-selection';
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isRoleSelection = state.matchedLocation == '/role-selection';

      if (session.isLoading) return isSplash ? null : '/';
      
      if (session.authUser == null) {
        if (isSplash) return '/onboarding';
        if (isOnboarding || isAuthRoute) return null;
        return '/login';
      }

      if (session.userModel == null) {
        return isRoleSelection || isAuthRoute ? null : '/role-selection';
      }

      final role = session.userModel!.role;
      if (isAuthRoute || isSplash || isOnboarding || isRoleSelection) {
        if (role == 'customer') return '/customer/home';
        if (role == 'professional') return '/professional/dashboard';
        if (role == 'admin') return '/admin';
      }

      if (state.matchedLocation.startsWith('/customer') && role != 'customer') return '/login';
      if (state.matchedLocation.startsWith('/professional') && role != 'professional') return '/login';
      if (state.matchedLocation.startsWith('/admin') && role != 'admin') return '/login';

      return null;
    },
    routes: [
      GoRoute(
        name: 'splash',
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'forgot-password',
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        name: 'signup',
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        name: 'pro-registration',
        path: '/pro-registration',
        builder: (context, state) => const ProRegistrationScreen(),
      ),
      GoRoute(
        name: 'role-selection',
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),

      // SHARED ROUTES
      GoRoute(
        name: 'help',
        path: '/help',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        name: 'faq',
        path: '/faq',
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        name: 'terms',
        path: '/terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        name: 'privacy',
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        name: 'notification-details',
        path: '/notification-details/:id',
        builder: (context, state) => NotificationDetailsScreen(id: state.pathParameters['id']!),
      ),

      // CUSTOMER ROUTES
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => CustomerShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'customer-home',
                path: '/customer/home',
                builder: (context, state) => const CustomerHomeScreen(),
                routes: [
                  GoRoute(
                    name: 'customer-request',
                    path: 'request',
                    builder: (context, state) {
                      final category = state.extra as String?;
                      return JobRequestScreen(initialCategory: category);
                    },
                  ),
                  GoRoute(
                    name: 'customer-matches',
                    path: 'matches',
                    builder: (context, state) => const ProfessionalListScreen(),
                    routes: [
                      GoRoute(
                        name: 'customer-match-detail',
                        path: ':id',
                        builder: (context, state) {
                          final match = state.extra as MatchResult?;
                          return ProfessionalDetailScreen(match: match ?? MatchResult(professional: ProfessionalModel(uid: 'unknown', name: 'Unknown', category: 'Unknown', city: '', area: ''), totalScore: 100, skillScore: 100, trustScore: 100, similarJobsScore: 100, successRateScore: 100, availabilityScore: 100, locationScore: 100, recencyScore: 100, reasons: []));
                        },
                      ),
                    ]
                  ),
                  GoRoute(
                    name: 'customer-booking-request',
                    path: 'booking-request',
                    builder: (context, state) {
                      final match = state.extra as MatchResult?;
                      return BookingRequestScreen(match: match!);
                    }
                  ),
                  GoRoute(
                    name: 'customer-booking-sent',
                    path: 'booking-sent',
                    builder: (context, state) => const BookingSentScreen(),
                  ),
                ]
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'customer-search',
                path: '/customer/search',
                builder: (context, state) => const SearchProfessionalsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'customer-bookings',
                path: '/customer/bookings',
                builder: (context, state) => const CustomerBookingsScreen(),
                routes: [
                  GoRoute(
                    name: 'customer-booking-details',
                    path: ':id',
                    builder: (context, state) => BookingDetailsScreen(id: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    name: 'customer-review',
                    path: 'review/:id',
                    builder: (context, state) {
                      final booking = state.extra as BookingModel?;
                      return ReviewScreen(booking: booking!);
                    },
                  ),
                ]
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'customer-notifications',
                path: '/customer/notifications',
                builder: (context, state) => const CustomerNotificationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'customer-profile',
                path: '/customer/profile',
                builder: (context, state) => const CustomerProfileScreen(),
                routes: [
                  GoRoute(
                    name: 'customer-profile-edit',
                    path: 'edit',
                    builder: (context, state) => const EditCustomerProfileScreen(),
                  ),
                  GoRoute(
                    name: 'customer-saved-pros',
                    path: 'saved-pros',
                    builder: (context, state) => const SavedProfessionalsScreen(),
                  ),
                ]
              ),
            ],
          ),
        ],
      ),

      // PROFESSIONAL ROUTES
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ProfessionalShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'professional-dashboard',
                path: '/professional/dashboard',
                builder: (context, state) => const ProfessionalDashboard(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'professional-requests',
                path: '/professional/requests',
                builder: (context, state) => const ServiceRequestsScreen(),
                routes: [
                  GoRoute(
                    name: 'service-request-details',
                    path: 'details',
                    builder: (context, state) {
                      final booking = state.extra as BookingModel;
                      return ServiceRequestDetailsScreen(booking: booking);
                    },
                  ),
                ]
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'professional-jobs',
                path: '/professional/jobs',
                builder: (context, state) => const JobHistoryScreen(),
                routes: [
                  GoRoute(
                    name: 'professional-job-execution',
                    path: ':id',
                    builder: (context, state) {
                      final booking = state.extra as BookingModel?;
                      return JobExecutionScreen(booking: booking!);
                    },
                  ),
                ]
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'professional-notifications',
                path: '/professional/notifications',
                builder: (context, state) => const ProNotificationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'professional-profile',
                path: '/professional/profile',
                builder: (context, state) => const ProProfileViewScreen(),
                routes: [
                  GoRoute(
                    name: 'professional-settings',
                    path: 'settings',
                    builder: (context, state) => const ProfessionalSettingsScreen(),
                  ),
                  GoRoute(
                    name: 'edit-pro-profile',
                    path: 'edit',
                    builder: (context, state) => const EditProProfileScreen(),
                  ),
                  GoRoute(
                    name: 'manage-skills',
                    path: 'skills',
                    builder: (context, state) => const ManageSkillsRatesScreen(),
                  ),
                  GoRoute(
                    name: 'document-verification',
                    path: 'verification',
                    builder: (context, state) => const DocumentVerificationScreen(),
                  ),
                ]
              ),
            ],
          ),
        ],
      ),

      // ADMIN
      GoRoute(
        name: 'admin',
        path: '/admin',
        builder: (context, state) => const AdminScreen(),
      ),
    ],
  );

  static final _RouterNotifier _routerNotifier = _RouterNotifier();
  
  static void injectSessionProvider(SessionProvider session) {
    _routerNotifier.session = session;
  }
}

class _RouterNotifier extends ChangeNotifier {
  SessionProvider? _session;
  SessionProvider? get session => _session;
  set session(SessionProvider? val) {
    if (_session != val) {
      _session?.removeListener(notifyListeners);
      _session = val;
      _session?.addListener(notifyListeners);
      notifyListeners();
    }
  }
}
