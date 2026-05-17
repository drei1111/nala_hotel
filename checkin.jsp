<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.nala.dao.RoomDAO, com.nala.dao.TransactionDAO, com.nala.model.Room, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest Check-In | NALA Hotel</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        :root {
            --nala-gold: #f1c40f;
            --nala-navy: #0f172a;
            --glass-white: rgba(255, 255, 255, 0.9);
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            min-height: 100vh;
            margin: 0;
            display: flex;
        }

        .main-content {
            flex-grow: 1;
            padding: 40px;
            position: relative;
            overflow-y: auto;
        }

        .main-content::before {
            content: "";
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            opacity: 0.12;
            pointer-events: none;
            background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M10 0 L10 20 L30 40 L30 60 L10 80 L10 100 M90 0 L90 20 L70 40 L70 60 L90 80 L90 100' stroke='%23f1c40f' stroke-width='1.5' fill='none'/%3E%3C/svg%3E");
            background-size: 200px 200px;
            z-index: -1;
        }

        .form-card {
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            backdrop-filter: blur(10px);
            background: var(--glass-white);
            padding: 40px;
        }

        .section-title {
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--nala-navy);
            border-bottom: 2px solid var(--nala-gold);
            padding-bottom: 5px;
            margin-bottom: 20px;
            display: inline-block;
        }

        .price-display {
            font-size: 2rem;
            font-weight: 800;
            color: var(--nala-navy);
        }

        .price-final {
            font-size: 2rem;
            font-weight: 800;
            color: #059669;
        }

        .price-original {
            font-size: 1rem;
            font-weight: 700;
            color: #94a3b8;
            text-decoration: line-through;
        }

        .form-control, .form-select {
            border-radius: 12px;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
            font-size: 0.9rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--nala-gold);
            box-shadow: 0 0 0 0.25rem rgba(241, 196, 15, 0.1);
        }

        .form-control[readonly] {
            background-color: #f8fafc;
            color: #64748b;
        }

        .btn-primary {
            background-color: var(--nala-navy);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #1e293b;
            transform: translateY(-2px);
        }

        .fw-800 { font-weight: 800; }

        /* ── NAME FIELD VALIDATION STYLES ───────────────────────────── */
        .name-field-wrapper { position: relative; }

        .name-error-msg {
            display: none;
            align-items: center;
            gap: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            color: #dc2626;
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 8px;
            padding: 6px 10px;
            margin-top: 5px;
            animation: slideIn 0.2s ease;
        }
        .name-error-msg.visible { display: flex; }
        .name-error-msg i { font-size: 0.85rem; flex-shrink: 0; }

        .form-control.name-invalid {
            border-color: #dc2626 !important;
            background-color: #fff5f5;
            box-shadow: 0 0 0 0.2rem rgba(220, 38, 38, 0.1) !important;
        }
        .form-control.name-valid {
            border-color: #10b981 !important;
            box-shadow: 0 0 0 0.2rem rgba(16, 185, 129, 0.08) !important;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-4px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Shake animation on invalid submit attempt */
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%       { transform: translateX(-5px); }
            40%       { transform: translateX(5px); }
            60%       { transform: translateX(-4px); }
            80%       { transform: translateX(4px); }
        }
        .shake { animation: shake 0.4s ease; }

        /* Occupant count field */
        .occupant-row {
            background: #f8fafc;
            border: 1.5px solid #e2e8f0;
            border-radius: 14px;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .occupant-row .occ-icon {
            width: 40px; height: 40px;
            background: var(--nala-navy);
            color: var(--nala-gold);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }
        .occupant-row .occ-info { flex: 1; }
        .occupant-row .occ-info .occ-title {
            font-size: 0.78rem;
            font-weight: 800;
            color: var(--nala-navy);
            margin-bottom: 1px;
        }
        .occupant-row .occ-info .occ-hint {
            font-size: 0.7rem;
            color: #94a3b8;
        }
        .occupant-row input[type="number"] {
            width: 72px;
            text-align: center;
            font-weight: 800;
            font-size: 1.15rem;
            color: var(--nala-navy);
            border-radius: 10px;
            padding: 8px 6px;
        }

        /* Discount banner */
        .discount-banner {
            display: none;
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            border: 2px solid #10b981;
            border-radius: 16px;
            padding: 14px 18px;
            margin-top: 12px;
        }
        .discount-banner.show { display: block; }
        .discount-banner .badge-law {
            background: #10b981;
            color: white;
            font-size: 0.65rem;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Discount breakdown */
        .price-breakdown {
            display: none;
            border-top: 1px dashed #e2e8f0;
            margin-top: 12px;
            padding-top: 12px;
        }
        .price-breakdown.show { display: block; }
        .breakdown-line {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.82rem;
            padding: 3px 0;
        }
        .breakdown-line.total-line {
            border-top: 2px solid var(--nala-gold);
            margin-top: 8px;
            padding-top: 8px;
            font-weight: 800;
            font-size: 0.95rem;
        }

        /* Address dropdown styles */
        .address-dropdown-wrapper { position: relative; }
        .address-dropdown-list {
            position: absolute; top: 100%; left: 0; right: 0;
            background: white; border: 1px solid #e2e8f0; border-top: none;
            border-radius: 0 0 12px 12px; max-height: 200px; overflow-y: auto;
            z-index: 9999; display: none; box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }
        .address-dropdown-list.show { display: block; }
        .address-dropdown-list li {
            padding: 10px 15px; cursor: pointer; font-size: 0.875rem;
            border-bottom: 1px solid #f1f5f9; list-style: none;
        }
        .address-dropdown-list li:hover { background: #f8fafc; color: var(--nala-navy); font-weight: 600; }
        .address-dropdown-list li.loading, .address-dropdown-list li.empty { color: #94a3b8; font-style: italic; cursor: default; }
        .spinner-inline {
            width: 14px; height: 14px; border: 2px solid #e2e8f0;
            border-top-color: var(--nala-gold); border-radius: 50%;
            animation: spin 0.6s linear infinite; display: inline-block;
            vertical-align: middle; margin-right: 6px;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>

<jsp:include page="sidebar.jsp" />

<div class="d-flex flex-column flex-grow-1" style="min-width: 0;">
    <div class="main-content">
        <div class="container-fluid py-2">
            <div class="row justify-content-center">
                <div class="col-lg-12">
                    <div class="card form-card">

                        <%-- PAGE HEADER --%>
                        <div class="mb-5">
                            <h2 class="fw-800 mb-0">Reception Check-In</h2>
                            <p class="text-muted small mb-0">NALA Hotel El Nido | Front Desk Operations</p>
                        </div>

                        <% String error = (String) session.getAttribute("errorMessage"); %>
                        <% if (error != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-4" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <% session.removeAttribute("errorMessage"); %>
                        <% } %>

                        <form action="CheckInServlet" method="POST" id="checkInForm" novalidate>
                            <div class="row g-5">

                                <!-- ===== LEFT COLUMN: Personal Information ===== -->
                                <div class="col-md-6">
                                    <h6 class="section-title">Personal Information</h6>
                                    <div class="row g-3">

                                        <%-- First Name --%>
                                        <div class="col-md-4">
                                            <label class="small fw-bold text-muted">
                                                First Name <span class="text-danger">*</span>
                                            </label>
                                            <div class="name-field-wrapper">
                                                <input type="text"
                                                       name="firstName"
                                                       id="firstNameField"
                                                       class="form-control"
                                                       placeholder="Juan"
                                                       autocomplete="given-name"
                                                       required>
                                                <div class="name-error-msg" id="firstNameError">
                                                    <i class="bi bi-exclamation-circle-fill"></i>
                                                    Only letters are allowed — no numbers or symbols.
                                                </div>
                                            </div>
                                        </div>

                                        <%-- Middle Name --%>
                                        <div class="col-md-4">
                                            <label class="small fw-bold text-muted">Middle Name</label>
                                            <div class="name-field-wrapper">
                                                <input type="text"
                                                       name="middleName"
                                                       id="middleNameField"
                                                       class="form-control"
                                                       placeholder="Santos"
                                                       autocomplete="additional-name">
                                                <div class="name-error-msg" id="middleNameError">
                                                    <i class="bi bi-exclamation-circle-fill"></i>
                                                    Only letters are allowed — no numbers or symbols.
                                                </div>
                                            </div>
                                        </div>

                                        <%-- Last Name --%>
                                        <div class="col-md-4">
                                            <label class="small fw-bold text-muted">
                                                Last Name <span class="text-danger">*</span>
                                            </label>
                                            <div class="name-field-wrapper">
                                                <input type="text"
                                                       name="lastName"
                                                       id="lastNameField"
                                                       class="form-control"
                                                       placeholder="Dela Cruz"
                                                       autocomplete="family-name"
                                                       required>
                                                <div class="name-error-msg" id="lastNameError">
                                                    <i class="bi bi-exclamation-circle-fill"></i>
                                                    Only letters are allowed — no numbers or symbols.
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-6">
                                            <label class="small fw-bold text-muted">Nationality</label>
                                            <input type="text" name="nationality" class="form-control" value="Filipino">
                                        </div>

                                        <div class="col-6">
                                            <label class="small fw-bold text-muted">Birthdate <span class="text-danger">*</span></label>
                                            <input type="date" name="birthdate" id="birthdateField" class="form-control" onchange="computeAge()" required>
                                        </div>

                                        <%-- Age (auto-calculated) + Sex --%>
                                        <div class="col-4">
                                            <label class="small fw-bold text-muted">Age</label>
                                            <input type="number" name="age" id="ageField" class="form-control"
                                                   placeholder="—" readonly>
                                        </div>

                                        <div class="col-8">
                                            <label class="small fw-bold text-muted">Sex <span class="text-danger">*</span></label>
                                            <select name="sex" class="form-select" required>
                                                <option value="" disabled selected>-- Select --</option>
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                                <option value="Other">Other / Prefer not to say</option>
                                            </select>
                                        </div>

                                        <div class="col-12">
                                            <label class="small fw-bold text-muted">Contact Number <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-phone"></i></span>
                                                <input type="text" name="contact" class="form-control border-start-0"
                                                       placeholder="09xxxxxxxxx"
                                                       pattern="^(09|\+639)\d{9}$"
                                                       title="Enter a valid Philippine mobile number (e.g. 09XXXXXXXXX)"
                                                       required>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <label class="small fw-bold text-muted">Email Address <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope"></i></span>
                                                <input type="email" name="email" class="form-control border-start-0"
                                                       placeholder="name@example.com" required>
                                            </div>
                                        </div>

                                        <%-- Valid ID --%>
                                        <div class="col-6">
                                            <label class="small fw-bold text-muted">Valid ID Type <span class="text-danger">*</span></label>
                                            <select name="idType" id="idTypeSelect" class="form-select" onchange="onIdTypeChange()" required>
                                                <option value="" disabled selected>-- Select ID --</option>
                                                <option>PhilSys / National ID</option>
                                                <option>Passport</option>
                                                <option>Driver's License</option>
                                                <option>SSS ID</option>
                                                <option>GSIS ID / UMID</option>
                                                <option>PRC ID</option>
                                                <option>Voter's ID</option>
                                                <option>PhilHealth ID</option>
                                                <option>Postal ID</option>
                                                <option>TIN ID</option>
                                                <option>Senior Citizen ID</option>
                                                <option>PWD ID</option>
                                                <option>OFW ID / iDOLE Card</option>
                                                <option>Barangay ID</option>
                                            </select>
                                        </div>

                                        <div class="col-6">
                                            <label class="small fw-bold text-muted">ID Number <span class="text-danger">*</span></label>
                                            <input type="text" name="idNumber" class="form-control"
                                                   placeholder="ID number" required>
                                        </div>

                                        <%-- Discount Banner --%>
                                        <div class="col-12">
                                            <div class="discount-banner" id="discountBanner">
                                                <div class="d-flex align-items-start gap-2">
                                                    <i class="bi bi-shield-check-fill text-success mt-1" style="font-size: 1.2rem;"></i>
                                                    <div>
                                                        <div class="fw-800 text-success mb-1" id="discountTitle">Discount Applied</div>
                                                        <p class="mb-1 small text-success" id="discountDesc"></p>
                                                        <span class="badge-law" id="discountLaw"></span>
                                                        <p class="mb-0 mt-2 small text-muted">
                                                            <i class="bi bi-info-circle me-1"></i>
                                                            VAT exemption also applies — the 12% VAT will <strong>not</strong> be charged on the discounted amount.
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <%-- Room Occupants --%>
                                        <div class="col-12">
                                            <label class="small fw-bold text-muted d-block mb-2">
                                                Room Occupants <span class="text-danger">*</span>
                                            </label>
                                            <div class="occupant-row">
                                                <div class="occ-icon">
                                                    <i class="bi bi-people-fill"></i>
                                                </div>
                                                <div class="occ-info">
                                                    <div class="occ-title">How many persons will be staying?</div>
                                                    <div class="occ-hint">Count everyone sharing this room, including the primary guest</div>
                                                </div>
                                                <input type="number"
                                                       name="paxCount"
                                                       id="paxCount"
                                                       class="form-control"
                                                       min="1" max="10" value="1"
                                                       required>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <!-- ===== RIGHT COLUMN: Address & Room ===== -->
                                <div class="col-md-6">
                                    <h6 class="section-title">Address &amp; Room Details</h6>
                                    <div class="row g-3">

                                        <div class="col-12">
                                            <label class="small fw-bold text-muted">Street / House No.</label>
                                            <input type="text" name="street" id="streetField" class="form-control"
                                                   placeholder="e.g. 123 Rizal St." required>
                                        </div>

                                        <!-- Region -->
                                        <div class="col-12">
                                            <label class="small fw-bold text-muted">Region <span class="text-danger">*</span></label>
                                            <div class="address-dropdown-wrapper">
                                                <input type="text" id="regionInput" class="form-control"
                                                       placeholder="Search region..." autocomplete="off" required>
                                                <input type="hidden" name="region" id="regionHidden">
                                                <input type="hidden" id="regionCode">
                                                <ul class="address-dropdown-list" id="regionList"></ul>
                                            </div>
                                        </div>

                                        <!-- Province -->
                                        <div class="col-12">
                                            <label class="small fw-bold text-muted">Province <span class="text-danger">*</span></label>
                                            <div class="address-dropdown-wrapper">
                                                <input type="text" id="provinceInput" class="form-control"
                                                       placeholder="Select region first" autocomplete="off" 
                                                       disabled required>
                                                <input type="hidden" name="province" id="provinceHidden">
                                                <input type="hidden" id="provinceCode">
                                                <ul class="address-dropdown-list" id="provinceList"></ul>
                                            </div>
                                        </div>

                                        <!-- City / Municipality -->
                                        <div class="col-6">
                                            <label class="small fw-bold text-muted">City / Municipality <span class="text-danger">*</span></label>
                                            <div class="address-dropdown-wrapper">
                                                <input type="text" id="cityInput" class="form-control"
                                                       placeholder="Select province first" autocomplete="off"
                                                       disabled required>
                                                <input type="hidden" name="city" id="cityHidden">
                                                <input type="hidden" id="cityCode">
                                                <ul class="address-dropdown-list" id="cityList"></ul>
                                            </div>
                                        </div>

                                        <!-- Barangay -->
                                        <div class="col-6">
                                            <label class="small fw-bold text-muted">Barangay <span class="text-danger">*</span></label>
                                            <div class="address-dropdown-wrapper">
                                                <input type="text" id="barangayInput" class="form-control"
                                                       placeholder="Select city first" autocomplete="off"
                                                       disabled required>
                                                <input type="hidden" name="barangay" id="barangayHidden">
                                                <ul class="address-dropdown-list" id="barangayList"></ul>
                                            </div>
                                        </div>

                                        <!-- Room selection + Price breakdown -->
                                        <div class="col-12 mt-2">
                                            <div class="card bg-light border-0 p-4 rounded-4">
                                                <div class="mb-3">
                                                    <label class="small fw-bold text-muted text-uppercase mb-2 d-block">
                                                        1. Select Room Type
                                                    </label>
                                                    <select id="typeSelect" class="form-select border-0 shadow-sm"
                                                            onchange="filterRooms()" required>
                                                        <option value="" selected disabled>-- Select Type --</option>
                                                        <%
                                                            RoomDAO roomDao = new RoomDAO();
                                                            List<Room> allAvailable = roomDao.getAvailableRooms();
                                                            Set<String> uniqueTypes = new LinkedHashSet<>();
                                                            if (allAvailable != null && !allAvailable.isEmpty()) {
                                                                for (Room r : allAvailable) {
                                                                    if (r.getTypeName() != null) uniqueTypes.add(r.getTypeName());
                                                                }
                                                            }
                                                            for (String type : uniqueTypes) {
                                                        %>
                                                            <option value="<%= type %>"><%= type %></option>
                                                        <% } %>
                                                    </select>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="small fw-bold text-muted text-uppercase mb-2 d-block">
                                                        2. Choose Available Unit
                                                    </label>
                                                    <select name="roomNumber" id="roomSelect"
                                                            class="form-select border-0 shadow-sm"
                                                            onchange="updatePriceDisplay()" disabled required>
                                                        <option value="" selected disabled>-- Choose Type First --</option>
                                                        <%
                                                            if (allAvailable != null) {
                                                                for (Room r : allAvailable) {
                                                        %>
                                                            <option value="<%= r.getId() %>"
                                                                    class="room-option d-none"
                                                                    data-type="<%= r.getTypeName() %>"
                                                                    data-price="<%= r.getPrice() %>"
                                                                    data-num="<%= r.getRoomNum() %>">
                                                                Room <%= r.getRoomNum() %>
                                                            </option>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </select>
                                                </div>

                                                <!-- Price display -->
                                                <div class="mt-2 text-end">
                                                    <label class="small text-muted text-uppercase fw-800">Rate</label>

                                                    <div id="priceNoDiscount">
                                                        <div class="price-display">&#8369; <span id="displayPrice">0.00</span></div>
                                                    </div>

                                                    <div id="priceWithDiscount" style="display:none;">
                                                        <div class="price-original">&#8369; <span id="originalPriceLabel">0.00</span></div>
                                                        <div class="price-final">&#8369; <span id="finalPriceLabel">0.00</span></div>
                                                    </div>

                                                    <div class="price-breakdown text-start" id="priceBreakdown">
                                                        <div class="breakdown-line">
                                                            <span class="text-muted">Room Rate</span>
                                                            <span id="bdOriginal">₱0.00</span>
                                                        </div>
                                                        <div class="breakdown-line text-danger">
                                                            <span>Discount (20%)</span>
                                                            <span id="bdDiscount">-₱0.00</span>
                                                        </div>
                                                        <div class="breakdown-line text-muted" style="font-size:.75rem;">
                                                            <span>VAT (12%)</span>
                                                            <span class="text-success fw-bold">EXEMPT</span>
                                                        </div>
                                                        <div class="breakdown-line total-line text-success">
                                                            <span>Final Charge</span>
                                                            <span id="bdFinal">₱0.00</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                            </div>

                            <!-- Hidden fields -->
                            <input type="hidden" name="price"          id="hiddenPrice"        value="0.00">
                            <input type="hidden" name="originalPrice"  id="hiddenOriginal"     value="0.00">
                            <input type="hidden" name="discountType"   id="hiddenDiscountType" value="">
                            <input type="hidden" name="discountAmount" id="hiddenDiscountAmt"  value="0.00">
                            <input type="hidden" name="roomNameText"   id="hiddenRoomName"     value="">

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-primary btn-lg rounded-pill fw-800 py-3 shadow">
                                    <i class="bi bi-shield-check me-2"></i> COMPLETE CHECK-IN
                                </button>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="position-relative" style="z-index: 1;">
        <jsp:include page="footer.jsp" />
    </footer>
</div>

<script>
/* ===========================================================
   NAME FIELD VALIDATION
   Allowed: letters (A-Z, a-z), spaces, hyphens, apostrophes,
   and periods — for Filipino names like "Ma.", "De La Cruz",
   "O'Brien", etc. Numbers and all other symbols are blocked.
   =========================================================== */

// Regex: letters only + space, hyphen, apostrophe, period
const NAME_PATTERN = /^[A-Za-zÀ-ÖØ-öø-ÿ\s\.\-\']+$/;
// Characters that are NOT allowed (for real-time stripping detection)
const INVALID_CHARS = /[^A-Za-zÀ-ÖØ-öø-ÿ\s\.\-\']/;

/**
 * Validates a single name field.
 * Returns true if valid (or empty for optional fields).
 */
function validateNameField(inputEl, errorEl, isRequired) {
    const val = inputEl.value.trim();

    // Empty check
    if (val === '') {
        if (isRequired) {
            // Required but empty — let browser handle (don't show our custom error)
            inputEl.classList.remove('name-invalid', 'name-valid');
            errorEl.classList.remove('visible');
            return false;
        }
        // Optional and empty — clear styling
        inputEl.classList.remove('name-invalid', 'name-valid');
        errorEl.classList.remove('visible');
        return true;
    }

    if (INVALID_CHARS.test(val)) {
        // Invalid characters found
        inputEl.classList.add('name-invalid');
        inputEl.classList.remove('name-valid');
        errorEl.classList.add('visible');
        return false;
    } else {
        // Valid
        inputEl.classList.remove('name-invalid');
        inputEl.classList.add('name-valid');
        errorEl.classList.remove('visible');
        return true;
    }
}

/**
 * Attach real-time validation to a name input.
 * @param {string} inputId  - id of the input element
 * @param {string} errorId  - id of the error message div
 * @param {boolean} required
 */
function attachNameValidation(inputId, errorId, required) {
    const inputEl = document.getElementById(inputId);
    const errorEl = document.getElementById(errorId);

    // Real-time: validate on every keystroke
    inputEl.addEventListener('input', function () {
        validateNameField(inputEl, errorEl, required);
    });

    // Also validate on blur (when leaving the field)
    inputEl.addEventListener('blur', function () {
        if (inputEl.value.trim() !== '') {
            validateNameField(inputEl, errorEl, required);
        }
    });

    // Clear styling when user starts fresh
    inputEl.addEventListener('focus', function () {
        if (inputEl.value.trim() === '') {
            inputEl.classList.remove('name-invalid', 'name-valid');
            errorEl.classList.remove('visible');
        }
    });
}

// Attach to all three name fields
attachNameValidation('firstNameField',  'firstNameError',  true);
attachNameValidation('middleNameField', 'middleNameError', false);
attachNameValidation('lastNameField',   'lastNameError',   true);

/**
 * Validate all name fields and return true only if all pass.
 * Also triggers shake animation on invalid fields.
 */
function validateAllNameFields() {
    const fields = [
        { input: 'firstNameField',  error: 'firstNameError',  required: true  },
        { input: 'middleNameField', error: 'middleNameError', required: false },
        { input: 'lastNameField',   error: 'lastNameError',   required: true  }
    ];

    let allValid = true;
    fields.forEach(f => {
        const inputEl = document.getElementById(f.input);
        const errorEl = document.getElementById(f.error);
        const valid   = validateNameField(inputEl, errorEl, f.required);
        if (!valid && inputEl.value.trim() !== '') {
            // Shake the invalid field
            inputEl.classList.add('shake');
            setTimeout(() => inputEl.classList.remove('shake'), 400);
            allValid = false;
        }
    });
    return allValid;
}

/* ===========================================================
   FORM SUBMIT — block if name fields have invalid characters
   =========================================================== */
document.getElementById('checkInForm').addEventListener('submit', function (e) {
    const namesValid = validateAllNameFields();
    if (!namesValid) {
        e.preventDefault();
        // Scroll to first invalid name field
        const firstInvalid = document.querySelector('.name-invalid');
        if (firstInvalid) {
            firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
            firstInvalid.focus();
        }
        return false;
    }
});

/* ===========================================================
   DISCOUNT RULES
   =========================================================== */
const DISCOUNT_IDS = {
    'Senior Citizen ID': {
        rate:  0.20,
        title: 'Senior Citizen Discount — 20% Off',
        desc:  'Applies to room rates, dining, and resort fees as mandated by Republic Act 9994.',
        law:   'RA 9994 — Expanded Senior Citizens Act'
    },
    'PWD ID': {
        rate:  0.20,
        title: 'PWD Discount — 20% Off',
        desc:  'Applies to room rates, dining, and resort fees as mandated by Republic Act 10754.',
        law:   'RA 10754 — PWD Discount Act'
    }
};

/* ===========================================================
   1. Birthdate — restrict to today or earlier + auto-compute age
   =========================================================== */
(function () {
    document.getElementById('birthdateField').setAttribute('max', new Date().toISOString().split('T')[0]);
})();

function computeAge() {
    const birthdateVal = document.getElementById('birthdateField').value;
    const ageField     = document.getElementById('ageField');
    if (!birthdateVal) { ageField.value = ''; return; }
    const birth = new Date(birthdateVal);
    const today = new Date();
    let age = today.getFullYear() - birth.getFullYear();
    const m = today.getMonth() - birth.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) age--;
    ageField.value = age >= 0 ? age : '';
}

/* ===========================================================
   2. ID Type change — show/hide discount banner & recalculate
   =========================================================== */
function onIdTypeChange() {
    updatePriceDisplay();
    const idType = document.getElementById('idTypeSelect').value;
    const rule   = DISCOUNT_IDS[idType];
    const banner = document.getElementById('discountBanner');

    if (rule) {
        document.getElementById('discountTitle').textContent = rule.title;
        document.getElementById('discountDesc').textContent  = rule.desc;
        document.getElementById('discountLaw').textContent   = rule.law;
        banner.classList.add('show');
    } else {
        banner.classList.remove('show');
    }
}

/* ===========================================================
   3. Room filter
   =========================================================== */
function filterRooms() {
    const typeSelect   = document.getElementById('typeSelect');
    const roomSelect   = document.getElementById('roomSelect');
    const selectedType = typeSelect.value;
    const options      = roomSelect.querySelectorAll('.room-option');

    roomSelect.value    = '';
    roomSelect.disabled = false;
    resetPriceDisplay();

    let count = 0;
    options.forEach(opt => {
        const match = opt.getAttribute('data-type').trim() === selectedType.trim();
        opt.classList.toggle('d-none', !match);
        opt.style.display = match ? 'block' : 'none';
        if (match) count++;
    });

    if (count === 0) {
        roomSelect.disabled = true;
        roomSelect.options[0].textContent = '-- No available rooms --';
    } else {
        roomSelect.options[0].textContent = '-- Select Room --';
    }
}

/* ===========================================================
   4. Price display + discount calculation
   =========================================================== */
function resetPriceDisplay() {
    document.getElementById('displayPrice').textContent        = '0.00';
    document.getElementById('originalPriceLabel').textContent  = '0.00';
    document.getElementById('finalPriceLabel').textContent     = '0.00';
    document.getElementById('hiddenPrice').value               = '0.00';
    document.getElementById('hiddenOriginal').value            = '0.00';
    document.getElementById('hiddenDiscountAmt').value         = '0.00';
    document.getElementById('hiddenDiscountType').value        = '';
    document.getElementById('priceBreakdown').classList.remove('show');
    document.getElementById('priceNoDiscount').style.display   = 'block';
    document.getElementById('priceWithDiscount').style.display = 'none';
}

function fmt(n) {
    return parseFloat(n).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function updatePriceDisplay() {
    const roomSelect     = document.getElementById('roomSelect');
    const selectedOption = roomSelect.options[roomSelect.selectedIndex];
    if (!selectedOption || !selectedOption.value) return;

    const rawPrice = parseFloat(selectedOption.getAttribute('data-price')) || 0;
    const roomNum  = selectedOption.getAttribute('data-num');
    const idType   = document.getElementById('idTypeSelect').value;
    const rule     = DISCOUNT_IDS[idType];

    document.getElementById('hiddenRoomName').value = roomNum;
    document.getElementById('hiddenOriginal').value = rawPrice.toFixed(2);

    if (rule) {
        const discountAmt = rawPrice * rule.rate;
        const finalPrice  = rawPrice - discountAmt;

        document.getElementById('originalPriceLabel').textContent = fmt(rawPrice);
        document.getElementById('finalPriceLabel').textContent    = fmt(finalPrice);
        document.getElementById('bdOriginal').textContent         = '₱' + fmt(rawPrice);
        document.getElementById('bdDiscount').textContent         = '-₱' + fmt(discountAmt);
        document.getElementById('bdFinal').textContent            = '₱' + fmt(finalPrice);

        document.getElementById('hiddenPrice').value        = finalPrice.toFixed(2);
        document.getElementById('hiddenDiscountAmt').value  = discountAmt.toFixed(2);
        document.getElementById('hiddenDiscountType').value = idType;

        document.getElementById('priceNoDiscount').style.display   = 'none';
        document.getElementById('priceWithDiscount').style.display  = 'block';
        document.getElementById('priceBreakdown').classList.add('show');
    } else {
        document.getElementById('displayPrice').textContent        = fmt(rawPrice);
        document.getElementById('hiddenPrice').value               = rawPrice.toFixed(2);
        document.getElementById('hiddenDiscountAmt').value         = '0.00';
        document.getElementById('hiddenDiscountType').value        = '';
        document.getElementById('priceNoDiscount').style.display   = 'block';
        document.getElementById('priceWithDiscount').style.display = 'none';
        document.getElementById('priceBreakdown').classList.remove('show');
    }
}

/* ===========================================================
   5. Philippine Address — PSGC API (Region → Province → City → Barangay)
   =========================================================== */
const PSGC_BASE  = 'https://psgc.gitlab.io/api';
let allRegions   = [], allProvinces = [], allCities = [], allBarangays = [];

function showList(el) { el.classList.add('show'); }
function hideList(el) { el.classList.remove('show'); }

function renderList(listEl, items, onSelect) {
    listEl.innerHTML = '';
    if (!items.length) {
        listEl.innerHTML = '<li class="empty">No results found.</li>';
        showList(listEl); return;
    }
    items.forEach(item => {
        const li = document.createElement('li');
        li.textContent = item.name;
        li.addEventListener('mousedown', e => { e.preventDefault(); onSelect(item); hideList(listEl); });
        listEl.appendChild(li);
    });
    showList(listEl);
}

function setLoading(el) {
    el.innerHTML = '<li class="loading"><span class="spinner-inline"></span>Loading...</li>';
    showList(el);
}

/* ════════════════════════════════════════════════════════════
   REGION
   ════════════════════════════════════════════════════════════ */
const regionInput  = document.getElementById('regionInput');
const regionHidden = document.getElementById('regionHidden');
const regionCode   = document.getElementById('regionCode');
const regionList   = document.getElementById('regionList');

async function loadRegions() {
    if (allRegions.length) return;
    setLoading(regionList);
    try {
        const res  = await fetch(PSGC_BASE + '/regions.json');
        allRegions = (await res.json()).sort((a,b) => a.name.localeCompare(b.name));
    } catch { 
        regionList.innerHTML = '<li class="empty">Failed to load regions. Please try again.</li>'; 
        showList(regionList); 
    }
}

regionInput.addEventListener('focus', async () => { 
    await loadRegions(); 
    filterRegions(); 
});
regionInput.addEventListener('input', filterRegions);
regionInput.addEventListener('blur',  () => { 
    setTimeout(() => hideList(regionList), 150); 
    if (!regionHidden.value) regionHidden.value = regionInput.value; 
});

function filterRegions() {
    const q = regionInput.value.toLowerCase().trim();
    const filtered = q ? allRegions.filter(r => r.name.toLowerCase().includes(q)) : allRegions;
    renderList(regionList, filtered.slice(0, 50), item => {
        regionInput.value  = item.name;
        regionHidden.value = item.name;
        regionCode.value   = item.code;
        
        // Reset all dependent fields
        provinceInput.value = ''; provinceHidden.value = ''; provinceCode.value = '';
        provinceInput.disabled = false; provinceInput.placeholder = 'Search province...';
        
        cityInput.value = ''; cityHidden.value = ''; cityCode.value = '';
        cityInput.disabled = true; cityInput.placeholder = 'Select province first';
        
        barangayInput.value = ''; barangayHidden.value = '';
        barangayInput.disabled = true; barangayInput.placeholder = 'Select city first';
        
        allProvinces = []; allCities = []; allBarangays = [];
    });
}

/* ════════════════════════════════════════════════════════════
   PROVINCE
   ════════════════════════════════════════════════════════════ */
const provinceInput  = document.getElementById('provinceInput');
const provinceHidden = document.getElementById('provinceHidden');
const provinceCode   = document.getElementById('provinceCode');
const provinceList   = document.getElementById('provinceList');

async function loadProvinces() {
    if (allProvinces.length) return;
    setLoading(provinceList);
    try {
        const rCode = regionCode.value;
        if (!rCode) {
            provinceList.innerHTML = '<li class="empty">Select a region first.</li>';
            showList(provinceList);
            return;
        }
        const res  = await fetch(PSGC_BASE + '/regions/' + rCode + '/provinces.json');
        allProvinces = (await res.json()).sort((a,b) => a.name.localeCompare(b.name));
    } catch { 
        provinceList.innerHTML = '<li class="empty">Failed to load provinces. Please try again.</li>'; 
        showList(provinceList); 
    }
}

provinceInput.addEventListener('focus', async () => { 
    await loadProvinces(); 
    filterProvinces(); 
});
provinceInput.addEventListener('input', filterProvinces);
provinceInput.addEventListener('blur',  () => { 
    setTimeout(() => hideList(provinceList), 150); 
    if (!provinceHidden.value) provinceHidden.value = provinceInput.value; 
});

function filterProvinces() {
    const q = provinceInput.value.toLowerCase().trim();
    const filtered = q ? allProvinces.filter(p => p.name.toLowerCase().includes(q)) : allProvinces;
    renderList(provinceList, filtered.slice(0, 50), item => {
        provinceInput.value  = item.name;
        provinceHidden.value = item.name;
        provinceCode.value   = item.code;
        
        // Reset dependent fields
        cityInput.value = ''; cityHidden.value = ''; cityCode.value = '';
        cityInput.disabled = false; cityInput.placeholder = 'Search city / municipality...';
        
        barangayInput.value = ''; barangayHidden.value = '';
        barangayInput.disabled = true; barangayInput.placeholder = 'Select city first';
        
        allCities = []; allBarangays = [];
    });
}

/* ════════════════════════════════════════════════════════════
   CITY / MUNICIPALITY
   ════════════════════════════════════════════════════════════ */
const cityInput   = document.getElementById('cityInput');
const cityHidden  = document.getElementById('cityHidden');
const cityCode    = document.getElementById('cityCode');
const cityList    = document.getElementById('cityList');

async function loadCities() {
    if (allCities.length) return;
    setLoading(cityList);
    try {
        const pCode = provinceCode.value;
        if (!pCode) {
            cityList.innerHTML = '<li class="empty">Select a province first.</li>';
            showList(cityList);
            return;
        }
        const res = await fetch(PSGC_BASE + '/provinces/' + pCode + '/cities-municipalities.json');
        allCities = (await res.json()).sort((a,b) => a.name.localeCompare(b.name));
    } catch { 
        cityList.innerHTML = '<li class="empty">Failed to load cities. Please try again.</li>'; 
        showList(cityList); 
    }
}

cityInput.addEventListener('focus', async () => { 
    await loadCities(); 
    filterCities(); 
});
cityInput.addEventListener('input', filterCities);
cityInput.addEventListener('blur',  () => { 
    setTimeout(() => hideList(cityList), 150); 
    if (!cityHidden.value) cityHidden.value = cityInput.value; 
});

function filterCities() {
    const q = cityInput.value.toLowerCase().trim();
    const filtered = q ? allCities.filter(c => c.name.toLowerCase().includes(q)) : allCities;
    renderList(cityList, filtered.slice(0, 50), item => {
        cityInput.value  = item.name;
        cityHidden.value = item.name;
        cityCode.value   = item.code;
        
        // Reset dependent field
        barangayInput.value = ''; barangayHidden.value = '';
        barangayInput.disabled = false; barangayInput.placeholder = 'Search barangay...';
        
        allBarangays = [];
    });
}

/* ════════════════════════════════════════════════════════════
   BARANGAY
   ════════════════════════════════════════════════════════════ */
const barangayInput  = document.getElementById('barangayInput');
const barangayHidden = document.getElementById('barangayHidden');
const barangayList   = document.getElementById('barangayList');

async function loadBarangays() {
    if (allBarangays.length) return;
    setLoading(barangayList);
    try {
        const cCode = cityCode.value;
        if (!cCode) {
            barangayList.innerHTML = '<li class="empty">Select a city first.</li>';
            showList(barangayList);
            return;
        }
        const res = await fetch(PSGC_BASE + '/cities-municipalities/' + cCode + '/barangays.json');
        allBarangays = (await res.json()).sort((a,b) => a.name.localeCompare(b.name));
    } catch { 
        barangayList.innerHTML = '<li class="empty">Failed to load barangays. Please try again.</li>'; 
        showList(barangayList); 
    }
}

barangayInput.addEventListener('focus', async () => { 
    await loadBarangays(); 
    filterBarangays(); 
});
barangayInput.addEventListener('input', filterBarangays);
barangayInput.addEventListener('blur',  () => { 
    setTimeout(() => hideList(barangayList), 150); 
    if (!barangayHidden.value) barangayHidden.value = barangayInput.value; 
});

function filterBarangays() {
    const q = barangayInput.value.toLowerCase().trim();
    const filtered = q ? allBarangays.filter(b => b.name.toLowerCase().includes(q)) : allBarangays;
    renderList(barangayList, filtered.slice(0, 50), item => {
        barangayInput.value  = item.name;
        barangayHidden.value = item.name;
    });
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>