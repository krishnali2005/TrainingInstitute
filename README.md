# Training Institute Management Portal

An enterprise-grade Java Web application designed for academic administration, tracking student profiles, compliance monitoring, course management, and fee accounting using a clean Architecture without heavy frameworks.

---

## Features

* **Analytical Dashboard (Chart.js):** Generates real-time visual statistics of institute metrics using SQL row aggregation. (Exclusively visible to Admins).
* **Dynamic PDF Export:** Implements custom print media query overrides allowing administrators to generate clean executive summary reports directly to PDF with one click. (Exclusively visible to Admins).
* **Real-Time AJAX Search Engine:** Utilizes asynchronous JavaScript fetch() operations routed to a dedicated JSON Servlet back-end to filter the student index live as you type without reloading the page.
* **Binary Profile Asset Uploads:** Features a secure Multipart form processing architecture via Servlet 3.0 @MultipartConfig to handle binary profile avatar uploads directly to application directories.
* **Background Notification Engine:** Dispatches automated greeting registration alerts running on independent parallel threads, ensuring zero UI latency during data persistence.
* **Secure Session Expiry Listener:** Enforces automatic user session invalidation after 15 minutes of inactivity using a global Java @WebListener component.
* **Attendance Compliance Roster:** Computes average student attendance rates dynamically and appends an immediate warning signal (LOW COMPLIANCE) for accounts dipping below the 75% threshold.
* **Printable Billing Invoices:** Generates dynamic, neatly formatted, computer-generated transaction fee receipts with native print styling hooks.
* **Contextual Session-to-ID Mapping:** Seamlessly resolves text usernames to database numerical IDs to ensure students view only their personal payment histories securely.

---

## Technologies Used

* Java EE (Servlets, JSPs, JSTL)
* Apache Tomcat 9.0
* MySQL Database
* HTML5 / CSS3 / JavaScript (Vanilla AJAX Engine)
* Chart.js (Data Visualization Framework)
* Jakarta Mail API (Async Notification Engine)
* Apache Maven (Dependency & Build Management)

---

## Architecture

```text
    Web Browser Client (JSP / AJAX / Print Queries)
                         ↕
         Apache Tomcat Web Server (Servlet Engine)
                         ↕
      DAO Layer (Session Mapping & Threaded Actions)
                         ↕
               MySQL Relational Database

```

Whenever data changes or requests occur:

1. **Security & Session Guard:** The WebListener monitors user states, while JSPs filter visible navigation layouts contextually by role extraction (ADMIN, FACULTY, STUDENT).
2. **Contextual Mapping:** If a student requests financial data, the session text username is instantly resolved to a database numeric ID to isolate records securely.
3. **AJAX Filtering:** Live text input field events use asynchronous loops to query backend endpoints, fetching updated rows dynamically without viewport reloads.
4. **Print Media Logic:** Print triggers ignore interface navigation wrappers dynamically, targeting structural reporting views natively for localized PDF exports.

---

## Project Structure

```text
TrainingInstitute/
│
├── src/main/java/com/institute/
│   ├── controller/               # Back-End Servlet Dispatchers & Security Listeners
│   │   ├── AttendanceServlet.java
│   │   ├── CourseServlet.java
│   │   ├── FeeServlet.java
│   │   ├── SearchServlet.java    
│   │   ├── StudentServlet.java   
│   │   └── PortalSessionListener.java
│   │
│   ├── dao/                      # Database Access Object Layer & Notification Engines
│   │   ├── AttendanceDAO.java    
│   │   ├── CourseDAO.java
│   │   ├── DBConnection.java
│   │   ├── FeeDAO.java
│   │   ├── StudentDAO.java
│   │   └── EmailService.java     
│   │
│   └── model/                    # Plain Old Java Objects (POJO Structural Models)
│       ├── Attendance.java
│       ├── Course.java
│       ├── Fee.java
│       └── Student.java
│
├── src/main/resources/
│   └── database.properties       # Core Environment Variable Configurations
│
├── src/main/webapp/              # Web Resources Root Directory
│   ├── uploads/                  # Local Target Folder for Binary Avatar Attachments
│   ├── WEB-INF/
│   │   └── lib/                  # Runtime Library Storage (jakarta.mail-1.6.7.jar)
│   ├── dashboard.jsp             # Chart Analytics Hub & PDF Print Engine
│   ├── manage-students.jsp       # Multipart Entry Form & Live AJAX Input Lookups
│   ├── manage-courses.jsp        # Course Curriculum and Faculty Assignment Management
│   ├── manage-attendance.jsp     # Class Roster Sheet with 75% Compliance Flags
│   ├── manage-fees.jsp           # Session-mapped Fee Ledger
│   └── index.jsp                 # Gateway Portal Authentication Entry View
└── pom.xml                       # Maven Dependency Management Manifest

```

---

## Environment Variables

Create the database configuration properties file at `src/main/resources/database.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/institute_db?useSSL=false&allowPublicKeyRetrieval=true
db.username=root
db.password=root123
db.driver=com.mysql.cj.jdbc.Driver

```

---

## Database Setup

### Create Database Schema

```sql
CREATE DATABASE IF NOT EXISTS institute_db;
USE institute_db;

```

### Create Core Infrastructure Tables

```sql
-- 1. Users Security Credentials Table
CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL
);

-- 2. Master Course Curriculum Table
CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    duration VARCHAR(50) NOT NULL,
    fees DOUBLE NOT NULL,
    faculty_assigned VARCHAR(100) DEFAULT 'Not Assigned'
);

-- 3. Student Body Directory
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    course VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    username VARCHAR(50),
    photo_path VARCHAR(255) DEFAULT 'uploads/default-avatar.png',
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
);

-- 4. Attendance Log Ledger
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    status VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- 5. Institutional Fees Ledger
CREATE TABLE IF NOT EXISTS fees (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    amount_paid DOUBLE NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

```

### Seed Default User Credentials and Course Matrix

```sql
INSERT IGNORE INTO users VALUES ('admin', 'admin123', 'ADMIN');
INSERT IGNORE INTO users VALUES ('faculty', 'faculty123', 'FACULTY');

INSERT IGNORE INTO courses (course_name, duration, fees, faculty_assigned) VALUES 
('Java Full Stack', '6 Months', 45000.00, 'Not Assigned'),
('Python Data Science', '4 Months', 38000.00, 'Not Assigned'),
('Web Development', '3 Months', 25000.00, 'Not Assigned');

```

---

## Installation & Run

### Build Application

Run the following commands sequentially inside the project's root folder where `pom.xml` is located:

```bash
# 1. Compile source Java classes and resources via Maven
mvn clean compile

# 2. Sync compiled target binaries into the webapp deployment directory
cp -r target/classes/com src/main/webapp/WEB-INF/classes/
cp target/classes/database.properties src/main/webapp/WEB-INF/classes/

```

### Start Deployments

1. Ensure your core dependency `jakarta.mail-1.6.7.jar` is placed inside `src/main/webapp/WEB-INF/lib/`.
2. Move your project directory layout into your server environment's `webapps/` folder or link it directly in your IDE.
3. Open your terminal control block to start Tomcat:

```bash
cd /path/to/tomcat/bin
./catalina.sh run

```

4. Launch your browser engine and navigate to:
`http://localhost:8080/TrainingInstitute/index.jsp`

---

## Testing Profiles

### System Administrative Access

* **Username:** admin
* **Password:** admin123

### Faculty Core Access

* **Username:** faculty
* **Password:** faculty123

### Expected Workspace Behavior Matrix

* **Logged in as Admin:** Grants full access to real-time Chart.js metric graphs, PDF summary print export layout configurations, student onboarding forms with dynamic courses dropdown, and all navigation routing cards (Students, Courses, Attendance, Fees).
* **Logged in as Faculty:** Automatically filters out metrics summary panels and charts. Displays only the Attendance Sheets entry tracking card block.
* **Logged in as Student:** Restricts access to administrative tools and charts. Filters the Fees Accounting table to map contextually with their login credentials, displaying only their personal financial entries and invoice statements.

---

## Scalability Considerations

* **Decoupled Architecture:** Using asynchronous background threads via an independent Runnable stack isolates heavy processes like SMTP email dispatch loops away from the main thread, keeping user interface interaction speeds highly responsive.
* **Resource Optimization:** Eliminating polling patterns inside student search panels via direct AJAX fetch loops dramatically reduces unnecessary database transaction overhead, executing state queries exclusively when structural data input mutation occurs.

---

## Author

Krishnali Vivek Kulkarni

```

```
