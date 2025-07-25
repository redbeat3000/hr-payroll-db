# HR & Payroll Database with Compliance

A secure, compliant MySQL database system to manage employee data, payroll, taxes, and attendance.

Repository: [https://github.com/redbeat3000/hr-payroll-db](https://github.com/redbeat3000/hr-payroll-db)

---

## ✅ Key Features

* Salary slabs and automatic tax deduction
* Role-based access (HR, Manager, Admin)
* Historical salary change tracking
* GDPR-compliant masking for PII data
* Stored procedure for payroll calculation

---

## 📦 Installation Guide (MySQL)

### 1. Install MySQL Server

* Ubuntu: `sudo apt install mysql-server`
* Windows/macOS: [https://dev.mysql.com/downloads/mysql/](https://dev.mysql.com/downloads/mysql/)

### 2. Clone the Repository

```bash
git clone https://github.com/redbeat3000/hr-payroll-db.git
cd hr-payroll-db
```

### 3. Login to MySQL

```bash
mysql -u root -p
```

### 4. Create the Database

```sql
CREATE DATABASE hr_payroll_system;
USE hr_payroll_system;
```

### 5. Import Schema

```bash
mysql -u root -p hr_payroll_system < hr-payroll-schema.sql
```

---

## 🔍 Notes

* Ensure the SQL script `hr-payroll-schema.sql` is in the root directory.
* Modify permissions and credentials as needed for production use.
* Additional features like audit logs and data encryption can be added based on requirements.

---

## 🤝 Contributions

Pull requests are welcome! Feel free to fork and submit enhancements, sample data scripts, or other compliance features.

---

## 📄 License

This project is open-source and available under the MIT License.
