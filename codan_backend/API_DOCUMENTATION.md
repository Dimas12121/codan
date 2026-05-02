# codan API Documentation

## Base URL
`http://your-domain.com/api`

## Authentication
All protected routes require a Bearer Token in the `Authorization` header:
`Authorization: Bearer {access_token}`

### 1. Register
- **URL**: `/register`
- **Method**: `POST`
- **Body**:
  ```json
  {
      "name": "John Doe",
      "email": "john@example.com",
      "password": "password",
      "password_confirmation": "password",
      "role": "buyer", // options: buyer, seller
      "phone": "08123456789",
      "location": "Jakarta" // required if role is seller
  }
  ```

### 2. Login
- **URL**: `/login`
- **Method**: `POST`
- **Body**:
  ```json
  {
      "email": "john@example.com",
      "password": "password"
  }
  ```

### 3. Logout (Protected)
- **URL**: `/logout`
- **Method**: `POST`

---

## produks

### 1. Get All produks
- **URL**: `/produks`
- **Method**: `GET`
- **Query Params**:
  - `category`: (slug) Filter by category slug
  - `search`: (string) Search by title
  - `page`: (int) Pagination

### 2. Get produk Detail
- **URL**: `/produks/{identifier}`
- **Method**: `GET`
- **Note**: `{identifier}` can be the `id` or the `slug`.

### 3. Create produk (Protected)
- **URL**: `/produks`
- **Method**: `POST`
- **Body (Multipart Form Data)**:
  - `title`: string
  - `category_id`: integer
  - `price`: numeric
  - `description`: string
  - `location`: string
  - `condition`: string (baru/bekas/refurbished)
  - `images[]`: file (array of images)

### 4. Update Status (Protected)
- **URL**: `/produks/{id}/status`
- **Method**: `PATCH`
- **Body**:
  ```json
  {
      "status": "sold" // options: active, sold, draft
  }
  ```

---

## Categories

### 1. Get All Categories
- **URL**: `/categories`
- **Method**: `GET`

---

## Notifications (Protected)

### 1. Get All Notifications
- **URL**: `/notifications`
- **Method**: `GET`

---

## Messages (Protected)

### 1. Get Conversation
- **URL**: `/messages/{produkId}/{partnerId}`
- **Method**: `GET`

### 2. Send Message
- **URL**: `/messages`
- **Method**: `POST`
- **Body**:
  ```json
  {
      "produk_id": 1,
      "receiver_id": 2,
      "message": "Hello, is this still available?"
  }
  ```

---

## Wishlist (Protected)

### 1. Toggle Wishlist
- **URL**: `/wishlists/toggle`
- **Method**: `POST`
- **Body**:
  ```json
  {
      "produk_id": 1
  }
  ```
