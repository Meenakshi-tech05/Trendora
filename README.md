Trendora - AI Powered Fashion Ecommerce App 👗🛍️

Trendora is a modern fashion ecommerce mobile application built using Flutter and Firebase. The app allows users to browse fashion products, receive AI-based recommendations, manage their wishlist and cart, place orders, and track deliveries in real time.

 Features

👤 User Authentication

* User Registration
* User Login
* Secure Firebase Authentication
* Persistent User Sessions

 🏠 Home Screen

* Featured Fashion Products
* AI Recommendation Access
* Product Search
* Category Browsing

🛒 Shopping Experience

* Product Listing
* Product Details Page
* Product Description
* Size Selection for Dresses and Shoes
* Add to Cart
* Quantity Management
* Remove from Cart

 ❤️ Wishlist

* Add Products to Wishlist
* Persistent Wishlist Storage

 📦 Order Management

* Checkout Process
* Multiple Payment Methods
* Order Placement
* Order History
* Order Tracking

 🚚 Order Tracking Status

* Order Placed
* Packed
* Shipped
* Out for Delivery
* Delivered

 👤 Profile Management

* View Profile
* Edit Profile
* Manage Addresses
* Privacy & Security Section
* Logout

 🤖 AI Recommendations

* Personalized Fashion Suggestions
* Recommendation Based Product Discovery



 🛠️ Tech Stack

Frontend

* Flutter
* Dart

Backend

* Firebase Authentication
* Cloud Firestore

 State Management

* Flutter Riverpod

## Database

* Firebase Firestore (NoSQL)

---

## 📂 Project Structure


lib/
│
├── core/
│   └── widgets/
│
├── data/
│   ├── models/
│   └── services/
│
├── presentation/
│   ├── screens/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── product/
│   │   ├── cart/
│   │   ├── wishlist/
│   │   ├── checkout/
│   │   ├── order/
│   │   └── profile/
│
├── providers/
│
└── main.dart


 Firebase Collections

Users

json
{
  "name": "Reenu",
  "email": "reenu@gmail.com"
}

### Products

json
{
  "id": "dress1",
  "title": "Pink Party Dress",
  "category": "Dresses",
  "description": "Elegant party wear dress",
  "image": "image_url",
  "price": 1999,
  "sizes": ["S","M","L","XL"]
}

### Cart

json
{
  "userId": "uid",
  "id": "dress1",
  "title": "Pink Party Dress",
  "image": "image_url",
  "price": 1999,
  "quantity": 1,
  "size": "M"
}


### Wishlist

json
{
  "id": "dress1",
  "title": "Pink Party Dress",
  "image": "image_url",
  "price": 1999
}

### Orders

json
{
  "userId": "uid",
  "totalAmount": 1999,
  "address": "Trivandrum",
  "paymentMethod": "UPI",
  "orderStatus": "Order Placed",
  "items": [
    {
    "id": "dress1",
      "title": "Pink Party Dress",
      "image": "image_url",
      "price": 1999,
      "quantity": 1,
      "size": "M"
    }
  ]
}


## 🚀 Installation

### Clone Repository

bash
git clone https://github.com/yourusername/trendora.git

### Navigate to Project

bash
cd trendora

### Install Dependencies

```bash
flutter pub get
```

### Run Application

bash
flutter run


---

## 🧪 Testing

### User Flow

1. Register/Login
2. Browse Products
3. Open Product Details
4. Select Size
5. Add Product to Cart
6. Manage Quantity
7. Checkout
8. Place Order
9. View Order History
10. Track Order Status

---

## 📸 Screens

* Splash Screen
* Onboarding Screen
* Login Screen
* Signup Screen
* Home Screen
* Product Listing Screen
* Product Details Screen
* Cart Screen
* Wishlist Screen
* Checkout Screen
* Order History Screen
* Order Tracking Screen
* Profile Screen
* Edit Profile Screen
* Manage Address Screen

---

## 🎯 Future Enhancements

* Forgot Password
* Razorpay Integration
* AI Outfit Generator
* Product Reviews & Ratings
* Coupons & Discounts
* Push Notifications
* Dark Mode
* Multi-language Support

