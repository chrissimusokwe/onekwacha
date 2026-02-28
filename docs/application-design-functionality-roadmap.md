# OneKwacha Application Overview, Design, and Integration Roadmap

## Executive Summary
OneKwacha is a mobile wallet app built to help people send, receive, and manage money in a simple way from their phone. Today, the app already delivers the core experience a customer expects: account sign-in, wallet balance display, transfer journeys, invoice handling, transaction history, profile updates, and a marketplace section for digital products.

The current product is best described as a **strong functional prototype / early production foundation**. The internal wallet and record-keeping logic are in place, and users can move through complete app journeys. However, some external services that are critical for full commercial launch are not yet fully connected. These include:

- Automated KYC (identity verification) provider integration
- Live mobile money processing (cash-in and cash-out rails)
- Full card payment gateway processing
- Full merchant API completion for all marketplace partners

In plain terms: **the app experience is mostly built, but some real-world payment rails and compliance connections are still pending**. Those pending integrations form the next roadmap priority.

---

## What the Application Does Today (Current Functionality)

### 1) Account Access and User Onboarding
- Users can register and sign in using phone-number OTP flows.
- The app uses Firebase services for authentication and data storage.
- A splash and login flow leads users into the wallet experience.

### 2) Wallet Experience
- Users can see wallet balance on the home screen.
- The app calculates fees and total amounts for different transaction types.
- Balance updates and transaction records are written to the database.

### 3) Money Movement Journeys
- Top-up journey is available from the app interface.
- Transfer journey supports sending to:
  - OneKwacha wallet users
  - Mobile numbers
  - Bank account destination flow (with details entry screen)
- Confirmation and success/error screens are implemented.

### 4) QR Scan and Pay
- Users can scan a QR code and start a payment flow.
- Users can also generate “My QR” style payment data for receiving funds.

### 5) Invoicing (Lend/Borrow Style Flow)
- Users can create invoices between users.
- Invoice status lifecycle is implemented (for example active, paid, declined, deleted states).
- Invoice payment updates records in transaction and invoice ledgers.

### 6) Marketplace
- Marketplace UI is present and merchant list is loaded.
- Active merchants can be opened for product browsing.
- Lite Speed product fetching is connected through API calls.
- Product purchase journey exists in-app with transaction recording.

### 7) History and Profile
- Transaction history is grouped and presented with transaction details.
- Profile management screens exist.
- KYC submission journey exists (including ID image upload flow).

---

## Product Design in Plain English

OneKwacha is designed around a very simple idea:

1. **Show the user their money clearly**
2. **Make sending and paying easy**
3. **Keep records of every movement**
4. **Guide users with confirmation and status screens**

The design language uses clear action buttons (Top up, Scan & Pay, Transfer, Invoicing, Marketplace), then moves users through a “review and confirm” step before final processing.

### High-Level User Journey

```text
[Open App]
  |
  v
[Login / Register]
  |
  v
[Home Dashboard]
  |
  +--> [Top Up] ------+
  |                    |
  +--> [Transfer] -----|
  |                    |
  +--> [Scan & Pay] ---|--> [Confirmation]
  |                    |
  +--> [Invoicing] ----|
  |                    |
  +--> [Marketplace] --+
                 |
                 v
           [Process Transaction]
                 |
                 v
          [Success or Error Screen]
                 |
                 v
        [Updated Balance + History]
```

### Transaction Processing Flow (Current State)

```text
[User enters amount and destination]
               |
               v
[App calculates fee and total]
               |
               v
[User confirms transaction]
               |
               v
[Create transaction record in database]
               |
               v
[Update wallet balance]
               |
               v
[Show success screen]
               |
               v
[Transaction appears in history]
```

### KYC Flow (Current State)

```text
[User opens profile]
          |
          v
[Enter personal details]
          |
          v
[Upload ID images]
          |
          v
[Submit for review]
          |
          v
[KYC status updated in app data]
          |
          v
[Manual/operational review outside automated provider]
```

---

## What Is Not Yet Fully Implemented (External Integrations)

This section focuses on important real-world service links still pending.

## 1) Mobile Money Rail Integration (Pending)
**What exists now**
- Mobile money appears as a source/destination in app flows.
- User journey, confirmations, and ledger recording are implemented.

**What is still missing**
- Real debit/credit processing with mobile network operator APIs.
- Real transaction status callbacks (success, pending, failed, reversed).
- Settlement and reconciliation workflow with provider statements.

**Why it matters**
- Without this, mobile money flows may look complete in-app but do not represent end-to-end live payment rail completion.

## 2) Card Payment Gateway Integration (Pending)
**What exists now**
- Card entry and card flow screens are present.
- Validation and transaction flow structure are in place.

**What is still missing**
- Live tokenization, authorization, and capture through a certified payment gateway.
- Charge failure handling tied to gateway response codes.
- Refund/reversal and dispute handling integration.

**Why it matters**
- Card top-up and card-based payments need live processor connectivity for production use.

## 3) KYC Provider Integration (Pending)
**What exists now**
- Profile and KYC status fields exist.
- ID image upload flow exists.
- KYC status transitions are handled in the app data model.

**What is still missing**
- Automated identity verification via external KYC/AML service.
- Document authenticity checks, watchlist checks, risk scoring.
- Clear compliance audit trail from provider responses.

**Why it matters**
- Regulated financial services require stronger identity verification and compliance controls before full rollout.

## 4) Marketplace Provider Coverage (Partially Implemented)
**What exists now**
- Marketplace listing and merchant status model are implemented.
- Lite Speed product retrieval is connected.

**What is still missing**
- End-to-end live purchase/fulfillment completion for all marketplace partners.
- Full API integrations for “coming soon” merchants.
- Delivery confirmation and service-activation callback handling.

**Why it matters**
- Customers expect successful service delivery after payment, not only an internal transaction log.

## 5) Dynamic Pricing and Fee Configuration (Pending)
**What exists now**
- Fees are computed inside the app.

**What is still missing**
- Centralized fee/rules service so rates can change without app updates.

**Why it matters**
- Financial products need flexible pricing control and governance.

## 6) Identity Consistency Across App Flows (Needs Hardening)
**What exists now**
- Authentication exists with OTP flows.

**What is still missing**
- End-to-end use of authenticated live user identity across all transactional screens.

**Why it matters**
- Correct user mapping is essential for security, trust, and ledger accuracy.

---

## Recommended Roadmap (Business-Friendly)

## Phase 1: “Launch Readiness Core” (Highest Priority)
1. Complete mobile money API integration end-to-end.
2. Complete card gateway integration end-to-end.
3. Complete KYC provider integration with clear pass/fail and review states.
4. Ensure every transaction uses authenticated user identity consistently.

**Outcome:** Core payments become truly live and compliant.

## Phase 2: “Operational Control and Reliability”
1. Add reconciliation dashboards and settlement checks.
2. Add better error handling for provider downtime and retries.
3. Move fee configuration to managed backend settings.
4. Add stronger monitoring and alerting for failed transactions.

**Outcome:** Day-to-day operations become stable and supportable.

## Phase 3: “Marketplace Expansion”
1. Activate additional merchants currently marked as coming soon.
2. Add fulfillment confirmation and customer-proof of delivery.
3. Add partner SLA tracking (success rates, response times).

**Outcome:** Marketplace grows from partial availability to dependable revenue channel.

## Phase 4: “Scale and Trust”
1. Improve fraud/risk checks across transaction types.
2. Improve customer communication for pending/failed/reversed states.
3. Expand reporting for finance, compliance, and customer support teams.

**Outcome:** Product is ready for larger customer volumes and stronger regulatory confidence.

---

## Future-State Integration Vision

```text
[User starts transaction]
           |
           v
      [OneKwacha App]
       /    |    |    \
      /     |    |     \
     v      v    v      v
[Core Ledger] [Mobile Money API] [Card Gateway API] [KYC/AML API]
      |              |                 |                 |
      |              +--------+--------+                 |
      |                       |                          |
      |                       v                          |
      |             [Provider callback webhooks]         |
      |                       |                          |
      +-----------------------+--------------------------+
                              |
                              v
                  [Updated Ledger + Balance]
                              |
                              v
               [History + Notifications + Status]

Parallel service path:
[OneKwacha App] --> [Marketplace Partner APIs] --> [Provider callback webhooks]
```

---

## Simple Status Snapshot

- **Customer app journeys:** Mostly implemented
- **Internal ledger and records:** Implemented
- **Authentication base:** Implemented
- **KYC automation:** Not fully integrated
- **Mobile money rail processing:** Not fully integrated
- **Card processing rail:** Not fully integrated
- **Marketplace partner coverage:** Partial
- **Production readiness:** Needs external integration completion and operations hardening

---

## Suggested Next Deliverable for the Team
Create a short “Integration Readiness Checklist” that tracks each provider with:
- Owner
- API scope
- Test status
- Certification/compliance status
- Go-live date

This turns the roadmap into a practical execution plan that business and technical teams can follow together.
