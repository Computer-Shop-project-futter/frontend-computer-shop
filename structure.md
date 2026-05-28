# NexCore — Flutter Frontend Folder Tree
> Full structure for G14-TECH Computer Shop mobile app
> Framework: Flutter 3.x | State: Riverpod | Navigation: go_router | HTTP: Dio

---

## Stats
| Type | Count |
|---|---|
| Total dart files | 110 |
| Pages (screens) | 37 |
| Widgets (components) | 26 |
| Providers (state) | 19 |
| Models / Repositories | 28 |

---

## Full Tree

```
computer_shop_app/
├── pubspec.yaml
│     Declares all packages: go_router, flutter_riverpod, dio,
│     cached_network_image, fl_chart, google_maps_flutter,
│     web_socket_channel, flutter_secure_storage, shimmer,
│     carousel_slider. Also registers fonts (Syne, DM Sans)
│     and asset folders.
│
├── analysis_options.yaml
│     Lint rules. Enables strict mode — forces null safety,
│     unused variable warnings, and consistent coding style.
│
└── lib/
    ├── main.dart
    │     Entry point. Calls runApp(). Creates ProviderScope
    │     (Riverpod root) and passes in AppWidget.
    │
    ├── app.dart
    │     Defines MaterialApp.router(). Wires up AppTheme and
    │     GoRouter. Applies warm monochrome theme (#FAF9F7,
    │     #1A1917) and Syne+DM Sans fonts globally.
    │
    ├── core/
    │   ├── constants/
    │   │   ├── app_colors.dart
    │   │   │     All Color constants: kBackground (#FAF9F7),
    │   │   │     kSurface (#F2F0ED), kDark (#1A1917),
    │   │   │     kSecondaryText (#6B6760), kBorder (#D6D3CE).
    │   │   │     Import this everywhere — never hardcode hex.
    │   │   │
    │   │   ├── app_text_styles.dart
    │   │   │     TextStyle constants: headingLarge (Syne 30px bold),
    │   │   │     headingMedium (Syne 22px), bodyMedium (DM Sans 14px),
    │   │   │     labelSmall (DM Sans 11px uppercase tracked).
    │   │   │
    │   │   └── app_strings.dart
    │   │         All user-facing strings. Example: kAppName = "NexCore",
    │   │         kAddToCart = "Add to Cart". Useful for future i18n.
    │   │
    │   ├── theme/
    │   │   └── app_theme.dart
    │   │         ThemeData for light and dark mode. Sets colorScheme,
    │   │         textTheme, buttonTheme, inputDecorationTheme, cardTheme.
    │   │
    │   ├── router/
    │   │   └── app_router.dart
    │   │         GoRouter config. All 37 named routes. Redirect guard:
    │   │         unauthenticated users → /login. Separate route trees
    │   │         for admin vs customer roles.
    │   │
    │   ├── network/
    │   │   ├── api_client.dart
    │   │   │     Dio instance with base URL + timeout + two interceptors:
    │   │   │     (1) AuthInterceptor attaches JWT Bearer token from secure
    │   │   │     storage to every request header.
    │   │   │     (2) ErrorInterceptor catches 401s and triggers logout.
    │   │   │
    │   │   └── api_endpoints.dart
    │   │         All API URL path constants. Example: kProducts = "/products",
    │   │         kOrders = "/orders", kLogin = "/auth/login".
    │   │         Change backend URL in one place only.
    │   │
    │   ├── storage/
    │   │   └── local_storage.dart
    │   │         Wrapper around flutter_secure_storage. Methods:
    │   │         saveToken(String), getToken(), deleteToken(),
    │   │         saveUser(UserModel), getUser().
    │   │
    │   └── utils/
    │       ├── formatters.dart
    │       │     Helper functions: formatCurrency(double) → "$1,499",
    │       │     formatDate(DateTime) → "23 May 2024",
    │       │     truncateText(String, int).
    │       │
    │       └── validators.dart
    │             Form validators: validateEmail(), validatePhone(),
    │             validatePassword() (min 8 chars), validateRequired().
    │
    ├── shared/
    │   ├── widgets/
    │   │   ├── product_card.dart
    │   │   │     [WIDGET] Reusable card used on Home, Product Listing,
    │   │   │     Wishlist. Props: ProductModel, onTap, onAddToCart,
    │   │   │     showDealPrice. Renders thumbnail, brand, name, price.
    │   │   │
    │   │   ├── bottom_nav_bar.dart
    │   │   │     [WIDGET] Fixed 64px bottom nav on all customer screens.
    │   │   │     4 tabs: Home, Products, Builder, Account. Uses go_router.
    │   │   │
    │   │   ├── app_bar_widget.dart
    │   │   │     [WIDGET] Custom AppBar. Props: title, showBack, actions.
    │   │   │     Warm #FAF9F7 background with 1px bottom border.
    │   │   │
    │   │   ├── spec_row.dart
    │   │   │     [WIDGET] Single specs table row: label left (gray 13px),
    │   │   │     value right (bold 13px). Used in specs_tab.dart.
    │   │   │
    │   │   ├── benchmark_bar.dart
    │   │   │     [WIDGET] Full-width benchmark bar. Props: label, score,
    │   │   │     barPercent. Dark filled bar 8px height rounded.
    │   │   │
    │   │   ├── price_tag.dart
    │   │   │     [WIDGET] If deal: deal price bold + original line-through.
    │   │   │     If no deal: base price only. Used in ProductCard + Detail.
    │   │   │
    │   │   ├── rating_stars.dart
    │   │   │     [WIDGET] 1–5 star icons filled proportionally.
    │   │   │     Props: rating, reviewCount.
    │   │   │
    │   │   ├── loading_shimmer.dart
    │   │   │     [WIDGET] Shimmer placeholder while data loads.
    │   │   │     Mirrors the shape of the content it replaces.
    │   │   │
    │   │   ├── empty_state.dart
    │   │   │     [WIDGET] Empty state with icon + title + optional button.
    │   │   │     Used on Cart, Wishlist, Order History when empty.
    │   │   │
    │   │   ├── error_widget.dart
    │   │   │     [WIDGET] Error state with retry button. Props: message,
    │   │   │     onRetry. Used by all AsyncValue.error handlers.
    │   │   │
    │   │   └── status_badge.dart
    │   │         [WIDGET] Pill badge for order and ticket status.
    │   │         paid/ready=dark fill, pending=outlined, cancelled=gray.
    │   │
    │   └── models/
    │       ├── pagination_meta.dart
    │       │     [MODEL] int total, int page, int limit, bool hasMore.
    │       │     Used by product listing and order history responses.
    │       │
    │       └── api_response.dart
    │             [MODEL] Generic ApiResponse<T> with T data and
    │             PaginationMeta? meta. Handles { data, meta } shape
    │             from NestJS transform interceptor.
    │
    └── features/
        │
        ├── auth/
        │   ├── data/
        │   │   └── auth_repository.dart
        │   │         [MODEL] login(email, password) → UserModel + token,
        │   │         register(name, email, phone, password) → UserModel.
        │   │
        │   ├── domain/
        │   │   └── user_model.dart
        │   │         [MODEL] userId, roleId, fullName, email, phone,
        │   │         avatarUrl, createdAt, isActive. fromJson() factory.
        │   │         Maps to users table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── auth_provider.dart
        │       │         [PROVIDER] StateNotifierProvider. AuthState:
        │       │         loading/authenticated/unauthenticated/error.
        │       │         Methods: login(), register(), logout().
        │       │         Saves JWT to local_storage on success.
        │       │
        │       ├── pages/
        │       │   ├── splash_page.dart                          ← BUILT ✓
        │       │   │     [PAGE] G14-TECH splash screen. Logo animation,
        │       │   │     pulsing ring, arc spinner, cycling loading
        │       │   │     messages. Navigates to /home or /login after
        │       │   │     sequence completes.
        │       │   │
        │       │   ├── login_page.dart
        │       │   │     [PAGE] Email + password fields, show/hide toggle,
        │       │   │     Forgot Password link, Login button, Google Sign-in.
        │       │   │
        │       │   └── register_page.dart
        │       │         [PAGE] Full name, email, phone, password,
        │       │         confirm password. Auto-login after register.
        │       │
        │       └── widgets/
        │           └── auth_form_field.dart
        │                 [WIDGET] Styled TextFormField: 48px height,
        │                 warm border, focus = 2px dark border.
        │
        ├── home/
        │   ├── data/
        │   │   └── home_repository.dart
        │   │         [MODEL] getFeaturedProducts(), getActivePromotions(),
        │   │         getDeals(). Three separate API calls.
        │   │
        │   ├── domain/
        │   │   └── promotion_model.dart
        │   │         [MODEL] promotionId, title, description, promoType,
        │   │         startDate, endDate, bannerUrl, isActive.
        │   │         Maps to promotions table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── home_provider.dart
        │       │         [PROVIDER] AsyncNotifierProvider. Fetches featured
        │       │         products, deals, and promotions in parallel on init.
        │       │
        │       ├── pages/
        │       │   └── home_page.dart
        │       │         [PAGE] HeroBanner → FeaturedRigsSection →
        │       │         HotDealsSection → PromotionBanner →
        │       │         PCBuilderCTA → CommunityShowcase → Footer.
        │       │
        │       └── widgets/
        │           ├── hero_banner.dart
        │           │     [WIDGET] Full-height dark hero. Product image top
        │           │     55%, headline "Build Your Legend.", two buttons:
        │           │     Shop Now + Build a PC.
        │           │
        │           ├── featured_rigs_section.dart
        │           │     [WIDGET] Horizontal snap-scroll row of ProductCards
        │           │     (260px wide). Section label "FEATURED RIGS".
        │           │
        │           ├── deals_section.dart
        │           │     [WIDGET] List of deal rows: 72×72px thumbnail +
        │           │     name + original price struck + deal price.
        │           │
        │           └── promotion_banner.dart
        │                 [WIDGET] Full-width dark card: PROMOTION label,
        │                 Syne bold title, date range, View Deals button.
        │
        ├── products/
        │   ├── data/
        │   │   └── products_repository.dart
        │   │         [MODEL] getProducts(filters) → paginated list,
        │   │         getProductById(id) → full ProductModel with
        │   │         specs + benchmarks + reviews.
        │   │
        │   ├── domain/
        │   │   ├── product_model.dart
        │   │   │     [MODEL] productId, categoryId, brandId, name,
        │   │   │     shortDescription, basePrice, dealPrice, thumbnailUrl,
        │   │   │     isFeatured, isDeal, isActive. Maps to products table.
        │   │   │
        │   │   ├── product_spec_model.dart
        │   │   │     [MODEL] specId, productId, specKey (CPU/GPU/RAM...),
        │   │   │     specValue, unit. Used in specs_tab.dart.
        │   │   │
        │   │   ├── product_benchmark_model.dart
        │   │   │     [MODEL] benchmarkId, productId, metricKey,
        │   │   │     metricValue, barPercent. Used in benchmarks_tab.dart.
        │   │   │
        │   │   └── product_config_option_model.dart
        │   │         [MODEL] optionId, productId, optionGroup (RAM/Storage),
        │   │         optionLabel, priceDelta, isDefault.
        │   │         Used in config_options_selector.dart.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   ├── products_provider.dart
        │       │   │     [PROVIDER] AsyncNotifierProvider for product list.
        │       │   │     Holds page, filter state, product list.
        │       │   │     Methods: loadMore(), applyFilter(), resetFilters().
        │       │   │
        │       │   └── product_detail_provider.dart
        │       │         [PROVIDER] AsyncNotifierProvider for single product.
        │       │         Fetches specs, benchmarks, config options, reviews.
        │       │         Manages selected config state (RAM/Storage choice).
        │       │
        │       ├── pages/
        │       │   ├── product_listing_page.dart
        │       │   │     [PAGE] Search bar + filter bottom sheet + sort bar
        │       │   │     + product list. Load more on scroll-to-bottom.
        │       │   │
        │       │   └── product_detail_page.dart
        │       │         [PAGE] Media gallery + product info + config selectors
        │       │         + Specs | Benchmarks | Reviews tabs.
        │       │         Add to Cart + Wishlist + Compare buttons.
        │       │
        │       └── widgets/
        │           ├── filter_bottom_sheet.dart
        │           │     [WIDGET] Category checkboxes, Brand checkboxes,
        │           │     Price range dual-slider, Featured/OnSale/InStock
        │           │     toggles. Reset + Show Results buttons.
        │           │
        │           ├── specs_tab.dart
        │           │     [WIDGET] Alternating-row table of spec key → value
        │           │     pairs from product_spec_model list.
        │           │
        │           ├── benchmarks_tab.dart
        │           │     [WIDGET] List of BenchmarkBar widgets from
        │           │     product_benchmark_model list.
        │           │
        │           ├── reviews_tab.dart
        │           │     [WIDGET] Average rating + breakdown bars + list of
        │           │     ReviewCard widgets.
        │           │
        │           ├── config_options_selector.dart
        │           │     [WIDGET] Pill buttons per option group (RAM, Storage).
        │           │     Selected = dark fill. Tapping updates provider and
        │           │     recalculates price.
        │           │
        │           └── media_gallery.dart
        │                 [WIDGET] Full-width image/video carousel using
        │                 carousel_slider. Dot indicators. Supports both
        │                 image and video from product_media table.
        │
        ├── compare/
        │   ├── data/
        │   │   └── compare_repository.dart
        │   │         [MODEL] createCompareList(), addProduct(listId, productId),
        │   │         getCompareList(listId) with full spec data.
        │   │
        │   ├── domain/
        │   │   └── compare_list_model.dart
        │   │         [MODEL] compareListId, userId, title, list of ProductModel.
        │   │         Maps to compare_lists + compare_items tables.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── compare_provider.dart
        │       │         [PROVIDER] Holds up to 3 products to compare.
        │       │         Methods: addProduct(), removeProduct(), clearAll().
        │       │         Derives best-value per spec row.
        │       │
        │       ├── pages/
        │       │   └── compare_page.dart
        │       │         [PAGE] Horizontal scroll synced header + spec rows.
        │       │         Best value per row = dark pill badge.
        │       │         Per-column Add to Cart at bottom.
        │       │
        │       └── widgets/
        │           └── compare_spec_row.dart
        │                 [WIDGET] Fixed label column + value columns per product.
        │                 Highlights best value cell.
        │
        ├── pc_builder/
        │   ├── data/
        │   │   └── builder_repository.dart
        │   │         [MODEL] getComponents(type) → list, saveBuild(BuildModel),
        │   │         getBuild(id), updateBuild(), deleteBuild().
        │   │
        │   ├── domain/
        │   │   ├── component_model.dart
        │   │   │     [MODEL] componentId, componentType (CPU/MB/RAM/GPU/
        │   │   │     STORAGE/PSU/CASE), brandId, name, price, thumbnailUrl.
        │   │   │     Maps to components table.
        │   │   │
        │   │   └── build_model.dart
        │   │         [MODEL] buildId, userId, name, note, totalPriceCached,
        │   │         list of BuildItemModel. Maps to builds + build_items.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── builder_provider.dart
        │       │         [PROVIDER] Holds 7 component slots (each nullable) +
        │       │         total price. Methods: selectComponent(type, component),
        │       │         clearSlot(type), saveBuild(), addToCart().
        │       │
        │       ├── pages/
        │       │   └── pc_builder_page.dart
        │       │         [PAGE] Screen A: 7 component slots + total price bar +
        │       │         Add to Cart. Tapping slot opens ComponentPickerSheet.
        │       │
        │       └── widgets/
        │           ├── component_slot_card.dart
        │           │     [WIDGET] 64px slot row: type icon + label + selected
        │           │     component name/price OR "Tap to choose". Dark left
        │           │     border accent when filled.
        │           │
        │           ├── component_picker_sheet.dart
        │           │     [WIDGET] Screen B bottom sheet: search + brand pills +
        │           │     component list with Select button per row.
        │           │
        │           └── build_summary_bar.dart
        │                 [WIDGET] Fixed bottom panel: "Total: $X,XXX" (Syne bold)
        │                 + full-width Add to Cart button. Updates live.
        │
        ├── cart/
        │   ├── data/
        │   │   └── cart_repository.dart
        │   │         [MODEL] getCart(), addItem(dto), updateItemQty(id, qty),
        │   │         removeItem(id), clearCart().
        │   │
        │   ├── domain/
        │   │   ├── cart_model.dart
        │   │   │     [MODEL] cartId, userId, list of CartItemModel, subtotal,
        │   │   │     discountTotal, total. Maps to carts table.
        │   │   │
        │   │   └── cart_item_model.dart
        │   │         [MODEL] cartItemId, itemType (product|build),
        │   │         productId or buildId, selectedConfigJson, quantity,
        │   │         unitPrice. Maps to cart_items table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── cart_provider.dart
        │       │         [PROVIDER] AsyncNotifierProvider. Fetches cart on init.
        │       │         Methods: addItem(), removeItem(), updateQty(),
        │       │         applyCoupon(code), checkout(). Coupon state stored here.
        │       │
        │       ├── pages/
        │       │   ├── cart_page.dart
        │       │   │     [PAGE] Item list + qty controls + swipe-to-delete.
        │       │   │     Coupon field. Order summary. Checkout button.
        │       │   │
        │       │   └── checkout_page.dart
        │       │         [PAGE] 3-step: Contact → Mock Payment → Confirmation.
        │       │         Progress indicator at top. POST /orders on Step 2.
        │       │
        │       └── widgets/
        │           ├── cart_item_tile.dart
        │           │     [WIDGET] 72px thumbnail + name + config info +
        │           │     qty controls (- count +) + delete icon.
        │           │
        │           └── coupon_field.dart
        │                 [WIDGET] Input + Apply button. Shows applied coupon
        │                 as dismissible dark pill with discount amount.
        │
        ├── orders/
        │   ├── data/
        │   │   └── orders_repository.dart
        │   │         [MODEL] getOrders(status?) → paginated list,
        │   │         getOrderById(id) → full OrderModel with items.
        │   │
        │   ├── domain/
        │   │   ├── order_model.dart
        │   │   │     [MODEL] orderId, orderNumber, createdAt, subtotal,
        │   │   │     discountTotal, total, couponId, status.
        │   │   │     Maps to orders table.
        │   │   │
        │   │   └── order_item_model.dart
        │   │         [MODEL] orderItemId, orderId, itemType, productId or
        │   │         buildId, selectedConfigJson, quantity, unitPrice.
        │   │         Maps to order_items table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── orders_provider.dart
        │       │         [PROVIDER] AsyncNotifierProvider for order list with
        │       │         status filter. Separate notifier for order detail.
        │       │
        │       ├── pages/
        │       │   ├── order_history_page.dart
        │       │   │     [PAGE] Status filter pills. Expandable inline cards.
        │       │   │     "View Full Order" → order_detail_page.
        │       │   │
        │       │   ├── order_detail_page.dart
        │       │   │     [PAGE] Status banner, item rows, pricing summary card,
        │       │   │     customer info card. Read-only.
        │       │   │
        │       │   └── order_confirmation_page.dart
        │       │         [PAGE] Success screen: large checkmark circle, order
        │       │         number, summary card, View Order + Continue Shopping.
        │       │
        │       └── widgets/
        │           └── order_status_badge.dart
        │                 [WIDGET] Status pill for order status values:
        │                 mock_paid, pending, cancelled. Color-coded.
        │
        ├── favorites/
        │   ├── data/
        │   │   └── favorites_repository.dart
        │   │         [MODEL] getFavorites() → list,
        │   │         addFavorite(itemType, id), removeFavorite(favoriteId).
        │   │
        │   ├── domain/
        │   │   └── favorite_model.dart
        │   │         [MODEL] favoriteId, userId, itemType (product|build),
        │   │         productId or buildId, createdAt. Maps to favorites table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── favorites_provider.dart
        │       │         [PROVIDER] Methods: toggle(itemType, id) adds or removes.
        │       │         Favorite IDs cached locally — heart icon stays filled
        │       │         without re-fetching.
        │       │
        │       └── pages/
        │           └── favorites_page.dart
        │                 [PAGE] Products tab + Saved Builds tab. Product cards
        │                 with Add to Cart + unfavorite. Build cards with
        │                 View + Add to Cart + Delete.
        │
        ├── service/
        │   ├── data/
        │   │   └── service_repository.dart
        │   │         [MODEL] submitTicket(dto) → TicketModel,
        │   │         getMyTickets() → list, getTicketById(id) with timeline.
        │   │
        │   ├── domain/
        │   │   ├── ticket_model.dart
        │   │   │     [MODEL] ticketId, ticketNumber, userId, branchId,
        │   │   │     issueType, issueDescription, deviceType, deviceModel,
        │   │   │     dropoffDate, status, createdAt.
        │   │   │     Maps to service_tickets table.
        │   │   │
        │   │   └── timeline_event_model.dart
        │   │         [MODEL] eventId, ticketId, status, note, eventTime,
        │   │         staffUserId. Maps to ticket_timeline_events table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── service_provider.dart
        │       │         [PROVIDER] AsyncNotifierProvider for customer ticket
        │       │         list + detail. Methods: submitTicket(dto), refresh().
        │       │
        │       ├── pages/
        │       │   ├── service_tickets_page.dart
        │       │   │     [PAGE] Ticket list. Each card: ticket number, device,
        │       │   │     branch, drop-off date, status badge. Taps expand
        │       │   │     inline timeline.
        │       │   │
        │       │   └── service_request_page.dart
        │       │         [PAGE] Submit ticket form: issue type pills + device
        │       │         type pills + description textarea + branch dropdown
        │       │         + date picker + read-only user info. Sticky Submit.
        │       │
        │       └── widgets/
        │           └── ticket_status_stepper.dart
        │                 [WIDGET] Vertical timeline: line + filled/hollow/
        │                 pulsing circles + status label + note + staff + time.
        │
        ├── chat/
        │   ├── data/
        │   │   └── chat_repository.dart
        │   │         [MODEL] HTTP: getThreads(), getMessages(threadId).
        │   │         WebSocket: connect(threadId), sendMessage(text),
        │   │         disconnect(). Uses web_socket_channel package.
        │   │
        │   ├── domain/
        │   │   ├── thread_model.dart
        │   │   │     [MODEL] threadId, userId, createdAt, status (open|closed).
        │   │   │     Maps to chat_threads table.
        │   │   │
        │   │   └── message_model.dart
        │   │         [MODEL] messageId, threadId, senderType
        │   │         (customer|staff|bot), senderUserId, messageText,
        │   │         createdAt. Maps to chat_messages table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── chat_provider.dart
        │       │         [PROVIDER] StreamProvider fed by WebSocket. Appends
        │       │         incoming messages to local list. Methods: sendMessage(),
        │       │         connect(), disconnect(). Manages online/offline status.
        │       │
        │       ├── pages/
        │       │   └── chat_page.dart
        │       │         [PAGE] Customer messages right (dark bubble), staff/bot
        │       │         left (light bubble). Quick-reply chips. Input bar fixed
        │       │         at bottom.
        │       │
        │       └── widgets/
        │           ├── message_bubble.dart
        │           │     [WIDGET] Props: MessageModel, isOwn. Applies correct
        │           │     border-radius per side. Bot messages show bot icon.
        │           │
        │           └── chat_input_bar.dart
        │                 [WIDGET] Rounded input + dark circular send button.
        │                 Calls chat_provider.sendMessage() on send.
        │
        ├── store_locator/
        │   ├── data/
        │   │   └── branches_repository.dart
        │   │         [MODEL] getBranches() → list of BranchModel.
        │   │         Public endpoint — no auth required.
        │   │
        │   ├── domain/
        │   │   └── branch_model.dart
        │   │         [MODEL] branchId, name, address, lat, lng, phone,
        │   │         isServiceCenter, hoursText. Maps to branches table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── branches_provider.dart
        │       │         [PROVIDER] Fetches all branches once and caches.
        │       │         Selected branch state for map bottom sheet.
        │       │
        │       ├── pages/
        │       │   └── store_locator_page.dart
        │       │         [PAGE] List/Map tab toggle. List: search + branch cards.
        │       │         Map: GoogleMap widget + bottom sheet with active branch
        │       │         info + Get Directions button.
        │       │
        │       └── widgets/
        │           └── branch_info_card.dart
        │                 [WIDGET] Name (Syne bold), address, phone, hours,
        │                 Service Center badge, Get Directions link.
        │
        ├── profile/
        │   ├── data/
        │   │   └── profile_repository.dart
        │   │         [MODEL] getMe() → UserModel, updateProfile(dto),
        │   │         updatePassword(currentPw, newPw).
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── profile_provider.dart
        │       │         [PROVIDER] Holds current user data. Methods:
        │       │         updateProfile(), updatePassword(). Refreshes
        │       │         auth_provider after save.
        │       │
        │       └── pages/
        │           └── profile_page.dart
        │                 [PAGE] 3 tabs: Profile (edit info) + Security
        │                 (change password) + Preferences (notification toggles).
        │                 Dark header with avatar initials. Save in AppBar.
        │
        ├── showcase/
        │   ├── data/
        │   │   └── showcase_repository.dart
        │   │         [MODEL] getShowcase(tag?) → list of ShowcaseMediaModel.
        │   │         Public endpoint — no auth required.
        │   │
        │   ├── domain/
        │   │   └── showcase_model.dart
        │   │         [MODEL] showcaseId, title, description, mediaType
        │   │         (image|video), url, tags, createdAt, isPublished.
        │   │         Maps to showcase_media table.
        │   │
        │   └── presentation/
        │       ├── providers/
        │       │   └── showcase_provider.dart
        │       │         [PROVIDER] Holds showcase list + active tag filter.
        │       │         Methods: filterByTag(tag).
        │       │
        │       └── pages/
        │           └── showcase_page.dart
        │                 [PAGE] 2-column square grid. Tag filter pills.
        │                 Tap cell → full-screen modal with image/video
        │                 + title + description + tags.
        │
        ├── staff/
        │   ├── dashboard/
        │   │   └── staff_dashboard_page.dart
        │   │         [PAGE] Hamburger → slide-in drawer (avatar + branch name
        │   │         + nav links). Stat 2×2 grid. Ticket queue preview.
        │   │         Chat inbox preview.
        │   │
        │   ├── tickets/
        │   │   ├── staff_ticket_queue_page.dart
        │   │   │     [PAGE] Ticket queue for staff's branch only. Status
        │   │   │     filter pills + search. FAB → Create Ticket.
        │   │   │
        │   │   ├── staff_ticket_detail_page.dart
        │   │   │     [PAGE] Customer info card + issue + vertical timeline.
        │   │   │     "Add Event" expands form: status dropdown + note textarea.
        │   │   │
        │   │   └── staff_create_ticket_page.dart
        │   │         [PAGE] Create ticket for walk-in customer. Branch
        │   │         pre-filled. Success shows ticket number inline.
        │   │
        │   ├── orders/
        │   │   └── staff_orders_page.dart
        │   │         [PAGE] Order list. Tap → bottom sheet with items +
        │   │         customer phone (tap to call) + status update dropdown.
        │   │
        │   ├── inventory/
        │   │   └── staff_inventory_page.dart
        │   │         [PAGE] Inventory for staff's branch only. Summary chips.
        │   │         Product rows with +-qty controls. Low stock accent border.
        │   │         Batch save.
        │   │
        │   └── chat/
        │       └── staff_chat_inbox_page.dart
        │             [PAGE] Thread list with unread badges. Open/Closed filter.
        │             Tap → full-screen chat. "Close Thread" in AppBar.
        │
        └── admin/
            ├── dashboard/
            │   └── admin_dashboard_page.dart
            │         [PAGE] Drawer nav with all sections. KPI 2×2 grid
            │         (Revenue, Orders Today, Open Tickets, Users).
            │         Top Products list. Recent Orders. Low Stock alerts.
            │
            ├── products/
            │   ├── admin_products_page.dart
            │   │     [PAGE] Product list with search + filter chips.
            │   │     Each row: thumbnail + name + badges + edit + delete.
            │   │
            │   └── admin_product_form_page.dart
            │         [PAGE] Full-screen add/edit form. All product fields +
            │         dynamic spec rows + benchmark rows + config option rows.
            │         "Add Spec" button adds a new row.
            │
            ├── components/
            │   └── admin_components_page.dart
            │         [PAGE] Component list filtered by type. Add/Edit
            │         full-screen form with dynamic spec rows.
            │
            ├── brands_categories/
            │   └── admin_brands_categories_page.dart
            │         [PAGE] Two-tab: Brands (logo + name) and Categories
            │         (icon + name + slug). Inline add/edit form per tab.
            │
            ├── orders/
            │   └── admin_orders_page.dart
            │         [PAGE] All orders across all users. KPI strip.
            │         Filter bottom sheet. Tap → detail bottom sheet
            │         with status update dropdown.
            │
            ├── promotions/
            │   └── admin_promotions_page.dart
            │         [PAGE] Promotion cards with banner, status filter,
            │         active toggle. Add/Edit: title, type, dates, linked
            │         products picker.
            │
            ├── coupons/
            │   └── admin_coupons_page.dart
            │         [PAGE] Coupon list: code monospace bold + discount type
            │         badge + dates + active toggle. Add/Edit with code
            │         Generate button + Percent|Fixed toggle.
            │
            ├── inventory/
            │   └── admin_inventory_page.dart
            │         [PAGE] Stock qty per product per branch. Summary chips
            │         (Total/In Stock/Low/Out). Batch save button.
            │
            ├── tickets/
            │   └── admin_tickets_page.dart
            │         [PAGE] All service tickets across ALL branches (no branch
            │         restriction unlike staff). Status filter + search.
            │
            ├── chat/
            │   └── admin_chat_inbox_page.dart
            │         [PAGE] All chat threads. Unread count badges.
            │         Open/Closed filter. Same chat UI as staff.
            │
            ├── reviews/
            │   └── admin_reviews_page.dart
            │         [PAGE] Review list: product + reviewer + use_case badge
            │         + stars + title + body preview + visible toggle.
            │         Long-press for bulk hide/show.
            │
            ├── showcase/
            │   └── admin_showcase_page.dart
            │         [PAGE] Grid/List toggle. Each cell: thumbnail + type badge
            │         + title + published toggle + edit/delete. URL + preview
            │         in add/edit form.
            │
            ├── users/
            │   └── admin_users_page.dart
            │         [PAGE] User list: avatar initials + name + email + role
            │         badge + active toggle. Edit bottom sheet: role dropdown
            │         + active toggle + delete with confirmation.
            │
            └── branches/
                └── admin_branches_page.dart
                      [PAGE] Branch cards: name + address + phone + hours +
                      Service Center badge. Edit full-screen: name, address,
                      lat/lng, phone, hours, service center toggle + map preview.
```

---

## Key Packages Reference

| Package | Purpose | Used in |
|---|---|---|
| `go_router` | Navigation + route guards | `app_router.dart` |
| `flutter_riverpod` | State management | All `*_provider.dart` files |
| `dio` | HTTP client + interceptors | `api_client.dart` |
| `flutter_secure_storage` | JWT token storage | `local_storage.dart` |
| `cached_network_image` | Image caching | `product_card.dart`, `media_gallery.dart` |
| `shimmer` | Loading placeholders | `loading_shimmer.dart` |
| `carousel_slider` | Product image gallery | `media_gallery.dart` |
| `fl_chart` | Benchmark charts | `benchmarks_tab.dart` |
| `google_maps_flutter` | Store locator map | `store_locator_page.dart` |
| `web_socket_channel` | Real-time chat | `chat_repository.dart` |
| `intl` | Date + currency formatting | `formatters.dart` |

---

## File Naming Convention

| Type | Pattern | Example |
|---|---|---|
| Page | `*_page.dart` | `product_detail_page.dart` |
| Widget | `*_widget.dart` or descriptive | `benchmark_bar.dart` |
| Provider | `*_provider.dart` | `cart_provider.dart` |
| Model | `*_model.dart` | `order_model.dart` |
| Repository | `*_repository.dart` | `products_repository.dart` |
| Constants | `app_*.dart` | `app_colors.dart` |

---

## Build Order (Phase by Phase)

### Phase 1 — Foundation
- `main.dart`, `app.dart`, `app_theme.dart`, `app_router.dart`
- `api_client.dart`, `api_endpoints.dart`, `local_storage.dart`
- All files in `core/constants/` and `core/utils/`

### Phase 2 — Auth
- `user_model.dart`, `auth_repository.dart`, `auth_provider.dart`
- `splash_page.dart` ← already built ✓
- `login_page.dart`, `register_page.dart`, `auth_form_field.dart`

### Phase 3 — Core Catalog
- All files in `features/products/`
- All files in `features/home/`
- Shared widgets: `product_card.dart`, `loading_shimmer.dart`, `empty_state.dart`

### Phase 4 — Shopping Flow
- All files in `features/cart/`
- All files in `features/orders/`
- All files in `features/pc_builder/`
- All files in `features/favorites/`

### Phase 5 — Account Features
- `features/profile/`, `features/service/`, `features/chat/`
- `features/compare/`, `features/store_locator/`, `features/showcase/`

### Phase 6 — Staff + Admin
- All files in `features/staff/`
- All files in `features/admin/`

---

*Total: ~110 Dart files across 37 screens, 26 widgets, 19 providers*